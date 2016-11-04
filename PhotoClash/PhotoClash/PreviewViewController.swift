//
//  PreviewViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 8/23/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!

    
    var user: UserProfile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = user?.profilePicture
        name.text = user?.username
        connectionLabel.text = "You and " + user!.username + " are friends on Facebook."
    }
    
    
    
    /// MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
