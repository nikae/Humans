//
//  ProfileTV.swift
//  Humans
//
//  Created by Nika on 7/13/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import Firebase
import SDWebImage

extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func addDarkBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

var NameToSand = ""

class ProfileTV: UITableViewController {
    
    var moviePlayer: AVPlayer!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.addBlurEffect()
        roundPhoto(imageView: imageView)
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let firstName = value?["firstName"] as? String ?? "First Name"
            let lastName = value?["lastName"] as? String ?? "Last Name"
            let pictureURL = value?["profilePictureUrl"] as? String ?? ""
            
            self.fullNameLabel.text = "\(firstName) \(lastName)"
            
            if pictureURL != "" {
                let starsRef = FIRStorage.storage().reference(forURL: pictureURL)
                starsRef.downloadURL { url, error in
                    if error != nil {
                        print(error ?? "error")
                    } else {
                        
                        self.imageView.alpha = 0.0
                        self.backgroundImageView.alpha = 0.0
                        
                        UIView.animate(withDuration: 1, animations: {
                        self.imageView.alpha = 1
                        self.backgroundImageView.alpha = 1
                        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                        self.backgroundImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default-avatar"))
                        })
                        self.imageView.setShowActivityIndicator(true)
                        self.imageView.setIndicatorStyle(.gray)
                    }
                }
                
            } else {
                self.imageView.image = UIImage(named: "default-avatar")
            }
        }) { (error) in
            print(error.localizedDescription)
        }      
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileViewCell

        let pathToEx1 = Bundle.main.path(forResource: testArr[indexPath.row], ofType: "mp4")
        receivedURL = URL(fileURLWithPath: pathToEx1!)
        cell.videoPlayerItem = AVPlayerItem.init(url: receivedURL)
        
        cell.likeButt.addTarget(self, action: #selector(ProfileTV.heartButtonClicked), for: .touchUpInside)
        cell.comenButt.addTarget(self, action: #selector(ProfileTV.comentSegue), for: .touchUpInside)
        cell.moreTextButt.addTarget(self, action: #selector(ProfileTV.comentSegue), for: .touchUpInside)

        return cell
    }
    
    //MARK: - Segue Needs atencion
    
    func comentSegue(_ sender:UIButton) {
        let center = sender.center
        let point = sender.superview!.convert(center, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        NameToSand = testArr[(indexPath?.row)!]
        
        if let cell = tableView.cellForRow(at: indexPath!) as? ProfileViewCell {
            self.stopPlayBack(cell, indexPath: indexPath!)
            cell.playButt.setImage(UIImage(named: "icons8-play_round"), for: .normal)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let dest = segue.destination as! ComentsTV
//        dest.recivedName = NameToSand
//        dest.vcId = "ProfileVC"
//        NameToSand = ""
//    }
    
    func playVideoOnTheCell(_ cell : ProfileViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }
    
    func stopPlayBack(_ cell : ProfileViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end = \(indexPath)")
        if let videoCell = cell as? ProfileViewCell {
            videoCell.stopPlayback()
            videoCell.playButt.setImage(UIImage(named: "icons8-play_round"), for: .normal)
            playBool = false
        }
    }
    
    var playBool = false
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if playBool == false {
                if let play = cell as? ProfileViewCell {
                    play.playButt.setImage(UIImage(named: "icons8-circled_pause"), for: .normal)
                }
                self.playVideoOnTheCell(cell as! ProfileViewCell, indexPath: indexPath)
            } else {
                if let play = cell as? ProfileViewCell {
                    play.playButt.setImage(UIImage(named: "icons8-play_round"), for: .normal)
                }
                self.stopPlayBack(cell as! ProfileViewCell, indexPath: indexPath)
            }
        }
        launchvoice = !launchvoice
    }
    
    var launchvoice = false {
        didSet {
            if launchvoice == false {
                playBool = false
            } else {
                playBool = true
            }
        }
    }
    
    var likeBool = false
    func heartButtonClicked(_ sender:UIButton) {
        let center = sender.center
        let point = sender.superview!.convert(center, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let cell = tableView.cellForRow(at: indexPath!)
        let b1 = cell?.viewWithTag(101) as! UIButton
        
        if likeBool == false {
            b1.setImage(UIImage(named: "icons8-like"), for: .normal)
        } else {
            b1.setImage(UIImage(named: "icons8-like_filled"), for: .normal)
        }
        launchHeart = !launchHeart
    }
    
    var launchHeart = false {
        didSet {
            if launchHeart == false {
                likeBool = false
            } else {
                likeBool = true
            }
        }
    }

    
   
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logOutHitNeedsToChange(_ sender: UIBarButtonItem) {
       
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.present(vc, animated: true, completion: nil)

        
    }

}
