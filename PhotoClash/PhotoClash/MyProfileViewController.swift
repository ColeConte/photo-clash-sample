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

    
    @IBAction func pressedNotificationsButton(sender: UIButton){
        notificationsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        myLocationButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        clashpointsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        bar1.backgroundColor = UIColor.orangeColor()
        bar2.backgroundColor = UIColor.lightGrayColor()
        bar3.backgroundColor = UIColor.lightGrayColor()
        notificationsContainerView.hidden = false
        locationContainerView.hidden = true
        clashpointsContainerView.hidden = true


    }
    
    @IBAction func pressedMyLocationButton(sender: UIButton){
        notificationsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        myLocationButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        clashpointsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        bar1.backgroundColor = UIColor.lightGrayColor()
        bar2.backgroundColor = UIColor.orangeColor()
        bar3.backgroundColor = UIColor.lightGrayColor()
        notificationsContainerView.hidden = true
        locationContainerView.hidden = false
        clashpointsContainerView.hidden = true


    }
    
    @IBAction func pressedClashpointsButton(sender: UIButton){
        notificationsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        myLocationButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        clashpointsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        bar1.backgroundColor = UIColor.lightGrayColor()
        bar2.backgroundColor = UIColor.lightGrayColor()
        bar3.backgroundColor = UIColor.orangeColor()
        notificationsContainerView.hidden = true
        locationContainerView.hidden = true
        clashpointsContainerView.hidden = false



    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.cornerRadius = profilePic.frame.size.height/4
        profilePic.clipsToBounds = true
        notificationsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        bar2.backgroundColor = UIColor.lightGrayColor()
        bar3.backgroundColor = UIColor.lightGrayColor()
        notificationsContainerView.hidden = false
        locationContainerView.hidden = true
        clashpointsContainerView.hidden = true



        // Do any additional setup after loading the view.
    }

   
}
