//
//  ProductTableViewController.swift
//  iReserve
//
//  Created by Igor Kimieciki on 08/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import Foundation
import MapKit
import Parse
import ParseUI
import UIKit
//import StoreKit

class ProductTableMapViewController: PFQueryTableViewController//, SKPaymentTransactionObserver, SKProductsRequestDelegate , UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var optionSegmentedControl: UISegmentedControl!
    
    //var product: SKProduct?
    var productID = "premium"

    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
     /* func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!){
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                    switch trans.transactionState {
                        case .Purchasing:
                            println("Purchasing Product");
                            break;
                        case .Failed:
                            println("Purchase Failed");
                            break;
                        case .Restored:
                            println("Product Restored");
                            break;
                        case .Purchased:
                                println("Product Purchased");
                                SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                            break;
                        default:
                            break;
                
                    };
            }

        }
    }*/
    
    @IBAction func optionIndexChanged(sender: UISegmentedControl) {
        
        self.loadObjects()
    }
    
   /* func getProductInfo()
    {
        if SKPaymentQueue.canMakePayments() {
        let request = SKProductsRequest(productIdentifiers:
            NSSet(objects: self.productID) as Set<NSObject>)
        request.delegate = self
        request.start()
        }
    }*/
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        //getProductInfo()
    }
    
    
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
            println(response) // [SKProduct]
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Product"
        
        self.textKey = "objectId"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        
    
        if(self.optionSegmentedControl.selectedSegmentIndex == 0)
        {
        var query = PFQuery(className: "Product")
        var query2 = PFQuery(className: "Product")
        
        
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
        
        query.whereKey("reservedAt", lessThanOrEqualTo: yesterday!)
        
        query2.whereKeyDoesNotExist("reservedAt")
        
        
        let queryFinal = PFQuery.orQueryWithSubqueries([query, query2])
        
            return queryFinal
        }
        
        else{
        
            var query3 = PFQuery(className: "Product")
            query3.whereKey("reservedBy", equalTo: PFUser.currentUser()!.username!)
            return query3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> ProductViewCell? {
        
        let cellIdentifier = "ProductCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ProductViewCell
        if cell == nil {
            cell = ProductViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        var date = object?["reservedAt"] as? NSDate
        
        cell?.titleLabel.text = object?["name"] as? String
        
        cell?.descLabel.text =  object?["description"] as? String
        
        var price = object?["price"] as?Float
        
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        formatter.stringFromNumber(price!)
        
        
        cell?.priceLabel.text = formatter.stringFromNumber(price!)
        
        cell?.reservarButton.tag = indexPath.row
        
        cell?.reservarButton.addTarget(self, action: "reservarButtonClick:", forControlEvents:
            UIControlEvents.TouchUpInside)
        
        cell?.productId = object?.objectId;

        
        if(self.optionSegmentedControl.selectedSegmentIndex == 0)
        {

            cell?.reservadoLabel.text = "Reservado!"
            cell?.reservadoLabel.hidden = true
            cell?.reservarButton.hidden = false
        }
        else{
            cell?.reservarButton.hidden = true
            let calendar = NSCalendar.currentCalendar()
            let expirationDate = calendar.dateByAddingUnit(.CalendarUnitDay, value: +1, toDate: object?["reservedAt"] as! NSDate, options: nil)
            
            if(expirationDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending)
            {
                var date = expirationDate!
                var formatter = NSDateFormatter()
                formatter.dateFormat = "dd/MM/YYYY - HH:mm"
                var dataFormatada = formatter.stringFromDate(date) as String
                cell?.reservadoLabel.text = "Expira em: " + dataFormatada
            }
            
            else{
            
                cell?.reservadoLabel.text = "Reserva expirada"
            
            }
                cell?.reservadoLabel.hidden = false
        }
        
        return cell
    }
    
    func reservarButtonClick(btn:UIButton!) {
        
        var user = PFUser.currentUser()
        var acccount = user?["account"] as! String
        if (acccount == "free"){
            
        
            var alert = UIAlertController(title: "A sua conta é free",
                message: "Você precisa adquirir a conta premium para efetuar reservas no app!",
            preferredStyle: .Alert)

        
            let saveAction = UIAlertAction(title: "Comprar",
                style: .Default) { (action: UIAlertAction!) -> Void in
                    
                    //let payment = SKPayment(product: self.product)
                    //SKPaymentQueue.defaultQueue().addPayment(payment)
                    PFUser.currentUser()?["account"] = "premium"
                    PFUser.currentUser()?.saveInBackground()

            }
        
            var cancelAction = UIAlertAction(title: "Cancelar",
                    style: .Default) { (action: UIAlertAction!) -> Void in
            }

            alert.addAction(cancelAction)
            alert.addAction(saveAction)

            presentViewController(alert,
            animated: true,
            completion: nil)

        
            return
            
        } else {
            var bntPosition = btn.convertPoint(CGPointZero, toView: self.tableView)
            var indexPath = self.tableView.indexPathForRowAtPoint(bntPosition)
            var cell =  self.tableView.cellForRowAtIndexPath(indexPath!) as! ProductViewCell
            
            var query = PFQuery(className:"Product")
            query.getObjectInBackgroundWithId(cell.productId) {
                (product: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    
                } else if let product = product {
                    product["reservedBy"] = user?.username
                    let now = NSDate()
                    product["reservedAt"] = now
                    product.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError?) -> Void in
                        if(success){
                            btn.hidden = true;
                            cell.reservadoLabel.hidden = false
                            //Notificações para produtos
                            let notification:UILocalNotification = UILocalNotification()
                            notification.alertBody = "Sua reserva expirou!"
                            let c = NSCalendar.currentCalendar()
                            //let tomorrow = c.dateByAddingUnit(.CalendarUnitDay, value: +1, toDate: NSDate(), options: nil)
                            let tomorrow = now.dateByAddingTimeInterval(10)
                            notification.fireDate = tomorrow
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                            
                            let secondNotification: UILocalNotification = UILocalNotification()
                            secondNotification.alertBody = "Sua reserva vai expirar daqui uma hora!"
                            //let data = now.dateByAddingTimeInterval(60*60*23)
                            let data = now.dateByAddingTimeInterval(5)
                            secondNotification.fireDate = data
                            UIApplication.sharedApplication().scheduleLocalNotification(secondNotification)
                            // UIApplication.sharedApplication().can
                        } else {
                            cell.reservadoLabel.text = "Erro!"
                        }
                    }
                    
                }
            }
            
            
        }
        
    }
}
