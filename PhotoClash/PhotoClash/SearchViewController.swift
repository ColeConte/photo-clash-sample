//
//  SearchViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/17/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    lazy var searchBar: UISearchBar! = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    @IBOutlet weak var peopleButton: UIButton!
    @IBOutlet weak var tagsButton: UIButton!
    @IBOutlet weak var peopleBar: UIView!
    @IBOutlet weak var tagsBar: UIView!
    @IBOutlet weak var backBar: UIView!
    var users = [UserProfile]()
    var tags: [String:Int] = [:]
    var filteredTags: [String:Int] = [:]
    lazy var tagButtons: [UIButton] = []
    var filteredUsers = [UserProfile]()
    var presentingPopover: PreviewViewController?
    var userToPresent: UserProfile?
    var xPress: CGFloat?
    var yPress: CGFloat?
    var selectedIndex: Int?
    var usersSelected = true
    
    @IBAction func backButtonPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func peopleButtonPress(sender: UIButton){
        usersSelected = true
        for button in tagButtons{
            button.hidden = true
        }
        suggestionsCollectionView.hidden = false
        suggestionsCollectionView.userInteractionEnabled = true
        peopleButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        peopleBar.backgroundColor = UIColor.orangeColor()
        tagsButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        tagsBar.backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func tagsButtonPress(sender: UIButton){
        usersSelected = false
        for button in tagButtons{
            button.hidden = false
        }
        suggestionsCollectionView.hidden = true
        suggestionsCollectionView.userInteractionEnabled = false
        peopleButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        peopleBar.backgroundColor = UIColor.lightGrayColor()
        tagsButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        tagsBar.backgroundColor = UIColor.orangeColor()
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.frame.size = CGSize(width: view.frame.width - 40, height: 20)
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.tintColor = UIColor.whiteColor()
        self.searchBar.barTintColor = UIColor.whiteColor()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.searchBar)
        definesPresentationContext = true
        //sample
        tags = ["lit":6, "ootd": 10, "100likes": 2, "tbt": 1, "solit": 4, "fire": 3, "girlswholift": 1, "twerk":3, "blacktwitter":3, "finsta":3, "ootw":1, "hashtag":6, "abc":4, "leet":1, "dartboard":3, "basketball":1, "ballislife":12,"pig":2, "photoclash":3, "pc":2]
        filteredTags = tags
        addTagsToView()
        for button in tagButtons{
            button.hidden = true
        }
        users = facebookFriends
        filteredUsers = users
        self.automaticallyAdjustsScrollViewInsets = false
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.backgroundColor = UIColor.whiteColor()
        definesPresentationContext = true
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.addTarget(self, action: #selector(SearchViewController.tappedScreen))
        navigationController?.navigationBar.addGestureRecognizer(tap)
        let longPress = UILongPressGestureRecognizer()
        longPress.delegate = self
        longPress.addTarget(self, action: #selector(SearchViewController.clickAndHoldSuggestion))
        suggestionsCollectionView.addGestureRecognizer(longPress)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareUI()
    }
    
    // MARK: prepareVC
    func prepareUI(){
        //self.addRefreshControl()
    }
    
    func tappedScreen(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func clickAndHoldSuggestion(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            presentingPopover!.dismissViewControllerAnimated(true, completion: nil)
            presentingPopover = nil
        }
        else if sender.state == UIGestureRecognizerState.Began{
            let indexPath = suggestionsCollectionView.indexPathForItemAtPoint(sender.locationInView(suggestionsCollectionView))
            if indexPath != nil {
                xPress = sender.locationInView(suggestionsCollectionView).x
                yPress = sender.locationInView(suggestionsCollectionView).y
                selectedIndex = indexPath?.row
                performSegueWithIdentifier("PresentPopover", sender: nil)
            }
        }
    }
    

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == ""{
                filteredUsers = users
                filteredTags = tags
            }
            else{
                filteredUsers = users.filter { user in
                    return user.username.lowercaseString.containsString(searchText.lowercaseString)
                }
                let filtered = tags.filter { tag in
                    return tag.0.lowercaseString.containsString(searchText.lowercaseString)
                }
                filteredTags = [:]
                for result in filtered{
                    filteredTags[result.0] = result.1
                }
            }
            suggestionsCollectionView.reloadData()

            addTagsToView()
    }
    
    func addTagsToView(){
        for button in tagButtons{
            button.removeFromSuperview()
        }
        tagButtons = []
        var startX = 20
        var startY = Int(backBar.frame.maxY) + 8
        let sortedTags = filteredTags.keysSortedByValue(>)
        if sortedTags.count > 0 {
            let maxHits = filteredTags[sortedTags[0]]!
            for tag in sortedTags{
                let frame = CGRect(x: startX, y: startY, width: 100, height: 30)
                let button = UIButton(frame:frame)
                button.setTitle("#" + tag, forState: .Normal)
                button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                let newAlpha = CGFloat(filteredTags[tag]!) / CGFloat(maxHits)
                button.alpha = newAlpha
                view.addSubview(button)
                if CGFloat(startY + 50) > view.frame.height{
                    startX += 110
                    startY = Int(backBar.frame.maxY) + 8
                }
                else{
                    startY += 30
                }
                tagButtons += [button]
            }
        }

    }
    

    
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        userToPresent = filteredUsers[indexPath.row]
        performSegueWithIdentifier("ToUserProfile", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SuggestionCell = collectionView.dequeueReusableCellWithReuseIdentifier("SuggestionCell", forIndexPath: indexPath) as! SuggestionCell
        cell.image.image = filteredUsers[indexPath.row].profilePicture
        return cell
    }
    
    
    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView( collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let cellLeg = (collectionView.frame.size.width/3 - 1)
        return CGSizeMake(cellLeg,cellLeg)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentPopover"{
            if let destination = (segue.destinationViewController as? PreviewViewController) {
                presentingPopover = destination
                let user = filteredUsers[selectedIndex!]
                destination.user = user
                destination.modalPresentationStyle = .Popover
                destination.preferredContentSize = CGSizeMake(view.frame.width/2,view.frame.height/2)
                let popoverMenuViewController = destination.popoverPresentationController
                popoverMenuViewController?.permittedArrowDirections = .Any
                popoverMenuViewController?.delegate = destination
                popoverMenuViewController?.sourceView = suggestionsCollectionView
                popoverMenuViewController?.sourceRect = CGRect(
                    x: xPress!,
                    y: yPress!,
                    width: 1,
                    height: 1)

            }
        }
        else if segue.identifier == "ToUserProfile"{
            if let destination = (segue.destinationViewController as? UINavigationController)?.childViewControllers.first as? UserProfileViewController{
                destination.user = userToPresent!
            }
        }
    }
    
}

extension Dictionary {
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sort(isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sort() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}

