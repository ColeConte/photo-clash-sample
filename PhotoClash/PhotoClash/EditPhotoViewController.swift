//
//  EditPhotoViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/19/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit
import CoreImage

class EditPhotoViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var photo: UIImageView!
    @IBAction func backButtonPress() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    var photoToEdit: UIImage?
    var coreImage: CIImage?
    var inTextField: Bool = false
    var textWriteLocation: CGPoint?
    var textField: UITextField?
    var previousTextTapped: TextImageView?
    var inPreviousText = false
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditPhotoViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        photo.addGestureRecognizer(swipeRightRec)
        photo.addGestureRecognizer(swipeLeftRec)
        photo.addGestureRecognizer(tapRec)
        photo.userInteractionEnabled = true
        textField = UITextField(frame: CGRectMake(0, self.view.frame.height/2, self.view.frame.width, 30))
        textField!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        textField!.textColor = UIColor.whiteColor()

    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func pinchedText(sender: UIPinchGestureRecognizer){
        let imageView = sender.view as! TextImageView
        imageView.transform = CGAffineTransformScale(imageView.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    
    func rotatedText(sender: UIRotationGestureRecognizer){
        let imageView = sender.view as! TextImageView
        imageView.transform = CGAffineTransformRotate(imageView.transform, sender.rotation)
        sender.rotation = 0
    }
    
    func draggedText(sender: UIPanGestureRecognizer){
        let imageView = sender.view as! TextImageView
        imageView.transform = CGAffineTransformMakeTranslation(sender.translationInView(imageView).x, sender.translationInView(imageView).y)
        let finalLocation = sender.locationInView(view)
        imageView.frame = CGRectMake(finalLocation.x, finalLocation.y, imageView.frame.width, imageView.frame.height)
    }
    
    func tappedText(sender: UITapGestureRecognizer){
        if inPreviousText{
            view.addSubview(previousTextTapped!)
            inPreviousText = false
        }
        let imageView = sender.view as! TextImageView
        previousTextTapped = imageView
        inPreviousText = true
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
            inPreviousText = false
            if textField!.text != ""{
                let text = textField!.text
                textField!.text = ""
                textField!.frame = CGRectMake(0, view.frame.height/2, view.frame.width, 30)
                let textImage = textToImage(text!)
                let textImageView = TextImageView(frame: CGRectMake(textWriteLocation!.x - textImage.size.width/2, textWriteLocation!.y - textImage.size.height/2, textImage.size.width, textImage.size.height))
                textImageView.image = textImage
                textImageView.text = text
                view.addSubview(textImageView)
                textImageView.userInteractionEnabled = true
                let dragRec = UIPanGestureRecognizer()
                dragRec.maximumNumberOfTouches = 1
                dragRec.minimumNumberOfTouches = 1
                dragRec.addTarget(self, action: #selector(EditPhotoViewController.draggedText))
                textImageView.addGestureRecognizer(dragRec)
                let textTapRec = UITapGestureRecognizer()
                textTapRec.addTarget(self, action: #selector(EditPhotoViewController.tappedText))
                textImageView.addGestureRecognizer(textTapRec)
                let textPinchRec = UIPinchGestureRecognizer()
                textPinchRec.addTarget(self, action: #selector(EditPhotoViewController.pinchedText))
                textImageView.addGestureRecognizer(textPinchRec)
                let textRotateRec = UIRotationGestureRecognizer()
                textRotateRec.addTarget(self, action: #selector(EditPhotoViewController.rotatedText))
                textImageView.addGestureRecognizer(textRotateRec)
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
        let width = (NSAttributedString(string: drawText as String, attributes: attrs).widthWithConstrainedHeight(50))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: 50), false, 0)
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
        //add transition
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
