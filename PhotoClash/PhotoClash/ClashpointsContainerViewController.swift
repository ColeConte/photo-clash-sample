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
        let cgStars = originalImage?.cgImage
        //plug in clashpoints math
        let imageArea = CGRect(x: 0, y: 0, width: 0.2 * (originalImage?.size.width)!, height: (originalImage?.size.height)!)
        let subImage = cgStars?.cropping(to: imageArea)
        let image = UIImage(cgImage: subImage!)
        clashPointsStars.image = image
    }
    


}
