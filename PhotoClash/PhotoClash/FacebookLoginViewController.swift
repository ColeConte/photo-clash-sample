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
        if FBSDKAccessToken.current() != nil {
            self.performSegue(withIdentifier: "ToTabBar", sender: nil)
        }
        else{
            let loginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile","user_friends"]
            self.view.addSubview(loginButton)
            loginButton.delegate = self
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).start { (connection, result, error) -> Void in
            if error == nil{
                if let dic = result as? NSDictionary{
                    let strFirstName: String = (dic["first_name"] as? String)!
                    let strLastName: String = (dic["last_name"] as? String)!
                    let strPictureURL: String = ((((dic["picture"] as! NSDictionary)["data"]) as! NSDictionary)["url"] as? String)!
                    let image : UIImage = UIImage(data: try! Data(contentsOf: URL(string: strPictureURL)!))!
                    let name = strFirstName + " " + strLastName
                    currentUser = UserProfile(username: name, profilePicture: image, previousClashes: [], clashpoints: 0, friends: [])
                    self.friendsGraphRequest()
                }
            }
        }
    }
    
    
    func friendsGraphRequest(){
        FBSDKGraphRequest.init(graphPath: "me/taggable_friends", parameters: ["fields":"first_name, last_name, picture.type(large)"]).start { (connection,result,error) -> Void in
            if error == nil{
                if let resultDict = result as? NSDictionary{
                    if let friendObjects = resultDict["data"] as? NSArray{
                        for friend in friendObjects{
                            if let friendDict = friend as? NSDictionary{
                                let strFirstName: String = (friendDict["first_name"] as? String)!
                                let strLastName: String = (friendDict["last_name"] as? String)!
                                let strPictureURL: String = ((((friendDict["picture"] as! NSDictionary)["data"]) as! NSDictionary)["url"] as? String)!
                                let image : UIImage = UIImage(data: try! Data(contentsOf: URL(string: strPictureURL)!))!
                                let name = strFirstName + " " + strLastName
                                let friend = UserProfile(username: name, profilePicture: image, previousClashes: [], clashpoints: 0, friends: [])
                                facebookFriends += [friend]
                            }
                                                        }
                        currentUser?.friends = facebookFriends
                        self.performSegue(withIdentifier: "ToTabBar", sender: nil)
                    }
                }
                }

                //let friendObjects = result.object(forKey: "data") as! [NSDictionary]

            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

}
