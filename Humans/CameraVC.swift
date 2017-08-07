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
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var playbackView: UIView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        if (!recorder.startRunning()) {
            debugPrint("Recorder error: ", recorder.error ?? "")
        }
        
        recorder.session = session
        recorder.device = AVCaptureDevicePosition.back
        recorder.videoConfiguration.size = CGSize(width: 800, height: 800)
        recorder.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.orientation.isPortrait {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RotateVC") as! RotateVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        } 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            
            if recorder.isRecording {
            recordBtn.setImage(UIImage(named: "icons8-record"), for: .normal)
            recorder.pause()
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RotateVC") as! RotateVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    var launchRecord = false {
        didSet {
            if launchRecord == false {
                recordBtn.setImage(UIImage(named: "icons8-record"), for: .normal)
                recorder.stopRunning()
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
       // player.play()
        launchFrontBackCamera = !launchFrontBackCamera
        
    }
    
    var launchFrontBackCamera = false {
        didSet {
            if launchFrontBackCamera == false {
                recorder.device = AVCaptureDevicePosition.back
            } else {
                recorder.device = AVCaptureDevicePosition.front
            }
        }
        
    }
    
    @IBAction func saveButtonPress(_ sender: AnyObject) {
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
    
    
    override func viewDidLayoutSubviews() {
        recorder.previewView = previewView
        
        player.setItemBy(session.assetRepresentingSegments())
        let playerLayer = AVPlayerLayer(player: player)
        let bounds = playbackView.bounds
        playerLayer.frame = bounds
        playbackView.layer.addSublayer(playerLayer)
    }
    
    
    

    
}

extension CameraVC: SCRecorderDelegate {
    
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession) {
        updateTimeText(session)
    }
    
    func updateTimeText(_ session: SCRecordSession) {
        self.timeLabel.text = String(session.duration.seconds)
    }
}



    
    
    
    
    
    



