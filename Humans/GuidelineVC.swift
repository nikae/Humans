//
//  GuidelineVC.swift
//  Humans
//
//  Created by Nika on 8/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class GuidelineVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textFiled: UITextView!
    
    var titlef = ""
    var boddy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        
        label.text = titlef
        textFiled.text = boddy
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DismissHit(_ sender: UIButton) {
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
