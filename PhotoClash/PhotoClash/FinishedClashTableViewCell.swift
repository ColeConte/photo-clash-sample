//
//  FinishedClashTableViewCell.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class FinishedClashTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var votePercentage: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    var finishedClash: FinishedClash!


    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page:Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControl.currentPage = page
        if page == 0{
            votePercentage.text = String(finishedClash.pic1Pct) + "%"
            profilePic.image = finishedClash.user1.profilePicture
            userName.text = finishedClash.user1.username
            votePercentage.textColor = UIColor.greenColor()
        }
        else{
            votePercentage.text = String(finishedClash.pic2Pct) + "%"
            profilePic.image = finishedClash.user2.profilePicture
            userName.text = finishedClash.user2.username
            votePercentage.textColor = UIColor.redColor()
        }
    }
    
}
