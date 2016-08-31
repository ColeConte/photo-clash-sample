//
//  FacebookLoginViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/15/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit
import FBSDKLoginKit

var currentUser: UserProfile?
var facebookFriends: [UserProfile] = []

class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.performSegueWithIdentifier("ToTabBar", sender: nil)
        }
        else{
            let loginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile","user_friends"]
            self.view.addSubview(loginButton)
            loginButton.delegate = self
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil{
                let strFirstName: String = (result.objectForKey("first_name") as? String)!
                let strLastName: String = (result.objectForKey("last_name") as? String)!
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                let image : UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)!
                let name = strFirstName + " " + strLastName
                currentUser = UserProfile(username: name, profilePicture: image, previousClashes: [], clashpoints: 0, friends: [])
                self.performSegueWithIdentifier("ToTabBar", sender: nil)
            }
        }
        FBSDKGraphRequest.init(graphPath: "me/invitable_friends", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection,result,error) -> Void in
            if error == nil{
                let friendObjects = result.objectForKey("data") as! [NSDictionary]
                for friend in friendObjects{
                    let strFirstName: String = (friend.objectForKey("first_name") as? String)!
                    let strLastName: String = (friend.objectForKey("last_name") as? String)!
                    let strPictureURL: String = (friend.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    let image : UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)!
                    let name = strFirstName + " " + strLastName
                    let friend = UserProfile(username: name, profilePicture: image, previousClashes: [], clashpoints: 0, friends: [])
                    facebookFriends += [friend]
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

}
