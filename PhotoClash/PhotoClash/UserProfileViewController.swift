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
    @IBAction func backButtonPress(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    var user: UserProfile?

    @IBAction func pressedRecentClashesButton(_ sender: UIButton){
        recentClashesButton.setTitleColor(UIColor.orange, for: UIControlState())
        friendsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        clashpointsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        bar1.backgroundColor = UIColor.orange
        bar2.backgroundColor = UIColor.lightGray
        bar3.backgroundColor = UIColor.lightGray
        clashpointsContainerView.isHidden = true
        friendsContainerView.isHidden = true

    }
    
    @IBAction func pressedFriendsButton(_ sender: UIButton){
        friendsButton.setTitleColor(UIColor.orange, for: UIControlState())
        recentClashesButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        clashpointsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        bar2.backgroundColor = UIColor.orange
        bar1.backgroundColor = UIColor.lightGray
        bar3.backgroundColor = UIColor.lightGray
        clashpointsContainerView.isHidden = true
        friendsContainerView.isHidden = false
    }
    
    @IBAction func pressedClashpointsButton(_ sender: UIButton){
        clashpointsButton.setTitleColor(UIColor.orange, for: UIControlState())
        friendsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        recentClashesButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        bar3.backgroundColor = UIColor.orange
        bar2.backgroundColor = UIColor.lightGray
        bar1.backgroundColor = UIColor.lightGray
        clashpointsContainerView.isHidden = false
        friendsContainerView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clashpointsContainerView.isHidden = true
        friendsContainerView.isHidden = true
        profilePic.layer.cornerRadius = profilePic.frame.size.height/4
        profilePic.clipsToBounds = true
        profilePic.image = user?.profilePicture
        username.text = user?.username
        navigationItem.title = user?.username
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsEmbed"{
            if let friendsVC = segue.destination as? FriendsTableViewController{
                friendsVC.user = user
            }
        }
        else if segue.identifier == "ClashpointsEmbed"{
            if let clashpointsVC = segue.destination as? ClashpointsContainerViewController{
                clashpointsVC.user = user
            }
        }
    }
    
}
