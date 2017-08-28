//
//  LanguagePickerVC.swift
//  Humans
//
//  Created by Nika on 8/16/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class LanguagePickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var picker: UIPickerView!
    
    var languageData = [String]()
    var holder = [String : String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        
        picker.delegate = self
        picker.dataSource = self
        
        readJson()
    }
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "Languages", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: AnyObject] {
                    
                    for i in object {
                        holder[i.value["name"] as! String] = i.value["nativeName"]! as? String
                        languageData.append(i.value["name"] as! String)
                        languageData.sort { return $0 < $1 }
                        print(languageData)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.textAlignment = .center
        }
        
        let a = languageData[row]
        let b = holder[a] ?? ""
       
        pickerLabel?.text = "\(a) / \(String(describing: b))"
       // pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
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
