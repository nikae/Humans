//
//  LanguagePickerVC.swift
//  Humans
//
//  Created by Nika on 8/16/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class LanguagePickerVC: UIViewController {
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapHit(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneHit(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
