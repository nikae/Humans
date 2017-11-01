//
//  DatePickerVC.swift
//  Humans
//
//  Created by Nika on 7/25/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

class DatePickerVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var bdayLabel: UILabel!
    
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var birthday: Date = Date()
    var dateOfBirth = ""
    var bdayAproved: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bdayLabel.text = "Age sharing disabled"
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.dateOfBirth = value?["dateOfBirth"] as? String ?? ""
            
            if self.dateOfBirth != "" {
                let userAge = calculateAge(self.dateOfBirth)
                self.bdayLabel.text = "\(userAge) y/o."
                let bdayDate = self.GetDateFromString(DateStr: self.dateOfBirth)
                self.datePicker.date = bdayDate
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        viewShape(view: doneBtn)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    func GetDateFromString(DateStr: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM d yyyy"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: DateStr)
        return date!
    }
    
    @objc func dateChanged(_ sender: UIDatePicker)  {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            let a = age(year: year, month: month, day: day)
            if a <= 0 || a > 100 {
                let alert = UIAlertController(title: "Incorect age", message: "Please make sure that date of birth is corect", preferredStyle: .alert)
                
                let ok  = UIAlertAction(title: "Ok", style: .cancel) { (void) in
                    if self.dateOfBirth != "" {
                        let bdayDate = self.GetDateFromString(DateStr: self.dateOfBirth)
                        self.datePicker.date = bdayDate
                    } else {
                        self.datePicker.date = Date()
                    }
                }
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            } else {
                dateOfBirth = "\(month) \(day) \(year)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editDataInBackend(_ permistion: Bool) {
        databaseRef = FIRDatabase.database().reference()
        if permistion {
            self.databaseRef.child("Users/\(self.uId!)/dateOfBirth").setValue(self.dateOfBirth)
        } else {
            self.databaseRef.child("Users/\(self.uId!)/dateOfBirth").setValue(nil)
        }
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
            self.doneBtn.setTitle("Location Settings", for: .normal)
        })
    }
    
    func presentConfirmationAlert() {
        let alert = UIAlertController(title: "Please Confirm!", message: "We only share your age with your posts", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
            print("user has canceled location sharing")
        }
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (void) in
            self.editDataInBackend(true)
            self.doneBtnVisualEfectDataEded()
            let userAge = calculateAge(self.dateOfBirth)
            self.bdayLabel.text = "\(userAge) y/o."
            self.bdayAproved = true
            UserDefaults.standard.set(true, forKey: isAgeAproved_Key)
            
            let age:[String: String] = ["age": self.dateOfBirth]
            //MARK: -> post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersage"), object: nil, userInfo: age)
        }
        
        let decline = UIAlertAction(title: "Decline", style: .destructive) { (void) in
            self.editDataInBackend(false)
            self.bdayLabel.text = "Age sharing disabled"
            self.dateOfBirth = ""
            self.datePicker.date = Date()
            self.bdayAproved = false
            UserDefaults.standard.set(false, forKey: isAgeAproved_Key)
            
            let age:[String: String] = ["age": ""]
            //MARK: -> post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersage"), object: nil, userInfo: age)
        }
        
        alert.addAction(confirm)
        alert.addAction(decline)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
    }
    
    
    @IBAction func doneHit(_ sender: UIButton) {
        presentConfirmationAlert()
        dateChanged(datePicker)
    }
}

