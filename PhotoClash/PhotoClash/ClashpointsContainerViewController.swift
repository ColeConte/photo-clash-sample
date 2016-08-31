//
//  ClashpointsContainerViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class ClashpointsContainerViewController: UIViewController {

    @IBOutlet weak var clashPoints: UILabel!
    @IBOutlet weak var clashPointsStars: UIImageView!
    var user: UserProfile?
    
    
    override func viewWillLayoutSubviews() {
        print (clashPointsStars.frame.width)
        clashPointsStars.clipsToBounds = true
        clashPointsStars.frame = CGRectMake(clashPointsStars.frame.minX,clashPointsStars.frame.minY, 0.5 * clashPointsStars.frame.width, clashPointsStars.frame.height)
        print (clashPointsStars.frame.width)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        clashPoints.text = String(user?.clashpoints)
        
        // Do any additional setup after loading the view.
    }

}
