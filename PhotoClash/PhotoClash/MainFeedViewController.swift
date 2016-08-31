//
//  MainFeedViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var hotLocalControl: CustomControl!
    @IBOutlet weak var tableView: UITableView!
    var chameleonCell: LoadingClashesTableViewCell?
    var userToPresent: UserProfile?
    var clashes: [AnyObject]?{
        willSet{
            if clashes == nil{
                UIView.animateWithDuration(2.0, animations: {
                    self.chameleonCell!.chameleon.alpha = 0
                    },
                    completion: {   (result: Bool) in
                        self.hotLocalControl.hidden = false
                        self.tableView.reloadData()
                    })
            }
        }
    }

    override func viewDidLoad() {
        tabBarController?.tabBar.tintColor = UIColor.orangeColor()
        navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        hotLocalControl.backgroundColor = UIColor.orangeColor()
        super.viewDidLoad()
        hotLocalControl.items = ["Hot", "Local"]
        hotLocalControl.font = UIFont(name: "Futura Medium", size: 17.0)
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        //test data
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.clashes = [FinishedClash(user1: currentUser!, user2: currentUser!,  pic1Pct: 60, pic2Pct: 40, pic1: "5star.png", pic2: "noUser.jpg"), CurrentClash(user1: currentUser!, user2: currentUser!,  pic1Pct: 60, pic2Pct: 40, pic1: "5star.png", pic2: "noUser.jpg", startTime: NSDate())]
        }
    }
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if clashes != nil{
            if let theCell = cell as? FinishedClashTableViewCell{
                let theClash = clashes![indexPath.row] as! FinishedClash
                theCell.image1.image = theClash.pic1
                theCell.image2.image = theClash.pic2
                theCell.profilePic.image = theClash.user1.profilePicture
                theCell.votePercentage.text = String(theClash.pic1Pct) + "%"
                theCell.userName.text = theClash.user1.username
                theCell.finishedClash = theClash
                theCell.scrollView.delegate = theCell
                theCell.scrollView.pagingEnabled = true
            }
            else{
                let theCell = cell as! CurrentClashTableViewCell
                let theClash = clashes![indexPath.row] as! CurrentClash
                theCell.image1.image = theClash.pic1
                theCell.image2.image = theClash.pic2
                theCell.currentClash = theClash
                theCell.scrollView.delegate = theCell
                theCell.scrollView.pagingEnabled = true
            }
        }
        else{
            hotLocalControl.hidden = true
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if clashes == nil{
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadingClashesCell") as! LoadingClashesTableViewCell
            chameleonCell = cell
            return cell
        }
        if let _ = clashes![indexPath.row] as? FinishedClash{
            let cell = tableView.dequeueReusableCellWithIdentifier("FinishedClashCell") as! FinishedClashTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentClashCell") as! CurrentClashTableViewCell
            return cell
        }
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clashes == nil{
            return 1
        }
        return clashes!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //find correct spot
        if let finishedClash = clashes![indexPath.row] as? FinishedClash{
            if let finishedClashCell = tableView.cellForRowAtIndexPath(indexPath) as? FinishedClashTableViewCell{
                if finishedClashCell.pageControl.currentPage == 0{
                    userToPresent = finishedClash.user1
                }
                else{
                    userToPresent = finishedClash.user2
                }
                performSegueWithIdentifier("ToUserProfile", sender: nil)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if clashes == nil{
            return tableView.frame.height
        }
        return tableView.frame.width + 61
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToUserProfile"{
            if let destination = (segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? UserProfileViewController{
                destination.user = userToPresent
            }
        }
    }

}
