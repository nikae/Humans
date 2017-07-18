//
//  ComentsCell.swift
//  Humans
//
//  Created by Nika on 7/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class ComentsCell: UITableViewCell {
    
   

    @IBOutlet weak var textView: UITextView!
   // @IBOutlet weak var aspectRatioTextViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //textView.text = textHolder
       
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
