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
                UIView.animate(withDuration: 2.0, animations: {
                    self.chameleonCell!.chameleon.alpha = 0
                    },
                    completion: {   (result: Bool) in
                        self.hotLocalControl.isHidden = false
                        self.tableView.reloadData()
                    })
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = tableView.indexPathForSelectedRow
        if indexPath != nil{
            tableView.deselectRow(at: indexPath!, animated: false)

        }
    }
    
    override func viewDidLoad() {
        tabBarController?.tabBar.tintColor = UIColor(colorLiteralRed: 163.0/255.0, green: 35.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        hotLocalControl.backgroundColor = UIColor.orange
        super.viewDidLoad()
        hotLocalControl.items = ["Hot", "Local"]
        hotLocalControl.font = UIFont(name: "Futura Medium", size: 17.0)
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        //test data
        //check
        let time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(2 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            let user2 = UserProfile(username: "Trevor Kunz", profilePicture: UIImage(named: "noUser.jpg")!, previousClashes: [], clashpoints: 7, friends: [])
            self.clashes = [FinishedClash(user1: currentUser!, user2: user2,  pic1Pct: 60, pic2Pct: 40, pic1: "happybear.jpg", pic2: "polarbear.jpg"), CurrentClash(user1: currentUser!, user2: currentUser!,  pic1Pct: 60, pic2Pct: 40, pic1: "antelope.jpg", pic2: "penguins.jpg", startTime: Date())]
        }
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
                theCell.scrollView.isPagingEnabled = true
            }
            else{
                let theCell = cell as! CurrentClashTableViewCell
                let theClash = clashes![indexPath.row] as! CurrentClash
                theCell.image1.image = theClash.pic1
                theCell.image2.image = theClash.pic2
                theCell.currentClash = theClash
                theCell.scrollView.delegate = theCell
                theCell.scrollView.isPagingEnabled = true
            }
        }
        else{
            hotLocalControl.isHidden = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clashes == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingClashesCell") as! LoadingClashesTableViewCell
            chameleonCell = cell
            return cell
        }
        if let _ = clashes![indexPath.row] as? FinishedClash{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedClashCell") as! FinishedClashTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentClashCell") as! CurrentClashTableViewCell
            return cell
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clashes == nil{
            return 1
        }
        return clashes!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //find correct spot
        if let finishedClash = clashes![indexPath.row] as? FinishedClash{
            if let finishedClashCell = tableView.cellForRow(at: indexPath) as? FinishedClashTableViewCell{
                if finishedClashCell.pageControl.currentPage == 0{
                    userToPresent = finishedClash.user1
                }
                else{
                    userToPresent = finishedClash.user2
                }
                performSegue(withIdentifier: "ToUserProfile", sender: nil)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if clashes == nil{
            return tableView.frame.height
        }
        return tableView.frame.width + 61
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToUserProfile"{
            if let destination = (segue.destination as? UINavigationController)?.childViewControllers.first as? UserProfileViewController{
                destination.user = userToPresent
            }
        }
    }

}
