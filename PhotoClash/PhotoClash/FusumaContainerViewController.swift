//
//  FusumaContainerViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/19/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import Foundation
import Fusuma

class FusumaContainerViewController: UIViewController, FusumaDelegate{
    
    var photoToEdit: UIImage?
    var fusumaView: FusumaViewController?

    
    override func viewDidLoad() {
        tabBarController?.tabBar.hidden = true
        super.viewDidLoad()
        if self.childViewControllers.count == 1{
            fusumaView = self.childViewControllers[0] as? FusumaViewController
            fusumaView!.delegate = self
            fusumaCropImage = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(image: UIImage) {
        photoToEdit = image
        performSegueWithIdentifier("ToEditPhoto", sender: nil)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil{
            if segue.identifier! == "ToEditPhoto"{
                if let destination = (segue.destinationViewController as? EditPhotoViewController){
                    destination.photoToEdit = photoToEdit
                }
            }
        }
        
    }
    
}