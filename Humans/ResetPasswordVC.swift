//
//  ResetPasswordVC.swift
//  Trail Lab
//
//  Created by Nika on 2/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
    }
    
//Mark -Figour out KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            textField.resignFirstResponder()
            performAction()
 
        return true
    }
    
    func performAction() {
        ressetPassword()
    }

    func keyboardDismiss() {
        emailTF.resignFirstResponder()
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
    }
    
    @IBAction func ressetPasswortdHit(_ sender: UIButton) {
        ressetPassword()
    }
    
    func ressetPassword() {
        if emailTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email address", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailTF.text!, completion: { (error) in
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTF.text = ""
                    
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                
            })
        }

    }
}

