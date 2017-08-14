//
//  Models.swift
//  Humans
//
//  Created by Nika on 7/14/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit

//MARK: User

struct User {
    var userId: String!
    var name: String!
    var profilePictureUrl: String!
    var createdAt: String!
    var favorites: [MyFavorites]
}

struct Post {
    var postID: String
    var autorId: String
    var createdAt: String!
    var videoUrl: String!
    var imageUrl: String!
    var headLine: String!
    var text: String!
    var description: String!
    var likes: [Like]!
    var coment: [Coment]!
    var Favorites: [Favorite]!
    var location: [Double]
}

//struct Text {
//    var postID: String
//    var autorId: String
//    var createdAt: String!
//    var imageUrl: String!
//    var headLine: String!
//    var text: String!
//    var description: String!
//    var likes: [Like]!
//    var coment: [Coment]!
//    var Favorites: [Favorite]!
//    var location: [Double]
//}

struct Like {
    var creatorID: String!
    var createdAt: String!
}

struct Favorite {
    var creatorID: String!
    var createdAt: String!
}

struct Coment {
    var creatorID: String!
    var createdAt: String!
    var comentText: String
}

struct MyFavorites {
    var postId: String!
    var autorId: String!
    var createdAt: String!
}

struct blockedStruct {
    var blockedUserID: String!
    var blockedAt: String!
}

struct BlockedByStruct {
    var blockedUserID: String!
    var blockedAt: String!
}




    
   

