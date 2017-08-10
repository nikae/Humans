//
//  WriteStorieVC.swift
//  Humans
//
//  Created by Nika on 8/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class WriteStorieVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
