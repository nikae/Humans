//
//  HumansTV.swift
//  Humans
//
//  Created by Nika on 7/13/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

let testArr = ["IMG_0436", "IMG_6930.MOV", "1A054DB4-586B-44B6-B756-D1F7FBB88C52", "IMG_0708.mov", "810D61B5-84A8-4598-8352-0512A69BB869", "331E3199-BF0F-4937-8168-3195190B2E7C"]
var receivedURL: URL!

class HumansTV: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    
    var searchController: UISearchController!
    var player = AVPlayer()
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    
    var footerView = UIView()
    var viewToAnimate = UIView()
    var button = UIButton()
    var button1 = UIButton()
    var button3 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        UIView.animate(withDuration: 10) {
//            self.footerView.layer.cornerRadius = 100
//        }
        
        
        
        
        
        //MARK: CardView
        func dismiss(_ segue: UIStoryboardSegue) {
            self.dismiss(animated: true, completion: nil)
        }
        //END: CardView
        self.definesPresentationContext = true
        
  
        
        setUpNavigationBar()
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Users").child(uId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
             let firstName = value?["firstName"] as? String ?? "me"
            self.profileBtn.title = "@\(firstName)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    

    func setUpNavigationBar(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
        } else {
            self.searchController = UISearchController(searchResultsController: nil)
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.delegate = self
            self.searchController!.searchResultsUpdater = self
            self.searchController.searchBar.sizeToFit()
            self.searchController.searchBar.searchBarStyle = .minimal
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
        
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Humans View Is Here")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -> Search Results (SearchBar become Active)
    func updateSearchResults(for searchController: UISearchController) {
       print(searchController.searchBar.text!)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HumansTableViewCell
        
        let pathToEx1 = Bundle.main.path(forResource: testArr[indexPath.row], ofType: "mp4")
        receivedURL = URL(fileURLWithPath: pathToEx1!)
        cell.videoPlayerItem = AVPlayerItem.init(url: receivedURL)
        
        cell.comenButt.addTarget(self, action: #selector(ProfileTV.comentSegue), for: .touchUpInside)
        cell.moreTextButt.addTarget(self, action: #selector(ProfileTV.comentSegue), for: .touchUpInside)

        return cell
    }
    
    func playVideoOnTheCell(_ cell : HumansTableViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }
    
    func stopPlayBack(_ cell : HumansTableViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end = \(indexPath)")
        if let videoCell = cell as? HumansTableViewCell {
            videoCell.stopPlayback()
            videoCell.playBtn.setImage(UIImage(named: "icons8-play_round"), for: .normal)
            playBool = false
        }
    }
    
    func comentSegue(_ sender:UIButton) {
        let center = sender.center
        let point = sender.superview!.convert(center, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        NameToSand = testArr[(indexPath?.row)!]
        
        if let cell = tableView.cellForRow(at: indexPath!) as? HumansTableViewCell {
            self.stopPlayBack(cell, indexPath: indexPath!)
            cell.playBtn.setImage(UIImage(named: "icons8-play_round"), for: .normal)
            }
        }
    
    var playBool = false
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
             if playBool == false {
                if let play = cell as? HumansTableViewCell {
                    play.playBtn.setImage(UIImage(named: "icons8-circled_pause"), for: .normal)
                }
                self.playVideoOnTheCell(cell as! HumansTableViewCell, indexPath: indexPath)
             } else {
                if let play = cell as? HumansTableViewCell {
                    play.playBtn.setImage(UIImage(named: "icons8-play_round"), for: .normal)
                }
                self.stopPlayBack(cell as! HumansTableViewCell, indexPath: indexPath)
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
    

    //MARK -> Nothing is going on here yet
    func buttonClicked(_ sender:UIButton) {
        let center = sender.center
        let point = sender.superview!.convert(center, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let cell = tableView.cellForRow(at: indexPath!)
        print(cell ?? "NO CELL")
    }
    
    @IBAction func profileHit(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
}
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50 ))
        footerView.backgroundColor = .clear
        
        self.viewToAnimate = UIView(frame: CGRect(x: -tableView.frame.size.width / 2, y: 60 , width: footerView.frame.width * 2, height: footerView.frame.width * 2))
        viewToAnimate.layer.cornerRadius = viewToAnimate.frame.height / 2
        let color = UIColor(displayP3Red: 255/255, green: 64/255, blue: 129/255, alpha: 1)//rgb(255,64,129)
        viewToAnimate.backgroundColor = color
        
        footerView.addSubview(viewToAnimate)
        
        
        viewToAnimate.layer.shadowColor = UIColor.black.cgColor
        viewToAnimate.layer.shadowOpacity = 0.2
        viewToAnimate.layer.shadowOffset = CGSize.zero
        viewToAnimate.layer.shadowRadius = 25
        viewToAnimate.layer.shadowPath = UIBezierPath(rect: viewToAnimate.bounds).cgPath

//        myTextView = UITextView(frame: CGRect(x: 8, y: 8, width: footerView.frame.width - 70, height:footerView.frame.height - 16))
        button = UIButton(frame: CGRect(x: (viewToAnimate.frame.height / 2) - 25, y: 200, width: 50, height: 50))
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button1 = UIButton(frame: CGRect(x: (viewToAnimate.frame.height / 2) + 50, y: 200, width: 50, height: 50))
        button1.setTitle("yo", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button1.layer.cornerRadius = button.frame.height / 2
        button1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button3 = UIButton(frame: CGRect(x: (viewToAnimate.frame.height / 2) - 100, y: 200, width: 50, height: 50))
        button3.setTitle("yes", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button3.layer.cornerRadius = button.frame.height / 2
        button3.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        footerView.addGestureRecognizer(tapRecognizer)

        viewToAnimate.addSubview(button)
        viewToAnimate.addSubview(button1)
        viewToAnimate.addSubview(button3)
        return footerView
    }
    
    var launchFooter = false {
        didSet {
            if launchFooter == false {
                
                UIView.animate(withDuration: 0.5, delay:0, animations: {
                    //top
                    self.viewToAnimate.transform = .init(scaleX: 1.4, y: 1.4)
                }, completion: {completion in
                    UIView.animate(withDuration: 0.3, delay:0, animations: {
                        //left
                        self.viewToAnimate.transform = .init(scaleX: 1.2, y: 1.2)
                        self.button.frame.origin.y = 20
                        self.button1.frame.origin.y = 20
                        self.button3.frame.origin.y = 20
                        
                    }, completion: {completion in
                        UIView.animate(withDuration: 0.2, delay:0, animations: {
                            //bottom
                            self.viewToAnimate.transform = .init(scaleX: 1.3, y: 1.3)
                            self.button1.frame.origin.y = 50
                            self.button3.frame.origin.y = 50
                            
                       
                        })
                    })
                    
                })
            } else {
                
                UIView.animate(withDuration: 0.2, delay:0, animations: {
                    self.button.frame.origin.y = 200
                    self.button1.frame.origin.y = 200
                    self.button3.frame.origin.y = 200
                }, completion: {completion in
                    UIView.animate(withDuration: 0.3, delay:0, animations: {
                        self.viewToAnimate.transform = .init(scaleX: 1, y: 1)
                        
                    })
                    
                })
                
               
            }
        }
    }
   @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        launchFooter = !launchFooter
    }

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("yass")
       
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

}
