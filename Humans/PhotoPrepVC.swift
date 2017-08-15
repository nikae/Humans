//
//  PhotoPrepVC.swift
//  Humans
//
//  Created by Nika on 8/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class PhotoPrepVC: UIViewController {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: recordBtn)
        viewShape(view: uploadBtn)
        
        //MARK: -> post a notification
        let stopScrollingDict:[String: Bool] = ["stopScrolling": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: -> post a notification
        let stopScrollingDict:[String: Bool] = ["stopScrolling": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //MARK: -> post a notification
        let stopScrollingDict:[String: Bool] = ["stopScrolling": false]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordHit(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        self.present(vc, animated: true, completion: nil)
    }
    

    @IBAction func writeHit(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WriteStorieVC") as! WriteStorieVC
        self.present(vc, animated: true, completion: nil)
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func popUp(title: String, boddy: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuidelineVC") as! GuidelineVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.titlef = title
        vc.boddy = boddy
        self.present(vc, animated: true, completion: nil)
    }
    
    let time = videoGuideLinesLibrary["Time"]!
    let ideas = videoGuideLinesLibrary["Ideas"]!
    let coments = videoGuideLinesLibrary["Coments"]!
    let privacy = videoGuideLinesLibrary["Privacy"]!
    let language = videoGuideLinesLibrary["Language"]!
    let info = videoGuideLinesLibrary["Info"]!
    
    @IBAction func timeHit(_ sender: UIButton) {
        popUp(title: time["title"]!, boddy: time["boddy"]!)
    }
    @IBAction func ideaHit(_ sender: UIButton) {
        popUp(title: ideas["title"]!, boddy: ideas["boddy"]!)
    }
    @IBAction func comentsHit(_ sender: UIButton) {
        popUp(title: coments["title"]!, boddy: coments["boddy"]!)
    }
    
    @IBAction func privateHit(_ sender: UIButton) {
       popUp(title: privacy["title"]!, boddy: privacy["boddy"]!)
    }
    @IBAction func languageHit(_ sender: UIButton) {
        popUp(title: language["title"]!, boddy: language["boddy"]!)
     
    }
    @IBAction func infoAndHelpHit(_ sender: UIButton) {
       popUp(title: info["title"]!, boddy: info["boddy"]!)

    }

}
