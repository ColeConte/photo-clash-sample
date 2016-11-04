//
//  FriendsTableViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/28/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: UserProfile?

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //to implement
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell")!
        let friend = user!.friends[indexPath.row]
        cell.textLabel?.text = friend.username
        cell.textLabel?.font = UIFont(name: "Futura Medium", size: 10.0)
        cell.imageView?.image = friend.profilePicture
//        if indexPath.row % 2 == 1{
//            cell.backgroundColor = UIColor(red: 249.0/255.0, green: 207.0/255.0, blue: 99.0, alpha: 0.1)
//        }
        return cell
    }

    
    
}
