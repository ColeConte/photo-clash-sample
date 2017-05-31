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
    public func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        //todo
    }

    
    var photoToEdit: UIImage?
    var fusumaView: FusumaViewController?

    
    override func viewDidLoad() {
        tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        if self.childViewControllers.count == 1{
            fusumaView = self.childViewControllers[0] as? FusumaViewController
            fusumaView!.delegate = self
            fusumaCropImage = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        photoToEdit = image
        performSegue(withIdentifier: "ToEditPhoto", sender: nil)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil{
            if segue.identifier! == "ToEditPhoto"{
                if let destination = (segue.destination as? EditPhotoViewController){
                    destination.photoToEdit = photoToEdit
                }
            }
        }
        
    }
    
}
