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

let testArr = ["IMG_0436", "IMG_6930.MOV", "1A054DB4-586B-44B6-B756-D1F7FBB88C52", "IMG_0708.mov", "810D61B5-84A8-4598-8352-0512A69BB869", "331E3199-BF0F-4937-8168-3195190B2E7C"]
var receivedURL: URL!

class HumansTV: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    var searchController: UISearchController!
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController!.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.searchBarStyle = .minimal
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        
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
