//
//  MyProfileViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var clashpointsButton: UIButton!
    @IBOutlet weak var clashpointsContainerView: UIView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var notificationsContainerView: UIView!
    @IBOutlet weak var bar1: UIView!
    @IBOutlet weak var bar2: UIView!
    @IBOutlet weak var bar3: UIView!

    
    @IBAction func pressedNotificationsButton(_ sender: UIButton){
        notificationsButton.setTitleColor(UIColor.orange, for: UIControlState())
        myLocationButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        clashpointsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        bar1.backgroundColor = UIColor.orange
        bar2.backgroundColor = UIColor.lightGray
        bar3.backgroundColor = UIColor.lightGray
        notificationsContainerView.isHidden = false
        locationContainerView.isHidden = true
        clashpointsContainerView.isHidden = true
    }
    
    @IBAction func pressedMyLocationButton(_ sender: UIButton){
        notificationsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        myLocationButton.setTitleColor(UIColor.orange, for: UIControlState())
        clashpointsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        bar1.backgroundColor = UIColor.lightGray
        bar2.backgroundColor = UIColor.orange
        bar3.backgroundColor = UIColor.lightGray
        notificationsContainerView.isHidden = true
        locationContainerView.isHidden = false
        clashpointsContainerView.isHidden = true
    }
    
    @IBAction func pressedClashpointsButton(_ sender: UIButton){
        notificationsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        myLocationButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        clashpointsButton.setTitleColor(UIColor.orange, for: UIControlState())
        bar1.backgroundColor = UIColor.lightGray
        bar2.backgroundColor = UIColor.lightGray
        bar3.backgroundColor = UIColor.orange
        notificationsContainerView.isHidden = true
        locationContainerView.isHidden = true
        clashpointsContainerView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.image = currentUser?.profilePicture
        userName.text = currentUser?.username
        profilePic.layer.cornerRadius = profilePic.frame.size.height/4
        profilePic.clipsToBounds = true
        notificationsButton.setTitleColor(UIColor.orange, for: UIControlState())
        bar2.backgroundColor = UIColor.lightGray
        bar3.backgroundColor = UIColor.lightGray
        notificationsContainerView.isHidden = false
        locationContainerView.isHidden = true
        clashpointsContainerView.isHidden = true

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClashpointsEmbed"{
            if let clashpointsVC = segue.destination as? ClashpointsContainerViewController{
                clashpointsVC.user = currentUser
            }
        }
    }
    


   
}
