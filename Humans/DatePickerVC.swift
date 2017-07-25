//
//  DatePickerVC.swift
//  Humans
//
//  Created by Nika on 7/25/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    
    var birthday: Date = Date()
    
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
                    print("wrong age")
                } else {
                    print("\(month) \(day) \(year)")
                    print("\(a) years old")
                }
            }
        }
    
        func age(year: Int, month: Int, day: Int) -> Int {
            let now = Date()
            let myDOB = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
            let myAge = Calendar.current.dateComponents([.year], from: myDOB, to: now).year
            return myAge ?? 1
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
        self.dismiss(animated: true, completion: nil)
    }
}
