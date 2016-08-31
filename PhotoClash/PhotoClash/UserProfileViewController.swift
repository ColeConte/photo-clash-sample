//
//  UserProfileViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/25/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bar1: UIView!
    @IBOutlet weak var bar2: UIView!
    @IBOutlet weak var bar3: UIView!
    @IBOutlet weak var recentClashesButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var clashpointsButton: UIButton!
    @IBOutlet weak var clashpointsContainerView: UIView!
    @IBOutlet weak var friendsContainerView: UIView!
    @IBAction func backButtonPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var user: UserProfile?

    @IBAction func pressedRecentClashesButton(sender: UIButton){
        recentClashesButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        friendsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        clashpointsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        bar1.backgroundColor = UIColor.orangeColor()
        bar2.backgroundColor = UIColor.lightGrayColor()
        bar3.backgroundColor = UIColor.lightGrayColor()
        clashpointsContainerView.hidden = true
        friendsContainerView.hidden = true

    }
    
    @IBAction func pressedFriendsButton(sender: UIButton){
        friendsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        recentClashesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        clashpointsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        bar2.backgroundColor = UIColor.orangeColor()
        bar1.backgroundColor = UIColor.lightGrayColor()
        bar3.backgroundColor = UIColor.lightGrayColor()
        clashpointsContainerView.hidden = true
        friendsContainerView.hidden = false

    }
    
    @IBAction func pressedClashpointsButton(sender: UIButton){
        clashpointsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        friendsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        recentClashesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        bar3.backgroundColor = UIColor.orangeColor()
        bar2.backgroundColor = UIColor.lightGrayColor()
        bar1.backgroundColor = UIColor.lightGrayColor()
        clashpointsContainerView.hidden = false
        friendsContainerView.hidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clashpointsContainerView.hidden = true
        friendsContainerView.hidden = false
        profilePic.layer.cornerRadius = profilePic.frame.size.height/4
        profilePic.clipsToBounds = true
        profilePic.image = user?.profilePicture
        username.text = user?.username
        navigationItem.title = user?.username
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ClashpointsEmbed"{
            if let clashpointsVC = segue.destinationViewController as? ClashpointsContainerViewController{
                clashpointsVC.user = user
            }
        }
    }
    
}
