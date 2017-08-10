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
        
        let stopScrollingDict:[String: Bool] = ["stopScrolling": true]
        
        //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let stopScrollingDict:[String: Bool] = ["stopScrolling": false]
        //MARK: -> post a notification
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
    
    @IBAction func uploadHit(_ sender: UIButton) {
        print("upload function goes here")
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
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        //vc.titlef = title
        //vc.boddy = boddy
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func timeHit(_ sender: UIButton) {
       // popUp(title: "Time", boddy: "Time's Body")
        print("aaa")
    }
    @IBAction func ideaHit(_ sender: UIButton) {
        //popUp(title: "idea", boddy: "Ideas's Body")
         print("aaa")
    }
    @IBAction func comentsHit(_ sender: UIButton) {
       // popUp(title: "Coments", boddy: "Coments's Body")
         print("aaa")
    }
    
    @IBAction func privateHit(_ sender: UIButton) {
      //  popUp(title: "Privacy", boddy: "Privacy's Body")
         print("aaa")
    }
    @IBAction func languageHit(_ sender: UIButton) {
       // popUp(title: "Language", boddy: "Language's Body")
         print("aaa")
    }
    @IBAction func infoAndHelpHit(_ sender: UIButton) {
       // popUp(title: "Info And Help", boddy: "Info And Help's Body")
         print("aaa")

    }

}
