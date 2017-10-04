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


class ProfileVC: UIViewController {
    
    
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
   // @IBOutlet weak var nameLabel: UILabel!
  //  @IBOutlet weak var ageCountrieLabel: UILabel!
    
  //  @IBOutlet weak var editProfilebtn: UIButton!
  //  @IBOutlet weak var btn: UIButton!
 //   @IBOutlet weak var logOutBtn: UIButton!
    
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //viewShape(view: editProfilebtn)
       // viewShape(view: btn)
       // viewShape(view: logOutBtn)
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 15
        backgroundImage.addBlurEffect()
        roundPhoto(imageView: profileImageView)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
       //     let firstName = value?["firstName"] as? String ?? "Nikname"
            let pictureURL = value?["profilePictureUrl"] as? String ?? ""
         //   let bday = value?["dateOfBirth"] as? String ?? ""
        //    let country = value?["country"] as? String ?? ""
            
//            if bday != "" {
//                var bDayArr = bday.components(separatedBy: " ")
//                let month = bDayArr[0]
//                let day = bDayArr[1]
//                let year = bDayArr[2]
//                
//         //       let userAge = age(year: Int(year) ?? 0, month: Int(month) ?? 0 , day: Int(day) ?? 0)
//             //   self.ageCountrieLabel.text = "\(userAge) y/o. \(country)"
//                
//            } else {
//             //   self.ageCountrieLabel.text = "\(country)"
//            }
            
            
           // self.nameLabel.text = "\(firstName)"
           // self.navigationItem.title = "\(firstName)"
            
            if pictureURL != "" {
                let starsRef = FIRStorage.storage().reference(forURL: pictureURL)
                starsRef.downloadURL { url, error in
                    if error != nil {
                        print(error ?? "error")
                    } else {
                        self.profileImageView.alpha = 0.0
                        self.backgroundImage.alpha = 0.0
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.profileImageView.alpha = 1
                            self.backgroundImage.alpha = 1
                            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                            self.backgroundImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
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
        
        
    }
    

    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    

   

}
