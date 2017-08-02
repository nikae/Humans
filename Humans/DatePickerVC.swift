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

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var birthday: Date = Date()
    var dateOfBirth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
   
    
    
    
        func dateChanged(_ sender: UIDatePicker)  {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func xHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneHit(_ sender: UIButton) {
        
        databaseRef = FIRDatabase.database().reference()
        self.databaseRef.child("Users/\(self.uId!)/dateOfBirth").setValue(self.dateOfBirth)
        self.dismiss(animated: true, completion: nil)
        
        let bDayDict:[String: String] = ["bDay": self.dateOfBirth]
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bDayDict"), object: nil, userInfo: bDayDict)
        
    }
}
