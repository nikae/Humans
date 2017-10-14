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
    
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var birthday: Date = Date()
    var dateOfBirth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker)  {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            let a = age(year: year, month: month, day: day)
            if a < 0 || a > 100 {
                let alert = UIAlertController(title: "Incorect age", message: "Please make sure that date of birth is corect", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
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
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
    }


    @IBAction func doneHit(_ sender: UIButton) {
        
        databaseRef = FIRDatabase.database().reference()
        self.databaseRef.child("Users/\(self.uId!)/dateOfBirth").setValue(self.dateOfBirth)
        self.dismiss(animated: true, completion: nil)
        }
}
