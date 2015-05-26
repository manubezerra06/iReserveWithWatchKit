//
//  CreateUserViewController.swift
//  iReserve
//
//  Created by Manuela Bezerra on 07/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import Foundation
import Parse


class CreateUserViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var cadastrarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
    
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
        } else {
            // Show the signup or login screen
        }
    }

    func DismissKeyboard(){
    
        view.endEditing(true)
    
    }


    @IBAction func cadastrarButtonClick(sender: UIButton) {
        
        if(nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Cadastro"
            alert.message = "Você é obrigado a preencher os campos!"
            alert.addButtonWithTitle("Continuar")
            alert.show()
            return
            
        }

        self.cadastrarButton.enabled = false;
        
        var user = PFUser()
        user.username = nameTextField.text
        user.email = emailTextField.text;
        user.password = passwordTextField.text
        user.setObject("free", forKey: "account")

        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                
                self.nameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.cadastrarButton.enabled = true;

                
                let errorString = error.userInfo?["error"] as? NSString
                let alert = UIAlertView()
                alert.title = "Cadastro"
                alert.message = "Ocorreu um erro no seu cadastro!"
                alert.addButtonWithTitle("Continuar")
                alert.show()
                
            } else {
            
                self.nameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.cadastrarButton.enabled = true;
           
                let alert = UIAlertView()
                alert.title = "Cadastro"
                alert.message = "Cadastrado com sucesso!"
                alert.addButtonWithTitle("Continuar")
                alert.delegate = self
                alert.show()
            
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
        NSLog("", "")
    }
    
    

    
}
