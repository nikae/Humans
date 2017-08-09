//
//  CameraVC.swift
//  Humans
//
//  Created by Nika on 8/1/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import SCRecorder

class CameraVC: UIViewController {
    
    let session = SCRecordSession()
    let recorder = SCRecorder()
    let player = SCPlayer()
    var playerLayer = CALayer()
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerLayer = AVPlayerLayer(player: player)
        
        saveBtn.isHidden = true
        playBtn.isHidden = true
        retakeBtn.isHidden = true
        
        saveBtn.layer.zPosition = 1
        retakeBtn.layer.zPosition = 1
        playBtn.layer.zPosition = 1
        
        timeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        playBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        saveBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        retakeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
    
        if (!recorder.startRunning()) {
            debugPrint("Recorder error: ", recorder.error ?? "")
        }
        
        recorder.session = session
        recorder.device = AVCaptureDevicePosition.front
        recorder.videoConfiguration.size = CGSize(width: previewView.frame.width , height: previewView.frame.height)
        recorder.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.orientation != .landscapeLeft {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RotateVC") as! RotateVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func rotated() {
        if recorder.isRecording != true {
            if UIDevice.current.orientation != .landscapeLeft {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RotateVC") as! RotateVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    var launchRecord = false {
        didSet {
            if launchRecord == false {
                recordBtn.setImage(UIImage(named: "icons8-record"), for: .normal)
                recorder.pause()
                
                print("session segments = \(session.segments.count)")
                
                if session.segments.count > 0 {
                    saveBtn.isHidden = false
                    playBtn.isHidden = false
                    recordBtn.isHidden = true
                    retakeBtn.isHidden = false
                    cameraSwitchBtn.isHidden = true
                }
                
            } else {
                recordBtn.setImage(UIImage(named: "icons8-record_filled"), for: .normal)
                recorder.record()
            }
        }
        
    }
    
    
    @IBAction func recordButtonPress(_ sender: AnyObject) {
       launchRecord = !launchRecord
    }
    
    @IBAction func pauseButtonPress(_ sender: AnyObject) {
        player.play()
    }
    
//    @IBAction func backspaceButtonPress(_ sender: AnyObject) {
//        if recorder.isRecording {
//            recorder.pause()
//            return
//        }
//        
//        session.removeLastSegment()
//        updateTimeText(session)
//    }
    
    
    @IBAction func playButtonPress(_ sender: AnyObject) {
        launchFrontBackCamera = !launchFrontBackCamera
    }
    
    var launchFrontBackCamera = false {
        didSet {
            if launchFrontBackCamera == false {
                recorder.device = AVCaptureDevicePosition.front
            } else {
                recorder.device = AVCaptureDevicePosition.back
            }
        }
    }
    
    @IBAction func saveButtonPress(_ sender: AnyObject) {
        session.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality) { (url, error) in
            if (error == nil) {
                (url as NSURL?)?.saveToCameraRoll(completion: { (path, error) in
                    debugPrint(path ?? "", error ?? "")
                    self.session.removeAllSegments()
                })
            } else {
                debugPrint(error ?? "")
            }
        }
        
        playerLayer.removeFromSuperlayer()
        saveBtn.isHidden = true
        playBtn.isHidden = true
        retakeBtn.isHidden = true
        recordBtn.isHidden = false
        cameraSwitchBtn.isHidden = false
        
        timeLabel.text = "00:00:00"
    }
    
    @IBAction func retakeHit(_ sender: UIButton) {
        self.session.removeAllSegments()
        playerLayer.removeFromSuperlayer()
        saveBtn.isHidden = true
        playBtn.isHidden = true
        retakeBtn.isHidden = true
        recordBtn.isHidden = false
        cameraSwitchBtn.isHidden = false
        
        timeLabel.text = "00:00:00"
    }
    
    override func viewDidLayoutSubviews() {
        recorder.previewView = previewView
        
        player.setItemBy(session.assetRepresentingSegments())
        let bounds = previewView.bounds
        playerLayer.frame = bounds
        previewView.layer.addSublayer(playerLayer)
    }
}


extension CameraVC: SCRecorderDelegate {
    
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession) {
        updateTimeText(session)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return "\(seconds / 3600):\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
    }
    
    func updateTimeText(_ session: SCRecordSession) {
        
        let time = secondsToHoursMinutesSeconds(seconds: Int(session.duration.seconds))
        self.timeLabel.text = time
        if Int(session.duration.seconds) == 5 {
            recorder.pause()
            print("TIme is UP")
        }
    }
}



    
    
    
    
    
    



