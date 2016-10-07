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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clashPoints.text = String(user!.clashpoints)
        let originalImage = clashPointsStars.image
        let cgStars = originalImage?.CGImage
        //plug in clashpoints math
        let imageArea = CGRectMake(0, 0, 0.2 * (originalImage?.size.width)!, (originalImage?.size.height)!)
        let subImage = CGImageCreateWithImageInRect(cgStars, imageArea)
        let image = UIImage(CGImage: subImage!)
        clashPointsStars.image = image
    }
    


}
