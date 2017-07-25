//
//  Methods.swift
//  Humans
//
//  Created by Nika on 7/24/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit

func viewShape(view: UIView) {
    view.clipsToBounds = true
    view.layer.cornerRadius = view.frame.height/2
}

func roundPhoto(imageView: UIImageView) {
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.isUserInteractionEnabled = true
    imageView.layer.cornerRadius = imageView.frame.height/2
}

func keyboardDismiss(tf: UITextField) {
    tf.resignFirstResponder()
}


func age(year: Int, month: Int, day: Int) -> Int {
    let now = Date()
    let myDOB = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    let myAge = Calendar.current.dateComponents([.year], from: myDOB, to: now).year
    return myAge ?? 1
}
