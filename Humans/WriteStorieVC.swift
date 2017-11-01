//
//  WriteStorieVC.swift
//  Humans
//
//  Created by Nika on 8/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

class WriteStorieVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headlineTF: UITextField!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    var picURL = ""
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headlineTF.delegate = self
        textView.delegate = self
        
        textViewShape(TV: textView)
        viewShape(view: postBtn)
        viewShape(view: backButton)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.country = value?["country"] as? String ?? ""
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //MARK: -> post a notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Mark: -> Figour out KeyBoard
    @objc func keyboardWillShow(notification: NSNotification) {
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
    
    @objc func keyboardWillHide(notification: NSNotification) {
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
    
    //MARK: -Camera / Add Picture
    func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController(title: "Edit Photo", message: "", preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) {(action: UIAlertAction) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) {(action: UIAlertAction) in
            print("User Action Has Canceld")
        }
        
        let delete = UIAlertAction(title: "Delete Image", style: .default) {(action: UIAlertAction) in
            let alertController = UIAlertController(title: "Delete?", message: "Do you want to delete profile picture?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .default) {(action: UIAlertAction) in
                print(self.picURL)
                self.delataImage(url: self.picURL)
                self.imageView.image = UIImage(named:"1")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) {(action: UIAlertAction) in
                print("User Action Has Canceld")
            }
            
            alertController.addAction(cancel)
            alertController.addAction(delete)
            self.present(alertController, animated: true, completion: nil)
        }
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if picURL != "" {
                delataImage(url: picURL)
            }
            
            imageView.image = image
            saveImage(image)
        } else {
            print("Somthing went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image:UIImage) {
        storageRef = FIRStorage.storage().reference(forURL: "gs://humans-16dc5.appspot.com/PostImages")
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imagePath = "\(Date.timeIntervalSinceReferenceDate * 1000).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploasTask = self.storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
            
            self.picURL = metadata!.downloadURL()!.absoluteString
            print("self.picURL: \(self.picURL)")
        }
        
        uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
            
            guard self != nil else {return}
            guard let progress = snapshot.progress else {return}
            
            print(Float(progress.fractionCompleted))
            print(progress)
        } )
    }
    
    func delataImage(url: String) {
        let storageRef = FIRStorage.storage().reference()
        let desertRef = storageRef.storage.reference(forURL: url)
        
        // Delete the file
        desertRef.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Image Is delated")
            }
        }
    }
    
    @IBAction func imagePickerHit(_ sender: UIButton) {
        addPhoto()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        keyboardDismiss(tf: headlineTF)
        textView.resignFirstResponder()
    }
    
    @IBAction func languageHit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagePickerVC") as! LanguagePickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func postHit(_ sender: UIButton) {
        let postDate = getDate()
        postToDatabase(autorId: uId ?? "", createdAt: postDate, videoUrl: "", imageUrl: picURL, headLine: headlineTF.text ?? "", description: textView.text ?? "", language: "", likes: [], coments: [], favorites: [], location: country)
    }
    
    @IBAction func backHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
