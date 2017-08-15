//
//  Methods.swift
//  Humans
//
//  Created by Nika on 7/24/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit
import Firebase

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



func moveViewDownOrUp(view: UIView, moveUp: Bool) {
    
    if moveUp == false {
        
        let xPositionOfView = view.frame.origin.x - 80
        //View will slide Npx down
        let yPositionOfView = view.frame.origin.y
        
        let heightOfView = view.frame.size.height
        let widthOfView = view.frame.size.width
        
        UIView.animate(withDuration: 0.5, animations: {
            view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
        })
        
    } else {
        let xPositionOfView = view.frame.origin.x + 80
        //View will slide Npx up
        let yPositionOfView = view.frame.origin.y
        
        
        let heightOfView = view.frame.size.height
        let widthOfView = view.frame.size.width
        
        UIView.animate(withDuration: 0.5, animations: {
            
            view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
            
        })
    }
    
}



func getDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy h:mm a"
    return formatter.string(from: date)
}

func postToDatabase(autorId: String, createdAt: String, videoUrl: String, imageUrl: String, headLine: String, description: String, language: String, likes: [Like], coments: [Coment], favorites: [Favorite], location: String) {
    
    var databaseRef: FIRDatabaseReference!
    databaseRef = FIRDatabase.database().reference()
    let key = databaseRef.child("Posts").childByAutoId().key
    
    let post: [String : Any] = ["postID" : key,
                                "autorId" : autorId,
                                "createdAt" : createdAt,
                                "videoUrl" : videoUrl,
                                "imageUrl" : imageUrl,
                                "language" : language,
                                "headLine" : headLine,
                                "description" : description,
                                "likes" : likes,
                                "coments" : coments,
                                "favorites" : favorites,
                                "location" : location]
    
    databaseRef.child("Posts").child("\(key)").setValue(post)
}



let videoGuideLinesLibrary = ["Time" : ["title" : "Time",
                                        "boddy" : "Time Boddy Goews Here"],
                              "Ideas" : ["title" : "Ideas",
                                         "boddy" : "Ideas Boddy Goews Here"],
                              "Coments" : ["title" : "Coments",
                                         "boddy" : "Coments Boddy Goews Here"],
                              "Privacy" : ["title" : "Privacy",
                                           "boddy" : "Privacy Boddy Goews Here"],
                              "Language" : ["title" : "Language",
                                           "boddy" : "Language Boddy Goews Here"],
                              "Info" : ["title" : "Info",
                                           "boddy" : "Info Boddy Goews Here"]]







