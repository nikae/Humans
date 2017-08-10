//
//  ViewController.swift
//  Humans
//
//  Created by Nika on 7/13/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let V1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NC1") as! NC1
        let v2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileNC") as! ProfileNC
        
        self.addChildViewController(V1)
        self.scrollView.addSubview(V1.view)
        self.didMove(toParentViewController: self)
        
        self.addChildViewController(v2)
        self.scrollView.addSubview(v2.view)
        self.didMove(toParentViewController: self)
        
        V1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        v2.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        var v2Frame: CGRect = v2.view.frame
        v2Frame.origin.x = self.view.frame.width
        v2.view.frame = v2Frame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
    
    // handle notification
    func showSpinningWheel(_ notification: NSNotification) {
        
        if (notification.userInfo?["stopScrolling"] as? Bool) == true {
            self.scrollView.isScrollEnabled = false
        } else {
            self.scrollView.isScrollEnabled = true
        }
    }

}

