//
//  MainFeedViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var hotLocalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var clashes = [FinishedClash(user1: "Cole Conte", user2: "Trevor Kunz", profPic1: "noUser.jpg", profPic2: "noUser.jpg", pic1Pct: 60, pic2Pct: 40, pic1: "5star.png", pic2: "noUser.jpg"), CurrentClash(user1: "Cole Conte", user2: "Trevor Kunz", profPic1: "noUser.jpg", profPic2: "noUser.jpg", pic1Pct: 60, pic2Pct: 40, pic1: "5star.png", pic2: "noUser.jpg", startTime: NSDate())]

    override func viewDidLoad() {
        tabBarController?.tabBar.tintColor = UIColor.orangeColor()
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let theCell = cell as? FinishedClashTableViewCell{
            let theClash = clashes[indexPath.row] as! FinishedClash
            theCell.image1.image = theClash.pic1
            theCell.image2.image = theClash.pic2
            theCell.profilePic.image = theClash.profPic1
            theCell.votePercentage.text = String(theClash.pic1Pct) + "%"
            theCell.userName.text = theClash.user1
            theCell.finishedClash = theClash
            theCell.scrollView.delegate = theCell
            theCell.scrollView.pagingEnabled = true
        }
        else{
            let theCell = cell as! CurrentClashTableViewCell
            let theClash = clashes[indexPath.row] as! CurrentClash
            theCell.image1.image = theClash.pic1
            theCell.image2.image = theClash.pic2
            theCell.currentClash = theClash
            theCell.scrollView.delegate = theCell
            theCell.scrollView.pagingEnabled = true
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let _ = clashes[indexPath.row] as? FinishedClash{
            let cell = tableView.dequeueReusableCellWithIdentifier("FinishedClashCell") as! FinishedClashTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentClashCell") as! CurrentClashTableViewCell
            return cell
        }
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clashes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.width + 61
    }
    


}
