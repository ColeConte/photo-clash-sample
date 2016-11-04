//
//  CurrentClashTableViewCell.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class CurrentClashTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var heart2: UIImageView!

    var currentClash: CurrentClash!{
        didSet{
            //off by one second
            let oneDay: TimeInterval = 60.0*60.0*24.0
            let currentTime = Date()
            timerCounter = currentClash.startTime.addingTimeInterval(oneDay).timeIntervalSince(currentTime)
            timeRemaining.text = stringFromTimeInterval(timerCounter!)
            startTimer()
        }
    }
    var timerCounter: TimeInterval?
    
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped) )
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        super.awakeFromNib()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page:Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControl.currentPage = page
    }
    
    func doubleTapped(){
        var theHeart: UIImageView?
        if pageControl.currentPage == 0{
            theHeart = heart
        }
        else{
            theHeart = heart2
        }
        theHeart!.isHidden = false
        theHeart!.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
            
            theHeart!.alpha = 0
            
            }, completion: {
                (value:Bool) in
                
                theHeart!.isHidden = true
        })
    }
    
    func stringFromTimeInterval(_ interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CurrentClashTableViewCell.onTimer(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(_ timer:Timer!) {
        // Here is the string containing the timer
        // Update your label here
        if timerCounter == 0.0{
            //make this better
            timeRemaining.text = "00:00:00!!!"
            self.isUserInteractionEnabled = false
        }
        timeRemaining.text = stringFromTimeInterval(timerCounter!)
        timerCounter! -= 1
    }
    
}
