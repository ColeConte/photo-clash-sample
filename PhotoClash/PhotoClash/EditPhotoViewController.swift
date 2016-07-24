//
//  EditPhotoViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/19/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit
import CoreImage

class EditPhotoViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBAction func backButtonPress() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    var photoToEdit: UIImage?
    var coreImage: CIImage?
    var inTextField: Bool = false
    var textWriteLocation: CGPoint?
    var textField: UITextField?
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    let textTapRec = UITapGestureRecognizer()
    let dragRec = UIPanGestureRecognizer()
    var curFilter = -1
    let filters: [CIFilter?] = [CIFilter(name: "CIPhotoEffectChrome"), CIFilter(name: "CIColorMatrix"), CIFilter(name: "CIPhotoEffectTonal"), CIFilter(name: "CIPhotoEffectTransfer")]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = photoToEdit
        guard let image = photo.image, cgimg = image.CGImage else {
            print("imageView doesn't have an image!")
            return
        }
        coreImage = CIImage(CGImage: cgimg)
        swipeRightRec.direction = .Right
        swipeRightRec.addTarget(self, action: #selector(EditPhotoViewController.swipedViewRight))
        swipeLeftRec.direction = .Left
        swipeLeftRec.addTarget(self, action: #selector(EditPhotoViewController.swipedViewLeft))
        tapRec.addTarget(self, action: #selector(EditPhotoViewController.tappedImage))
        dragRec.addTarget(self, action: #selector(EditPhotoViewController.draggedText))
        textTapRec.addTarget(self, action: #selector(EditPhotoViewController.tappedText))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditPhotoViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        photo.addGestureRecognizer(swipeRightRec)
        photo.addGestureRecognizer(swipeLeftRec)
        photo.addGestureRecognizer(tapRec)
        photo.userInteractionEnabled = true
        textField = UITextField(frame: CGRectMake(0, self.view.frame.height/2, self.view.frame.width, 30))
        textField!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        textField!.textColor = UIColor.whiteColor()

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func draggedText(sender: AnyObject){
        let imageView = (sender as! UIPanGestureRecognizer).view as! TextImageView
        let finalLocation = sender.locationInView(view)
        imageView.frame = CGRectMake(finalLocation.x, finalLocation.y, imageView.frame.width, imageView.frame.height)
    }
    
    func tappedText(sender: AnyObject){
        let tapRecognizer = sender as! UITapGestureRecognizer
        let imageView = tapRecognizer.view as! TextImageView
        textWriteLocation = CGPoint(x: imageView.frame.minX, y: imageView.frame.minY)
        imageView.removeFromSuperview()
        //how to delete?
        inTextField = true
        textField!.text = imageView.text
        self.view.addSubview(textField!)
        textField?.becomeFirstResponder()
    }
    
    func tappedImage(){
        if inTextField{
            textField!.resignFirstResponder()
            if textField!.text != ""{
                let text = textField!.text
                textField!.text = ""
                textField!.frame = CGRectMake(0, view.frame.height/2, view.frame.width, 40)
                let textImage = textToImage(text!)
                let textImageView = TextImageView(frame: CGRectMake(textWriteLocation!.x, textWriteLocation!.y, textImage.size.width, textImage.size.height))
                textImageView.image = textImage
                textImageView.text = text
                view.addSubview(textImageView)
                textImageView.userInteractionEnabled = true
                textImageView.addGestureRecognizer(dragRec)
                textImageView.addGestureRecognizer(textTapRec)
                view.bringSubviewToFront(textImageView)
            }
            textField!.removeFromSuperview()
            view.endEditing(true)
            inTextField = false

        }
        else{
            textWriteLocation = tapRec.locationInView(view)
            inTextField = true
            self.view.addSubview(textField!)
            textField!.becomeFirstResponder()

        }
    }
    
    func textToImage(drawText: NSString)->UIImage{
        let paragraphStyle = NSMutableParagraphStyle()
        let attrs = [NSFontAttributeName: UIFont(name: "Helvetica Bold", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let width = (NSAttributedString(string: drawText as String, attributes: attrs).widthWithConstrainedHeight(30))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: 40), false, 0)
        let point = CGPoint(x: 0, y: 0)
        drawText.drawAtPoint(point, withAttributes: attrs)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
        /*
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
                let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage*/
        
    }
    
    func swipedViewRight(){
        if curFilter == filters.count - 1{
            curFilter = -1
        }
        else{
            curFilter += 1
        }
        if curFilter != -1{
            filters[curFilter]!.setValue(coreImage, forKey: kCIInputImageKey)
            let openGLContext = EAGLContext(API: .OpenGLES2)
            let context = CIContext(EAGLContext: openGLContext)
            if let output = filters[curFilter]!.valueForKey(kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(output, fromRect: output.extent)
                let result = UIImage(CGImage: cgimgresult)
                photo.image = result
            }
                
            else {
                print("image filtering failed")
            }
        }
        else{
            photo.image = photoToEdit
        }
    }
    func swipedViewLeft(){
        if curFilter == -1{
            curFilter = filters.count - 1
        }
        else{
            curFilter -= 1
        }
        if curFilter != -1{
            filters[curFilter]!.setValue(coreImage, forKey: kCIInputImageKey)
            //can we move around the context thingy
            let openGLContext = EAGLContext(API: .OpenGLES2)
            let context = CIContext(EAGLContext: openGLContext)
            if let output = filters[curFilter]!.valueForKey(kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(output, fromRect: output.extent)
                let result = UIImage(CGImage: cgimgresult)
                photo.image = result

            }
                
            else {
                print("image filtering failed")
            }
        }
        else{
            photo.image = photoToEdit
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            textField!.frame = CGRectMake(0, view.frame.maxY - keyboardSize.height - 30, view.frame.width, 30)
        }
        
    }
    
}

extension NSAttributedString{
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat{
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}
