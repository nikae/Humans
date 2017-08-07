//
//  VideoPreviewVC.swift
//  Humans
//
//  Created by Nika on 8/7/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import SCRecorder

class VideoPreviewVC: UIViewController {
    
    
    
    @IBOutlet weak var previewView: UIView!

    let session = SCRecordSession()
    let player = SCPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "vid"), object: nil)
        
        
        player.setItemBy(session.assetRepresentingSegments())
        let playerLayer = AVPlayerLayer(player: player)
        let bounds = previewView.bounds
        playerLayer.frame = bounds
        previewView.layer.addSublayer(playerLayer)
        
       

        // Do any additional setup after loading the view.
    }

    //Mark: -> handle notification
    func showSpinningWheel(_ notification: NSNotification) {
        let dateofb = (notification.userInfo?["vid"] as? NSURL)
        
        player.play()
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
    @IBAction func saveHit(_ sender: UIButton) {
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                (url as NSURL?)?.saveToCameraRoll(completion: { (path, error) in
                    debugPrint(path ?? "", error ?? "")
                })
            } else {
                debugPrint(error ?? "")
            }
        }

    }

}
