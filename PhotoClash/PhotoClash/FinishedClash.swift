//
//  FinishedClash.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/22/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class FinishedClash{
    var user1: UserProfile
    var user2: UserProfile

    var pic1Pct: Int
    var pic2Pct: Int
    var pic1: UIImage
    var pic2: UIImage
    
    init(user1: UserProfile, user2:UserProfile, pic1Pct: Int, pic2Pct: Int, pic1: String, pic2: String){
        self.user1 = user1
        self.user2 = user2
        self.pic1Pct = pic1Pct
        self.pic2Pct = pic2Pct
        self.pic1 = UIImage(named: pic1)!
        self.pic2 = UIImage(named: pic2)!
    }
}