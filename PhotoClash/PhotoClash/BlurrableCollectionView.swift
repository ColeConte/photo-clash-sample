//
//  BlurrableCollectionView.swift
//  PhotoClash
//
//  Created by Cole Conte on 10/10/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class BlurrableCollectionView: UICollectionView {
    var blurEffect: UIVisualEffectView?
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffect = UIVisualEffectView(effect: blur)
        //change
        blurEffect?.frame = self.bounds
        self.addSubview(blurEffect!)
    }

}
