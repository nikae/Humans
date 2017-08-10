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
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!

    @IBOutlet weak var controlView: UIView!
    
    var session = SCRecordSession()
    let recorder = SCRecorder()
    let player = SCPlayer()
    var playerLayer = CALayer()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlView.layer.zPosition = 1
        saveBtn.layer.zPosition = 1
        retakeBtn.layer.zPosition = 1
        
        playBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        saveBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        retakeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        player.setItemBy(session.assetRepresentingSegments())
        let playerLayer = AVPlayerLayer(player: player)
        let bounds = previewView.bounds
        playerLayer.frame = bounds
        previewView.layer.addSublayer(playerLayer)
        
       

        // Do any additional setup after loading the view.
    }


    override var prefersStatusBarHidden: Bool {
        return true
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
    
    @IBAction func playHit(_ sender: UIButton) {
        launchPlay = !launchPlay
    }
    
    var launchPlay = false {
        didSet {
            if launchPlay == false {
                player.play()
                playBtn.setImage(UIImage(named: "icons8-circled_pause"), for: .normal)
            } else {
                player.pause()
                playBtn.setImage(UIImage(named: "icons8-play_round"), for: .normal)
                
            }
        }
    }
    
    @IBAction func retakeHit(_ sender: UIButton) {
        self.session.removeAllSegments()
       
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ViewTapped(_ sender: UITapGestureRecognizer) {
        print("View Tapped")
        launchTap = !launchTap
    }
    
    var launchTap = false {
        didSet {
            if launchTap == false {
                moveViewDownOrUp(view: controlView, moveUp: true)
            } else {
                moveViewDownOrUp(view: controlView, moveUp: false)

            }
        }
    }

    
    
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
