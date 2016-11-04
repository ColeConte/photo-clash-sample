//
//  SearchViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/17/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    lazy var searchBar: UISearchBar! = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var peopleButton: UIButton!
    @IBOutlet weak var tagsButton: UIButton!
    @IBOutlet weak var peopleBar: UIView!
    @IBOutlet weak var tagsBar: UIView!
    @IBOutlet weak var backBar: UIView!
    var users = [UserProfile]()
    var tags: [String:Int] = [:]
    var sortedTags: [String] = []
    var filteredTags: [String:Int] = [:]
    var filteredUsers = [UserProfile]()
    var presentingPopover: PreviewViewController?
    var userToPresent: UserProfile?
    var xPress: CGFloat?
    var yPress: CGFloat?
    var selectedIndex: Int?
    var usersSelected = true
    var previousTagScrolled: BlurrableCollectionView?
    
    @IBAction func backButtonPress(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func peopleButtonPress(_ sender: UIButton){
        usersSelected = true
        tagsTableView.isHidden = true
        suggestionsCollectionView.isHidden = false
        suggestionsCollectionView.isUserInteractionEnabled = true
        peopleButton.setTitleColor(UIColor.orange, for: UIControlState())
        peopleBar.backgroundColor = UIColor.orange
        tagsButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        tagsBar.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func tagsButtonPress(_ sender: UIButton){
        usersSelected = false
        tagsTableView.isHidden = false
        suggestionsCollectionView.isHidden = true
        suggestionsCollectionView.isUserInteractionEnabled = false
        peopleButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        peopleBar.backgroundColor = UIColor.lightGray
        tagsButton.setTitleColor(UIColor.orange, for: UIControlState())
        tagsBar.backgroundColor = UIColor.orange
    }

    //why?
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.frame.size = CGSize(width: view.frame.width - 40, height: 20)
        self.searchBar.searchBarStyle = UISearchBarStyle.minimal
        self.searchBar.tintColor = UIColor.white
        self.searchBar.barTintColor = UIColor.white
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.searchBar)
        definesPresentationContext = true
        //sample
        tags = ["lit":6, "ootd": 10, "100likes": 2, "tbt": 1, "solit": 4, "fire": 3, "girlswholift": 1, "twerk":3, "blacktwitter":3, "finsta":3, "ootw":1, "hashtag":6, "abc":4, "leet":1, "dartboard":3, "basketball":1, "ballislife":12,"pig":2, "photoclash":3, "pc":2]
        filteredTags = tags
        addTagsToView()
        tagsTableView.isHidden = true
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        users = facebookFriends
        filteredUsers = users
        self.automaticallyAdjustsScrollViewInsets = false
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.backgroundColor = UIColor.white
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
    
    
    
    
    func tappedScreen(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func clickAndHoldSuggestion(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended{
            presentingPopover!.dismiss(animated: true, completion: nil)
            presentingPopover = nil
        }
        else if sender.state == UIGestureRecognizerState.began{
            let indexPath = suggestionsCollectionView.indexPathForItem(at: sender.location(in: suggestionsCollectionView))
            if indexPath != nil {
                xPress = sender.location(in: suggestionsCollectionView).x
                yPress = sender.location(in: suggestionsCollectionView).y
                selectedIndex = indexPath?.row
                performSegue(withIdentifier: "PresentPopover", sender: nil)
            }
        }
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == ""{
                filteredUsers = users
                filteredTags = tags
            }
            else{
                filteredUsers = users.filter { user in
                    return user.username.lowercased().contains(searchText.lowercased())
                }
                let filtered = tags.filter { tag in
                    return tag.0.lowercased().contains(searchText.lowercased())
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
        sortedTags = filteredTags.keysSortedByValue(>)
        tagsTableView.reloadData()
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTags.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "ImagesCell")! as! CollectionViewTableViewCell
        cell.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "ImagesCell")! as! CollectionViewTableViewCell
        cell.hashtag.text = "#" + sortedTags[indexPath.row]
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width/3 // -1
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != tagsTableView && scrollView != suggestionsCollectionView{
            let tagsCollectionView = scrollView as! BlurrableCollectionView
            if tagsCollectionView != previousTagScrolled{
                if previousTagScrolled != nil{
                    let previousTagsTableViewCell = previousTagScrolled?.superview?.superview as! CollectionViewTableViewCell
                    previousTagsTableViewCell.hashtag.isHidden = false
                    previousTagScrolled!.blurEffect!.isHidden = false
                    print(tagsCollectionView.tag)
                }
                let tagsTableViewCell = tagsCollectionView.superview?.superview as! CollectionViewTableViewCell
                print(tagsCollectionView.tag)
                tagsTableViewCell.hashtag.isHidden = true
                tagsCollectionView.blurEffect?.isHidden = true
                previousTagScrolled = tagsCollectionView
            }
            
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestionsCollectionView{
            return filteredUsers.count
        }
        else{
            let tag = sortedTags[collectionView.tag]
            return filteredTags[tag]!
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionsCollectionView{
            userToPresent = filteredUsers[indexPath.row]
            performSegue(withIdentifier: "ToUserProfile", sender: nil)
        }
        else{
            //TODO
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == suggestionsCollectionView{
            let cell:SuggestionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
            cell.image.image = filteredUsers[indexPath.row].profilePicture
            return cell
        }
        else{
            let cell:ClashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClashCell", for: indexPath) as! ClashCell
            let originalImage = UIImage(named: "polarbear.jpg")!
            cell.image.image = originalImage
            return cell
        }


    }
    
    
    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView (_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellLeg = (collectionView.frame.size.width/3 - 1)
        return CGSize(width: cellLeg,height: cellLeg)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentPopover"{
            if let destination = (segue.destination as? PreviewViewController) {
                presentingPopover = destination
                let user = filteredUsers[selectedIndex!]
                destination.user = user
                destination.modalPresentationStyle = .popover
                destination.preferredContentSize = CGSize(width: view.frame.width/2,height: view.frame.width/2)
                //destination.view.layer.cornerRadius = destination.view.frame.width / 4
                //destination.view.clipsToBounds = false
                let popoverMenuViewController = destination.popoverPresentationController
                popoverMenuViewController?.permittedArrowDirections = .any
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
            if let destination = (segue.destination as? UINavigationController)?.childViewControllers.first as? UserProfileViewController{
                destination.user = userToPresent!
            }
        }
    }
    
}

extension Dictionary {
    func sortedKeys(_ isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sorted(by: isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
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

