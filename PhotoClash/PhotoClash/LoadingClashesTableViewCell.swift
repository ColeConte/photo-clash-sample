//
//  LoadingClashesTableViewCell.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/11/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class LoadingClashesTableViewCell: UITableViewCell {

    @IBOutlet weak var chameleon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = 0.0
        rotateAnimation.fromValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 3.0
        rotateAnimation.repeatCount = Float.infinity
        self.chameleon.layer.add(rotateAnimation, forKey: nil)
        let crossFadeAnimation1 = CABasicAnimation(keyPath: "contents")
        let image1 = UIImage(named: "Chameleon.png")
        let image2 = UIImage(named: "Chameleon2.png")
        crossFadeAnimation1.fromValue = image1!.cgImage
        crossFadeAnimation1.toValue = image2!.cgImage
        crossFadeAnimation1.autoreverses = true
        crossFadeAnimation1.duration = 3.0
        crossFadeAnimation1.repeatCount = Float.infinity
        self.chameleon.layer.add(crossFadeAnimation1, forKey: nil)
        
    }



}
