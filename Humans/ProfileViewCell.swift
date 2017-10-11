//
//  ProfileViewCell.swift
//  Humans
//
//  Created by Nika on 7/13/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var likeButt: UIButton!
    @IBOutlet weak var starButt: UIButton!
    @IBOutlet weak var shareButt: UIButton!
    @IBOutlet weak var comenButt: UIButton!
    @IBOutlet weak var moreButt: UIButton!
    @IBOutlet weak var playButt: UIButton!
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
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
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
}


