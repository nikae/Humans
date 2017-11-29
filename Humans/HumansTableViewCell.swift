//
//  HumansTableViewCell.swift
//  Humans
//
//  Created by Nika on 7/13/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HumansTableViewCell: UITableViewCell {

    @IBOutlet weak var backgrounView: UIView!
    @IBOutlet weak var backgroundDesighnView: UIView!
    
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var likeButt: UIButton!
    @IBOutlet weak var starButt: UIButton!
    @IBOutlet weak var shareButt: UIButton!
    @IBOutlet weak var comenButt: UIButton!
    @IBOutlet weak var moreButt: UIButton!
    @IBOutlet weak var moreTextButt: UIButton!
    
    @IBOutlet weak var profilePictureViewCell: UIImageView!
    @IBOutlet weak var fullNameLabelCell: UILabel!
    @IBOutlet weak var countryLabelCell: UILabel!
    @IBOutlet weak var namberOfComentsLabelCell: UILabel!
    @IBOutlet weak var namberOfLikesLabelCell: UILabel!
    
    @IBOutlet weak var textViewCell: UITextView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    //This will be called everytime a new value is set on the videoplayer item
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCell()
        
        let imageView = self.viewWithTag(3) as! UIImageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.frame.height/2
        
        self.setupMoviePlayer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupMoviePlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerLayer?.masksToBounds = true
        avPlayerLayer?.cornerRadius = 15
        //avPlayerLayer?.layer.masksToBounds = false
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        avPlayerLayer?.frame = CGRect(x:videoView.bounds.origin.x,y:videoView.bounds.origin.y,width: videoView.bounds.width ,height:videoView.bounds.height)
        
        self.backgroundColor = .clear
        self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    
//    func playVideo(view: UIImageView, play: Float, name: String) {
//        let pathToEx1 = Bundle.main.path(forResource: name, ofType: "mp4")
//        let receivedURL = URL(fileURLWithPath: pathToEx1!)
//        player = AVPlayer(url: receivedURL)
//        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
//        avPlayerLayer.frame = CGRect(x:view.bounds.origin.x,y:view.bounds.origin.y,width: view.bounds.width ,height:view.bounds.height)
//        view.layer.addSublayer(avPlayerLayer)
//        //view.layer.zPosition = 0.0
//        player.pause()
//        //        player.volume = 0.0
//    }

    
    func setUpCell() {
        backgroundDesighnView.frame.size.width = backgrounView.frame.width - 50
        viewShedow(view: backgroundDesighnView)
        
        backgroundDesighnView!.clipsToBounds = true
        backgroundDesighnView!.isUserInteractionEnabled = true
        backgroundDesighnView!.layer.cornerRadius = 15
        backgroundDesighnView!.layer.masksToBounds = false
        
        videoView!.clipsToBounds = true
        videoView!.isUserInteractionEnabled = true
        videoView!.layer.cornerRadius = 15
        videoView!.layer.masksToBounds = false
        
    }
    
    func viewShedow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 15
        view.layer.masksToBounds = false
    }

}
