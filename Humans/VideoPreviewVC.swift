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
    
    @IBOutlet weak var languagebtn: UIButton!
    @IBOutlet weak var headlineTF: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    
    
    var session = SCRecordSession()
    let recorder = SCRecorder()
    let player = SCPlayer()
    var playerLayer = CALayer()

    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
     var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.country = value?["country"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        
        
        controlView.layer.zPosition = 1
        saveBtn.layer.zPosition = 1
        retakeBtn.layer.zPosition = 1
        
        if session.segments.count > 0 {
            noVideoLabel.isHidden = true
        } else {
            noVideoLabel.isHidden = false
        }
        
        player.setItemBy(session.assetRepresentingSegments())
       
        let playerLayer = AVPlayerLayer(player: player)
        //playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat((Double.pi * 180) / 360 )))
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        let bounds = previewView.bounds
        playerLayer.frame = bounds
       
        previewView.layer.addSublayer(playerLayer)
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
    }
    
    @IBAction func retakeHit(_ sender: UIButton) {
        self.session.removeAllSegments()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ViewTapped(_ sender: UITapGestureRecognizer) {
       // launchTap = !launchTap
        keyboardDismiss(tf: headlineTF)
        descriptionTv.resignFirstResponder()
    }
    
//    var launchTap = false {
//        didSet {
//            if launchTap == false {
//                //moveViewDownOrUp(view: controlView, moveUp: true)
//            } else {
//               // moveViewDownOrUp(view: controlView, moveUp: false)
//
//            }
//        }
//    }

    @IBAction func sliderHit(_ sender: UISlider) {
        player.volume = sender.value
        print(sender.value)
        
       
    }
    
//    struct Post {
//        var postID: String
//        var autorId: String
//        var createdAt: String!
//        var videoUrl: String!
//        var imageUrl: String!
//        var headLine: String!
//        var description: String!
//        var likes: [Like]!
//        var coment: [Coment]!
//        var Favorites: [Favorite]!
//        var location: [Double]
//    }

    @IBAction func saveHit(_ sender: UIButton) {
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                (url as NSURL?)?.saveToCameraRoll(completion: { (path, error) in
                    debugPrint(path ?? "", error ?? "")
                })
                
                let storageRef = FIRStorage.storage().reference(forURL: "gs://humans-16dc5.appspot.com/videos")
                let metadata = FIRStorageMetadata()
                metadata.contentType = "video.mp4"
                let videoPath = "\(Date.timeIntervalSinceReferenceDate * 1000).mov"
                
                let uploasTask = storageRef.child(videoPath).putFile(url!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    
                    let videoURL = metadata!.downloadURL()!.absoluteString
                    let postDate = getDate()
                    
                    
                    postToDatabase(autorId: self.uId!, createdAt: postDate, videoUrl: videoURL, imageUrl: "", headLine: self.headlineTF.text ?? "", description: self.descriptionTv.text ?? "", language: "English", likes: [], coments: [], favorites: [], location: self.country)
                }
                
                uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
                    guard self != nil else {return}
                    guard let progress = snapshot.progress else {return}
                    
                    print(Float(progress.fractionCompleted))
                } )
            } else {
                debugPrint(error ?? "")
            }
        }

    }
    
   
}
