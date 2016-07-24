//
//  CurrentClash.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/22/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class CurrentClash{
    var user1: String
    var user2: String
    var profPic1: UIImage
    var profPic2: UIImage
    var pic1Pct: Int
    var pic2Pct: Int
    var pic1: UIImage
    var pic2: UIImage
    var startTime:NSDate
    
    init(user1: String, user2:String, profPic1:String, profPic2:String, pic1Pct: Int, pic2Pct: Int, pic1: String, pic2: String, startTime: NSDate){
        self.user1 = user1
        self.user2 = user2
        self.profPic1 = UIImage(named: profPic1)!
        self.profPic2 = UIImage(named: profPic2)!
        //should we keep votes tracked? im confused
        self.pic1Pct = pic1Pct
        self.pic2Pct = pic2Pct
        self.pic1 = UIImage(named: pic1)!
        self.pic2 = UIImage(named: pic2)!
        self.startTime = startTime
    }
}