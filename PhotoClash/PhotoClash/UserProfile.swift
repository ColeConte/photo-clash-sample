//
//  UserProfile.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/17/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class UserProfile{
    var username: String
    var profilePicture: UIImage
    var previousClashes: [FinishedClash]
    var clashpoints: Int
    var friends: [UserProfile]
    
    init(username: String, profilePicture: UIImage, previousClashes: [FinishedClash], clashpoints: Int, friends: [UserProfile]){
        self.username = username
        self.profilePicture = profilePicture
        self.previousClashes = previousClashes
        self.clashpoints = clashpoints
        self.friends = friends
    }
}
