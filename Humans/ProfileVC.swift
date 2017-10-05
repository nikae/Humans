//
//  ProfileVC.swift
//  Humans
//
//  Created by Nika on 10/2/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
}


class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    var picURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 15
        backgroundImage.addBlurEffect()
        roundPhoto(imageView: profileImageView)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let pictureURL = value?["profilePictureUrl"] as? String ?? ""
            
            if pictureURL != "" {
                let starsRef = FIRStorage.storage().reference(forURL: pictureURL)
                starsRef.downloadURL { url, error in
                    if error != nil {
                        print(error ?? "error")
                    } else {
                        self.profileImageView.alpha = 0.0
                        self.backgroundImage.alpha = 0.0
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.profileImageView.alpha = 1
                            self.backgroundImage.alpha = 1
                            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                            self.backgroundImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                        })
                        self.profileImageView.setShowActivityIndicator(true)
                        self.backgroundImage.setIndicatorStyle(.gray)
                    }
                }
                
            } else {
                self.profileImageView.image = UIImage(named: "default-avatar")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardishere(_:)), name: NSNotification.Name(rawValue: "keyboardIsUp"), object: nil)
        
    }
  
    func keyboardishere(_ notification: NSNotification) {
        let dateofb = (notification.userInfo?["keyboardIsUp"] as? Bool)
        
        if dateofb == true {
            print(true)
          //  if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -=  150
                }
          //  }
        } else {
            print(false)
          //  if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y =  0
                }
            }
       // }
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
            
             profileImageView.image = image
            backgroundImage.image = image
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
    
    @IBAction func editPhotoHit(_ sender: UIButton) {
        addPhoto()
    }
    
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    

   

}
