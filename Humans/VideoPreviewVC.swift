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

    var databaseRef: FIRDatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("Posts/-Krb4Kypx5LZoYmjbMGY").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? String
//            
//            let a  = value
//            let b = URL(string: a!)
//            self.player.setItemBy(b)
//            print("AAAAA ----- \(String(describing: a))")
//        }) { (error) in
//            print(error.localizedDescription)
//        }

        
        
        
        
         databaseRef = FIRDatabase.database().reference()
        
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
//        let u = URL(string: "https:/firebasestorage.googleapis.com/v0/b/humans-16dc5.appspot.com/o/524513321905.27.mov?alt=media&token=4c830cc7-9f83-4245-b018-221a2c3fd25a")
 //       player.setItemBy(u)
       
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
    
//    struct Post {
//        var postID: String
//        var autorId: String
//        var createdAt: String!
//        var videoUrl: String!
//        var imageUrl: String!
//        var headLine: String!
//        var text: String!
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
                
                
                let storageRef = FIRStorage.storage().reference()
                let metadata = FIRStorageMetadata()
                metadata.contentType = "video.mp4"
                let videoPath = "\(Date.timeIntervalSinceReferenceDate * 1000).mov"
                
                let uploasTask = storageRef.child(videoPath).putFile(url!, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error)")
                            return
                        }
                    
                    let videoURL = storageRef.child((metadata?.downloadURL()?.absoluteString)!)
                    self.databaseRef.child("Posts").childByAutoId().setValue("\(videoURL)")
                    print("self.picURL: \(String(describing: videoURL))")
                    
                    
                    
                    
//                    self.picURL = self.storageRef.child((metadata?.path)!).description
//                        self.databaseRef.child("Users/\(self.uId!)/profilePictureUrl").setValue(self.picURL)
//                        
//                        print("self.picURL: \(self.picURL)")
                }
                
                uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
                    
                    guard self != nil else {return}
                    guard let progress = snapshot.progress else {return}
                    
                    print(Float(progress.fractionCompleted))
                    
                    //            strongSelf.progressView.progress = Float(progress.fractionCompleted)
                    //            strongSelf.progressView.isHidden = false
                    //            
                    //            if strongSelf.progressView.progress == 1.0 {
                    //                strongSelf.progressView.isHidden = true
                    //            }
                    
                    
                } )
  
                
                
                
//                //https://firebasestorage.googleapis.com/v0/b/humans-16dc5.appspot.com/o/524513124247.009.mov?alt=media&token=5551ea32-cbe1-4513-b341-c16e25509360
//                
//                gs://humans-16dc5.appspot.com/https:/firebasestorage.googleapis.com/v0/b/humans-16dc5.appspot.com/o/524513124247.009.mov?alt=media&token=5551ea32-cbe1-4513-b341-c16e25509360
//                
//                
//                gs://humans-16dc5.appspot.com/524513124247.009.mov
                
                
                
                
                
//                let storageRef = FIRStorage.storage().reference().child("video.mov")
//                
//                // Start the video storage process
//                storageRef.putFile(url!).observe(.success) { (snapshot) in
//                    // When the image has successfully uploaded, we get it's download URL
//                    let videoURL = snapshot.metadata?.downloadURL()?.absoluteString
//                    // Write the download URL to the Realtime Database
//                    self.databaseRef.child("Posts").childByAutoId().setValue(videoURL)
//                    print("self.picURL: \(String(describing: videoURL))")
//                }
            } else {
                debugPrint(error ?? "")
            }
        }

    }

}
