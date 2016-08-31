//
//  FriendsTableViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/28/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users = [UserProfile]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //to implement
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //to implement
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell")!
        cell.textLabel?.text = "Sample Notification"
        cell.detailTextLabel?.text = "1m"
        return cell
    }

    
    
}
