//
//  GlanceController.swift
//  iReserve WatchKit Extension
//
//  Created by Manuela Bezerra on 20/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var reservasLabel: WKInterfaceLabel!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.updateUserActivity("ireserveWK.com.Glance", userInfo: ["xablau": "Veio do Handoff!"], webpageURL: nil)
    }

    override func willActivate() {
        super.willActivate()
        
        var request = ["request": "getReservas"]
        WKInterfaceController.openParentApplication(request, reply:{(replyFromParent, error) -> Void in
        
            if error != nil{
            println("tem um erro")
            }
            else{
            println("passou")
            println(replyFromParent)
                self.reservasLabel.setText(replyFromParent["replay"]as? String)
            }

        
        
        })
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
