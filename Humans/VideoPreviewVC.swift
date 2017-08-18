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

class VideoPreviewVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var noVideoLabel: UILabel!

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    
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
        
        viewShape(view: saveBtn)
        viewShape(view: backBtn)
        
        descriptionTv.delegate = self
        headlineTF.delegate = self
        textViewShape(TV: descriptionTv)
        
//        descriptionTv.layer.borderColor = UIColor.lightGray.cgColor
//        descriptionTv.layer.borderWidth = 0.6
//        descriptionTv.layer.cornerRadius = 6.0
//        descriptionTv.clipsToBounds = true
//        descriptionTv.layer.masksToBounds = true
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.country = value?["country"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        
        
       // controlView.layer.zPosition = 1
        playBtn.layer.zPosition = 1
       // retakeBtn.layer.zPosition = 1
        
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPreviewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPreviewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func langiageHit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagePickerVC") as! LanguagePickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func playHit(_ sender: UIButton) {
        launchPlay = !launchPlay
    }
    
    var launchPlay = false {
        didSet {
            if launchPlay == false {
                player.play()
                playBtn.setImage(UIImage(named: "icons8-circled_pause"), for: .normal)
                playBtn.isHidden = true
            } else {
                player.pause()
                playBtn.setImage(UIImage(named: "icons8-play_round"), for: .normal)
                playBtn.isHidden = false
                
            }
        }
    }

    @IBAction func backHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ViewTapped(_ sender: UITapGestureRecognizer) {
         launchPlay = !launchPlay
       
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
    
    //Mark: -> Figour out KeyBoard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .lightGray
           self.slider.isEnabled = false
           self.saveBtn.isEnabled = false
            self.backBtn.isEnabled = false
            self.languagebtn.isEnabled = false
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.backgroundColor = .white
            self.slider.isEnabled = true
            self.saveBtn.isEnabled = true
            self.backBtn.isEnabled = true
            self.languagebtn.isEnabled = true
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        keyboardDismiss(tf: headlineTF)
        descriptionTv.resignFirstResponder()
    }
    
    func textViewSize(textView: UITextView) {
        var aspectRatioTextViewConstraint: NSLayoutConstraint!
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        textView.frame = frame
        aspectRatioTextViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        textView.addConstraint(aspectRatioTextViewConstraint!)
    }
}
