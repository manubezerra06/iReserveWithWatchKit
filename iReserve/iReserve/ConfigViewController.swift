//
//  ConfigViewController.swift
//  iReserve
//
//  Created by Manuela Bezerra on 07/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import UIKit
import Parse

class ConfigViewController: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    //HANDOFF
    @IBOutlet weak var handoffLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
          self.usernameLabel.text =  "Você está logado como: " + currentUser!.username!
          self.emailLabel.text = "Email: " + currentUser!.email!
        }
        
    }
    
    @IBAction func logoutButtonClick(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.logoutButton.enabled = false
        
        self.usernameLabel.text = ""
        self.emailLabel.text = ""
        
        self.performSegueWithIdentifier("toLogin", sender: self)
    }
    
    //HANDOFF
    override func restoreUserActivityState(activity: NSUserActivity) {
    
        let userInfo = activity.userInfo
        handoffLbl.text =  userInfo!["xablau"] as? String
        
        super.restoreUserActivityState(activity)
    }
    
}
