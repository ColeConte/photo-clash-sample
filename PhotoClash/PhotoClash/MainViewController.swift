//
//  MainViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 5/26/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit
import Fusuma


class MainViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var pictureView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        pictureView.hidden = true
        bottomMemeText.hidden = true
        bottomMemeText.enabled = false
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        let chooseFromPhotoLibrary = UIAlertAction(title: "Choose From Photo Library", style: .Default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let takeAPhoto = UIAlertAction(title: "Take a Photo", style: .Default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler:{
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(chooseFromPhotoLibrary)
        optionMenu.addAction(takeAPhoto)
        optionMenu.addAction(cancel)
        self.presentViewController(optionMenu, animated: true, completion: nil)
        bottomMemeText.text = ""

        self.imagePicker.sourceType = .Camera
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    
    /// MARK: - Helper functions
    func resizeNewImage(image: UIImage)->UIImage{
        let width = self.view.frame.width
        let height = self.view.frame.height
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        image.drawInRect(CGRectMake(0, 0, width, height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    //Calls this function when the tap is recognized. Causes the view (or one of its embedded text fields) to resign the first responder status.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// moves the view up when the keyboard comes up
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    /// moves the view down when the keyboard goes away
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y += keyboardSize.height

        }
    }


    /// MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureView.contentMode = .Center
            let newImage = resizeNewImage(pickedImage)
            pictureView.image = newImage
            pictureView.hidden = false
            bottomMemeText.hidden = false
            bottomMemeText.enabled = true
        }
        dismissViewControllerAnimated(false, completion: nil)
    }


}
