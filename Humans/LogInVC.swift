//
//  LogInVC.swift
//  Trail Lab
//
//  Created by Nika on 2/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

let keepMeLogedInDefoultsDefoults = UserDefaults.standard
let keepMeLogedInDefoults_key = "keepMeLogedInDefoults_key"

class LogInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
 
    @IBOutlet weak var keepMeLoggedIn: UIButton!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    

    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    var picURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        switch (keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)) {
        case true:
            let image = UIImage(named: "Checked Checkbox 2_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
            
        case false:
            let image = UIImage(named: "Unchecked Checkbox_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
            
        }
        }
   
//Mark: -> Figour out KeyBoard
    //MARK: -> View Up/Down
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 70
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 70
            }
        }
    }
//End: -> View Up/Down
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.returnKeyType = .done
            textField.resignFirstResponder()
            logIn()
        }
        return true
    }
    
    func keyboardDismiss() {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
    }
    
    @IBAction func logInHit(_ sender: Any) {
        logIn()
    }
//End: -> Figour out KeyBoard
    
    func logIn(){
        if emailTF.text == "" || passwordTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (user, error) in
                if error == nil {
                    let uId = FIRAuth.auth()?.currentUser?.uid
                    if uId != nil {
                        self.databaseRef.child("Users/\(uId!)/isActive").setValue(true)
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                keepMeLoggedIn.setTitle("☑︎", for: .normal)
                keepMeLogedInDefoultsDefoults.set(true, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
            } else {
                keepMeLoggedIn.setTitle("◻︎", for: .normal)
                keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
            }
        }
    }
    
    @IBAction func keepMeLoggedInHit(_ sender: UIButton) {
        launchBool = !launchBool
    }
    
}
