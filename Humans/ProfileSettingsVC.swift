//
//  ProfileSettingsVC.swift
//  Humans
//
//  Created by Nika on 7/24/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileSettingsVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var informationBtn: UIButton!
    @IBOutlet weak var disablebtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!

    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.adjustsFontSizeToFitWidth = true
        lastNameLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        ageLabel.adjustsFontSizeToFitWidth = true
        
        roundPhoto(imageView: profileImageView)
        
        viewShape(view: editProfileBtn)
        viewShape(view: btn)
        viewShape(view: informationBtn)
        viewShape(view: disablebtn)
        viewShape(view: logOutBtn)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let firstName = value?["firstName"] as? String ?? "First Name"
            let lastName = value?["lastName"] as? String ?? "Last Name"
            let email = value?["email"] as? String ?? ""
            let pictureURL = value?["profilePictureUrl"] as? String ?? ""
            let bday = value?["dateOfBirth"] as? String ?? ""
            let country = value?["country"] as? String ?? ""
            
            if bday != "" {
                var bDayArr = bday.components(separatedBy: " ")
                let month = bDayArr[0]
                let day = bDayArr[1]
                let year = bDayArr[2]
                
                let userAge = age(year: Int(year) ?? 0, month: Int(month) ?? 0 , day: Int(day) ?? 0)
                self.ageLabel.text = "\(userAge) y/o. \(country)"
                
            } else {
              self.ageLabel.text = "\(country)"
            }
            
            self.firstNameLabel.text = firstName
            self.lastNameLabel.text = lastName
            self.emailLabel.text = email
            
            if pictureURL != "" {
                let starsRef = FIRStorage.storage().reference(forURL: pictureURL)
                starsRef.downloadURL { url, error in
                    if error != nil {
                        print(error ?? "error")
                    } else {
                        self.profileImageView.alpha = 0.0
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.profileImageView.alpha = 1
                            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                        })
                        self.profileImageView.setShowActivityIndicator(true)
                        self.profileImageView.setIndicatorStyle(.gray)
                    }
                }
                
            } else {
                self.profileImageView.image = UIImage(named: "default-avatar")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let imageDataDict:[String: Bool] = ["image": true]
        
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let imageDataDict:[String: Bool] = ["image": false]
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func editProfileHit(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func btnHit(_ sender: UIButton) {
    }
    
    @IBAction func infoHit(_ sender: UIButton) {
    }
    
    @IBAction func disableHit(_ sender: UIButton) {
    }
    
    @IBAction func logOutHit(_ sender: UIButton) {
        keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
        keepMeLogedInDefoultsDefoults.synchronize()
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

}
