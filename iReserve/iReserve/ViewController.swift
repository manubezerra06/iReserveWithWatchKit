//
//  ViewController.swift
//  iReserve
//
//  Created by Felipe Silva  on 5/7/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import UIKit
import MapKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            
            self.performSegueWithIdentifier("toMap", sender: self)
            
        }
    }
    
    func DismissKeyboard(){
        
        view.endEditing(true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loginButton.enabled = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonClick(sender: AnyObject) {
        
        
        if(usernameTextField.text == "" || passwordTextField.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Login"
            alert.message = "Você é obrigado a preencher os campos!"
            alert.addButtonWithTitle("Continuar")
            alert.show()
            return
            
        }
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                self.loginButton.enabled = false
                
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                
                self.performSegueWithIdentifier("toMap", sender: self)
                
                
            } else {
                
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            
                let alert = UIAlertView()
                alert.title = "Login Error"
                alert.message = "Dados informados não conferem, tente novamente"
                alert.addButtonWithTitle("Continuar")
                alert.show()
                
            }
        }
    }    
    
}

