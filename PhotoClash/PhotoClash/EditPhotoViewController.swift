//
//  EditPhotoViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/19/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBAction func backButtonPress() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    var photoToEdit: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = photoToEdit
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
