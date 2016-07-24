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
    @IBOutlet weak var heart: UILabel!
    @IBOutlet weak var heart2: UILabel!
    var currentClash: CurrentClash!{
        didSet{
            //off by one second
            let oneDay: NSTimeInterval = 60.0*60.0*24.0
            let currentTime = NSDate()
            timerCounter = currentClash.startTime.dateByAddingTimeInterval(oneDay).timeIntervalSinceDate(currentTime)
            timeRemaining.text = stringFromTimeInterval(timerCounter!)
            startTimer()
        }
    }
    var timerCounter: NSTimeInterval?
    
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped) )
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        super.awakeFromNib()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page:Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControl.currentPage = page
    }
    
    func doubleTapped(){
        var theHeart: UILabel?
        if pageControl.currentPage == 0{
            theHeart = heart
        }
        else{
            theHeart = heart2
        }
        theHeart!.hidden = false
        theHeart!.alpha = 1.0
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: {
            
            theHeart!.alpha = 0
            
            }, completion: {
                (value:Bool) in
                
                theHeart!.hidden = true
        })
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CurrentClashTableViewCell.onTimer(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(timer:NSTimer!) {
        // Here is the string containing the timer
        // Update your label here
        if timerCounter == 0.0{
            //make this better
            timeRemaining.text = "00:00:00!!!"
            self.userInteractionEnabled = false
        }
        timeRemaining.text = stringFromTimeInterval(timerCounter!)
        timerCounter! -= 1
    }
    
}
