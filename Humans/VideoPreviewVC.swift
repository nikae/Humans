//
//  VideoPreviewVC.swift
//  Humans
//
//  Created by Nika on 8/7/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import SCRecorder
import Firebase

class VideoPreviewVC: UIViewController {
    
    
    
   
    @IBOutlet weak var noVideoLabel: UILabel!

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var delateLastBtn: UIButton!

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
        
        if session.segments.count > 0 {
            noVideoLabel.isHidden = true
        } else {
            noVideoLabel.isHidden = false
        }
        
//        noVideoLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        playBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        saveBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        retakeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        delateLastBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        
        player.setItemBy(session.assetRepresentingSegments())
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat((Double.pi * 180) / 360 )))
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
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

    @IBAction func backHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func delateLastHit(_ sender: UIButton) {
        session.removeLastSegment()
       // updateTimeText(session)
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

    @IBAction func sliderHit(_ sender: UISlider) {
        player.volume = sender.value
        print(sender.value)
        
       
    }
    
    @IBAction func saveHit(_ sender: UIButton) {
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                (url as NSURL?)?.saveToCameraRoll(completion: { (path, error) in
                    debugPrint(path ?? "", error ?? "")
                })
                
                let storageReference = FIRStorage.storage().reference().child("video.mov")
                
                // Start the video storage process
                storageReference.putFile(url!, metadata: nil, completion: { (metadata, error) in
                    if error == nil {
                        print("Successful video upload")
                    } else {
                        print(error?.localizedDescription ?? "Eror ar aploading")
                    }
                })
                
            
            } else {
                debugPrint(error ?? "")
            }
        }

    }

}
