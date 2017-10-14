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
    
 //   @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var ageAndCountrieLabel: UILabel!
    @IBOutlet weak var infoAndContactBtn: UIButton!
    @IBOutlet weak var disableMyAcoountBtn: UIButton!
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    
//    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var ageLabel: UILabel!
    
//    @IBOutlet weak var editProfileBtn: UIButton!
//    @IBOutlet weak var btn: UIButton!
//    @IBOutlet weak var informationBtn: UIButton!
//    @IBOutlet weak var disablebtn: UIButton!
//    @IBOutlet weak var logOutBtn: UIButton!

    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var country = ""
    var bday = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        firstNameLabel.adjustsFontSizeToFitWidth = true
        ageAndCountrieLabel.adjustsFontSizeToFitWidth = true
        
        viewShape(view: infoAndContactBtn)
        viewShape(view: disableMyAcoountBtn)
        viewShape(view: logOutBtn)
        viewShape(view: doneBtn)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let firstName = value?["firstName"] as? String ?? "First Name"
            self.bday = value?["dateOfBirth"] as? String ?? ""
            self.country = value?["country"] as? String ?? ""
            
            if self.bday != "" {
                let userAge = self.calculateAge(self.bday)
                self.ageAndCountrieLabel.text = "\(userAge) y/o. \(self.country)"
                
            } else {
                self.ageAndCountrieLabel.text = "\(self.country)"
            }
            
            self.firstNameLabel.text = firstName
 
        }) { (error) in
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.usersCountry(_:)), name: NSNotification.Name(rawValue: "userscountry"), object: nil)
    }
    
    func calculateAge(_ uAge: String) -> Int {
        var bDayArr = uAge.components(separatedBy: " ")
        let month = bDayArr[0]
        let day = bDayArr[1]
        let year = bDayArr[2]
        return age(year: Int(year) ?? 0, month: Int(month) ?? 0 , day: Int(day) ?? 0)
    }
    
   @objc func usersCountry(_ notification: NSNotification) {
        let uCountry = (notification.userInfo?["location"] as? String)
        self.country = uCountry ?? ""
    if self.bday != "" {
        let userAge = self.calculateAge(self.bday)
        self.ageAndCountrieLabel.text = "\(userAge) y/o. \(self.country)"
    } else {
        self.ageAndCountrieLabel.text = "\(self.country)"
    }
    }
    
    @IBAction func infoHit(_ sender: UIButton) {
        print("info goew here")
    }

    @IBAction func disableHit(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to disable your account?", message: "Disabled accounts cannot be searched or viewed by other users.", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let continu = UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
            let alert = UIAlertController(title: "Disabling your account", message: "Your account will be disabled but can be reactivated by logging in.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) in
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("Users/\(self.uId!)/isActive").setValue(false)
                keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()

                if FIRAuth.auth()?.currentUser != nil {
                    do {
                        try FIRAuth.auth()?.signOut()
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                        self.present(vc, animated: true, completion: nil)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            })

            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        })

        alert.addAction(continu)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func logOutHit(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Out", message: "Do you want to log out?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
            keepMeLogedInDefoultsDefoults.synchronize()

            if FIRAuth.auth()?.currentUser != nil {
                do {
                    try FIRAuth.auth()?.signOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                    self.present(vc, animated: true, completion: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneHit(_ sender: UIButton) {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.dismiss(animated: true, completion: nil)
    }
    
}
