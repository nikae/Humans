//
//  SettingsVC.swift
//  Humans
//
//  Created by Nika on 7/24/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import SDWebImage


class SettingsVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
  
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    var picURL = ""
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
      
        nameTF.delegate = self
        emailTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String ?? ""
            let email = value?["email"] as? String ?? "Email"
    
            self.emailTF.placeholder = email
            self.nameTF.text = firstName.capitalized

        }) { (error) in
            print(error.localizedDescription)
        }
    }

    //Mark: -> Figour out KeyBoard
    @objc func keyboardWillShow(notification: NSNotification) {
        //MARK: -> post a notification
        let bDayDict:[String: Bool] = ["keyboardIsUp": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardIsUp"), object: nil, userInfo: bDayDict)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let bDayDict:[String: Bool] = ["keyboardIsUp": false]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardIsUp"), object: nil, userInfo: bDayDict)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        } else {
            presentConfirmationAlert()
        }
        return true
    }
    
    @IBAction func dismissKeyboardTap(_ sender: UITapGestureRecognizer) {
        keyboardDismiss(tf: nameTF)
        keyboardDismiss(tf: emailTF)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    func doneBtnVisualEfectDataEded() {
        self.doneBtn.setTitleColor(pinkColor, for: .normal)
        self.doneBtn.setTitle("...", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
           // self.doneBtn.titleLabel?.textColor = pinkColor
            self.doneBtn.setTitle("...Done", for: .normal)
             playSystemSound(id: 1055)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
            self.doneBtn.setTitleColor(grayColor, for: .normal)
            self.doneBtn.setTitle("Submit", for: .normal)
        })
    }
    
    func presentConfirmationAlert() {
        let alert = UIAlertController(title: "Please Confirm!", message: "Confirm to update your information", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
            keyboardDismiss(tf: self.nameTF)
            keyboardDismiss(tf: self.emailTF)
        }
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (void) in
            keyboardDismiss(tf: self.nameTF)
            keyboardDismiss(tf: self.emailTF)
            self.editDataInBackend()
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func editDataInBackend() {
        if nameTF.text != "" {
            let firstName = self.nameTF.text
            let email = self.emailTF.text
            
            if email != "" {
                FIRAuth.auth()?.currentUser?.updateEmail(email!) { (error) in
                    if error == nil {
                        self.databaseRef.child("Users/\(self.uId!)/email").setValue(email)
                        self.doneBtnVisualEfectDataEded()
                    } else {
                        self.presentAlert(title: "Error", message: (error?.localizedDescription)!)
                    }
                }
            } 
            
            //MARK -Edit user values at firebase
            self.databaseRef.child("Users/\(uId!)/firstName").setValue(firstName?.capitalized)
            doneBtnVisualEfectDataEded()
            
        } else {
            presentAlert(title: "Please provide nikname", message: "")
        }
    }
    
    @IBAction func doneHit(_ sender: UIButton) {
       presentConfirmationAlert()
    }
}

