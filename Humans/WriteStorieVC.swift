//
//  WriteStorieVC.swift
//  Humans
//
//  Created by Nika on 8/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class WriteStorieVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headlineTF: UITextField!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headlineTF.delegate = self
        textView.delegate = self
        
        textViewShape(TV: textView)
        
        viewShape(view: postBtn)
        viewShape(view: backButton)

        let stopScrollingDict:[String: Bool] = ["stopScrolling": true]
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        let stopScrollingDict:[String: Bool] = ["stopScrolling": false]
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: -> Figour out KeyBoard
    func keyboardWillShow(notification: NSNotification) {
        if headlineTF.isFirstResponder != true {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .lightGray
            self.postBtn.isEnabled = false
            self.backButton.isEnabled = false
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if headlineTF.isFirstResponder != true {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .white
            self.postBtn.isEnabled = true
           self.backButton.isEnabled = true
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height - 150
                
            }
        }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        keyboardDismiss(tf: headlineTF)
        textView.resignFirstResponder()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func languageHit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagePickerVC") as! LanguagePickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func postHit(_ sender: UIButton) {
    }
    
    @IBAction func backHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
