//
//  InterfaceController.swift
//  iReserve WatchKit Extension
//
//  Created by Manuela Bezerra on 20/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import WatchKit


class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet var productTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        loadTableData()
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    func loadTableData(){
        
        var request = ["request": "getMeusProdutos"]
        WKInterfaceController.openParentApplication(request, reply:{(replyFromParent, error) -> Void in
            
            println(error)
            
            if error != nil{
                println("tem um erro")
            }
            else{
                println("passou")
                println(replyFromParent["products"]!)
                
                
                let products = replyFromParent["products"] as! [String]
                
                
                self.productTable.setNumberOfRows(products.count, withRowType: "ReservaRowViewController")
                
                
                
                for i in 0..<products.count
                {
                     if let row = self.productTable.rowControllerAtIndex(i) as? ReservaRowViewController
                     {
                        row.nameLabel.setText(products[i])

                    }
                }
                
            }
            
        })
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
}
