//
//  SettingsVC.swift
//  Humans
//
//  Created by Nika on 7/24/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

   // @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
   // @IBOutlet weak var doneBtn: UIButton!
   // @IBOutlet weak var editProfileBtn: UIButton!
   // @IBOutlet weak var dateBtn: UIButton!
   // @IBOutlet weak var countryBtn: UIButton!
   // @IBOutlet weak var stackView: UIStackView!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    var picURL = ""
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        roundPhoto(imageView: profileImage)
//        viewShape(view: doneBtn)
//        viewShape(view: dateBtn)
//        viewShape(view: countryBtn)
        
        nameTF.delegate = self
        emailTF.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "bDayDict"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.usersCountry(_:)), name: NSNotification.Name(rawValue: "userscountry"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String ?? ""
          //  let pictureURL = value?["profilePictureUrl"] as? String ?? ""
            let email = value?["email"] as? String ?? "Email"
            let bday = value?["dateOfBirth"] as? String ?? ""
          //  let country = value?["country"] as? String ?? "No country specified"
            
            if bday != "" {
                var bDayArr = bday.components(separatedBy: " ")
                let month = bDayArr[0]
                let day = bDayArr[1]
                let year = bDayArr[2]
                
          //      let userAge = age(year: Int(year) ?? 0, month: Int(month) ?? 0 , day: Int(day) ?? 0)
               // self.dateBtn.setTitle("\(userAge) y/o", for: .normal)
            } else {
           //     self.dateBtn.setTitle("Date of birth", for: .normal)
            }
            
           // self.countryBtn.setTitle("\(country)", for: .normal)
            self.emailTF.placeholder = email
            self.nameTF.text = firstName.capitalized
            
//            if pictureURL != "" {
//                let starsRef = FIRStorage.storage().reference(forURL: pictureURL)
//                starsRef.downloadURL { url, error in
//                    if error != nil {
//                        print(error ?? "error")
//                    } else {
//                     //   self.profileImage.alpha = 0.0
//                        UIView.animate(withDuration: 1, animations: {
//                        self.profileImage.alpha = 1
//                        self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
//                        })
//
//                        self.profileImage.setShowActivityIndicator(true)
//                        self.profileImage.setIndicatorStyle(.gray)
//                    }
//                }
//                self.picURL = pictureURL
//            } else {
//                self.profileImage.image = UIImage(named: "default-avatar")
//            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
//    deinit {
//        databaseRef.child("Users").removeObserver(withHandle: _refHandle)
//    }
    
    //Mark: -> handle notification
//    func showSpinningWheel(_ notification: NSNotification) {
//        let dateofb = (notification.userInfo?["bDay"] as? String)
//
//        if dateofb != "" {
//            var bDayArr = dateofb?.components(separatedBy: " ")
//            let month = bDayArr?[0]
//            let day = bDayArr?[1]
//            let year = bDayArr?[2]
//            let userAge = age(year: Int(year!) ?? 0, month: Int(month!) ?? 0 , day: Int(day!) ?? 0)
//            self.dateBtn.setTitle("\(userAge) y/o", for: .normal)
//        } else {
//            self.dateBtn.setTitle("Date of birth", for: .normal)
//        }
//    }
    
//    func usersCountry(_ notification: NSNotification) {
//        let uCountry = (notification.userInfo?["location"] as? String)
//        self.countryBtn.setTitle(uCountry, for: .normal)
//    }
    
    //Mark: -> Figour out KeyBoard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .lightGray
//            self.editProfileBtn.isEnabled = false
//            self.dateBtn.isEnabled = false
//            self.countryBtn.isEnabled = false
//            self.profileImage.alpha = 0.5
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .white
//            self.editProfileBtn.isEnabled = true
//            self.dateBtn.isEnabled = true
//            self.countryBtn.isEnabled = true
//            self.profileImage.alpha = 1
//            
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height - 150
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissKeyboardTap(_ sender: UITapGestureRecognizer) {
        keyboardDismiss(tf: nameTF)
        keyboardDismiss(tf: emailTF)
    }
    
//MARK: -Camera / Add Picture
    func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController(title: "Edit Photo", message: "", preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) {(action: UIAlertAction) in
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
               // self.profileImage.image = UIImage(named:"default-avatar")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) {
                (action: UIAlertAction) in
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
    
    //MARK: -> Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if picURL != "" {
            delataImage(url: picURL)
            }
            
           // profileImage.image = image
            saveImage(image)
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image:UIImage) {
        storageRef = FIRStorage.storage().reference(forURL: "gs://humans-16dc5.appspot.com/ProfilePictures")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imagePath = "\(Date.timeIntervalSinceReferenceDate * 1000).jpg"
        let uploasTask = self.storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
           
            self.picURL = metadata!.downloadURL()!.absoluteString
            self.databaseRef.child("Users/\(self.uId!)/profilePictureUrl").setValue(self.picURL)
            print("self.picURL: \(self.picURL)")
        }
        
        uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
            
            guard self != nil else {return}
            guard let progress = snapshot.progress else {return}
            print(Float(progress.fractionCompleted))
        })
    }
    
    func delataImage(url: String) {
        let storageRef = FIRStorage.storage().reference()
        let desertRef = storageRef.storage.reference(forURL: url)
        
        desertRef.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Image Is delated")
            }
        }
    }

   // @IBAction func editProfilePictureHit(_ sender: UIButton) {
  //      addPhoto()
  //  }
    
//    func presentProfileView(){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    func presentAlert(title: String, message: String ) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    @IBAction func dateHit(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true, completion: nil)
//    }
    
//    @IBAction func countyHit(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true, completion: nil)
//    }
    
//    @IBAction func doneHit(_ sender: UIButton) {
//        if nameTF.text != "" {
//            let firstName = self.nameTF.text
//            let email = self.emailTF.text
//
//            if email != "" {
//                FIRAuth.auth()?.currentUser?.updateEmail(email!) { (error) in
//                    if error == nil {
//                        self.databaseRef.child("Users/\(self.uId!)/email").setValue(email)
//                        self.presentProfileView()
//                    } else {
//                        self.presentAlert(title: "Error", message: (error?.localizedDescription)!)
//                    }
//                }
//            } else {
//                presentProfileView()
//            }
//
//            //MARK -Edit user values at firebase
//            self.databaseRef.child("Users/\(uId!)/firstName").setValue(firstName?.capitalized)
//        } else {
//            presentAlert(title: "Please provide nikname", message: "")
//        }
//    }
}

