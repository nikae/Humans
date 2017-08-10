//
//  ComentsTV.swift
//  Humans
//
//  Created by Nika on 7/14/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ComentsTV: UITableViewController, UITextViewDelegate {
    
    var kPreferredTextViewToKeyboardOffset: CGFloat = 0.0
    var keyboardFrame: CGRect = CGRect.null
    var keyboardIsShowing: Bool = false
    
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var headerCountyLabel: UILabel!
    
    @IBOutlet weak var headerLikeBtn: UIButton!
    @IBOutlet weak var headerFavoriteBtn: UIButton!
    @IBOutlet weak var headerShareBtn: UIButton!
    @IBOutlet weak var headerComentBtn: UIButton!
    
    @IBOutlet weak var headerLikeCountLabel: UILabel!
    @IBOutlet weak var headerComentCountLabel: UILabel!
    
    var myTextView = UITextView()
    var footerView = UIView()
    var button = UIButton()
    
    private var lastContentOffset: CGFloat = 0
    
    let textHolder = ["Figuring out the Secret Formula First, www.google.com we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font.Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font.Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font.", "Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. ", "it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font.", "Figuring out the ", "Figuring out", "Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font..", "Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier, Monaco, and other similar looking fonts.The app seems to recognize two things: A surrounding box and a code in the middle of this box. Once the app recognizes this pattern, it draws an on-screen box and tries to identify the code inside the box. The box itself isn’t enough: the app only kicks off its code recognition engine as soon as it finds specific characteristics of the specific font.","Figuring out the Secret Formula First, we tried simply re-creating the design with a similar font. We tried Courier."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = textHolder[0]
        let fixedWidth = descriptionTextView.frame.size.width
        descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = descriptionTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        descriptionTextView.frame = newFrame
        

        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.layer.cornerRadius = headerImageView.frame.height/2
        
        headerComentBtn.isUserInteractionEnabled = false
        headerComentBtn.setImage(UIImage(named: "icons8-topic_filled"), for: .normal)
        
        myTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComentsTV.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ComentsTV.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.estimatedRowHeight = 99.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        playVideo(view: videoView, name: NameToSand)
        self.clearsSelectionOnViewWillAppear = true
        
      
        let stopScrollingDict:[String: Bool] = ["stopScrolling": true]
        
    //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let stopScrollingDict:[String: Bool] = ["stopScrolling": false]
    //MARK: -> post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: stopScrollingDict)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sizeHeaderToFit()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
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
    
  //MARK: -> keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func playVideo(view: UIImageView,  name: String) {
        let pathToEx1 = Bundle.main.path(forResource: name, ofType: "mp4")
        let receivedURL = URL(fileURLWithPath: pathToEx1!)
        let  player = AVPlayer(url: receivedURL)
        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = CGRect(x:view.bounds.origin.x,y:view.bounds.origin.y,width: view.bounds.width ,height:view.bounds.height)
        view.layer.addSublayer(avPlayerLayer)
        player.play()
        player.volume = 1.0
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
        return textHolder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComentsCell", for: indexPath) as! ComentsCell
        cell.textView.text = textHolder[indexPath.row]
        textViewSize(textView: cell.textView)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            myTextView.resignFirstResponder()
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .white
        
        myTextView = UITextView(frame: CGRect(x: 8, y: 8, width: footerView.frame.width - 70, height:footerView.frame.height - 16))
        button = UIButton(frame: CGRect(x: footerView.frame.width - 60, y: 8, width: 50, height: footerView.frame.height - 16))
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        myTextView.layer.borderColor = UIColor.lightGray.cgColor
        myTextView.layer.borderWidth = 0.6
        myTextView.layer.cornerRadius = 6.0
        myTextView.clipsToBounds = true
        myTextView.layer.masksToBounds = true
        
        footerView.addSubview(myTextView)
        footerView.addSubview(button)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text) //the textView parameter is the textView where text was changed
    }
    
    func buttonAction(_ sender: UIButton!) {
        print(myTextView.text ?? "")
        myTextView.text = ""
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
    var launchLike = false{
        didSet {
            if launchLike == false {
                headerLikeBtn.setImage(UIImage(named: "icons8-like"), for: .normal)
            } else {
                 headerLikeBtn.setImage(UIImage(named: "icons8-like_filled"), for: .normal)
            }
        }
    }
    @IBAction func headerLikeHit(_ sender: UIButton) {
        launchLike = !launchLike
    }
    var launchFavorite = false{
        didSet {
            if launchFavorite == false {
                headerFavoriteBtn.setImage(UIImage(named: "icons8-star"), for: .normal)
            } else {
                headerFavoriteBtn.setImage(UIImage(named: "icons8-star_filled"), for: .normal)
            }
        }
    }

    @IBAction func headerFavoriteHit(_ sender: UIButton) {
        launchFavorite = !launchFavorite
    }
    
    @IBAction func headerShareHit(_ sender: UIButton) {
        print("Shear Action Goes Here")
    }
    
    @IBAction func headerMoreActionHit(_ sender: UIButton) {
        print("More Options Goes Here")
    }
    
    

    @IBAction func dismissHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
