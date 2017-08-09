//
//  CameraVC.swift
//  Humans
//
//  Created by Nika on 8/1/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import SCRecorder
import AVFoundation

class CameraVC: UIViewController {
    
    let session = SCRecordSession()
    let recorder = SCRecorder()
    var player = SCPlayer()
    var playerLayer = CALayer()
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!

    @IBOutlet weak var doneBtn: UIButton!
    let systemSoundID: SystemSoundID = 1113
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerLayer = AVPlayerLayer(player: player)
        timeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        timeLabel.text = ""
        
        flashBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        doneBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
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
                AudioServicesPlaySystemSound (systemSoundID)
                recorder.pause()
               
                print("session segments = \(session.segments.count)")
                if session.segments.count > 0 {
                     timeLabel.text = ""
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPreviewVC") as! VideoPreviewVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.session = session
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                AudioServicesPlaySystemSound (systemSoundID)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.recordBtn.setImage(UIImage(named: "icons8-record_filled"), for: .normal)
                    self.recorder.record()
                })
                
            }
        }
    }
    
    @IBAction func recordButtonPress(_ sender: AnyObject) {
       launchRecord = !launchRecord
    }
    
    
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
    
    var launchFlash = false {
        didSet {
            if launchFlash == false {
                if recorder.deviceHasFlash == true {
                recorder.flashMode = .off
                flashBtn.setImage(UIImage(named: "icons8-flash_off"), for: .normal)
                }
            } else {
                if recorder.deviceHasFlash == true {
                    recorder.flashMode = .light
                    flashBtn.setImage(UIImage(named: "icons8-flash_on"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func flashHit(_ sender: UIButton) {
        launchFlash = !launchFlash
    }
    
    @IBAction func dismissHit(_ sender: UIButton) {
        self.session.removeAllSegments()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        recorder.previewView = previewView
    }
}


extension CameraVC: SCRecorderDelegate {
    
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession) {
        updateTimeText(session)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return "● \(seconds / 3600):\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
    }
    
    func updateTimeText(_ session: SCRecordSession) {
        
        let time = secondsToHoursMinutesSeconds(seconds: Int(session.duration.seconds))
        self.timeLabel.text = time
        if Int(session.duration.seconds) == 180 {
            recorder.pause()
            print("TIme is UP")
        }
    }
}



    
    
    
    
    
    



