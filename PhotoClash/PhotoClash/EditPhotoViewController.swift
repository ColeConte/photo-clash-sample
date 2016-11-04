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
    @IBOutlet weak var colorSlider: UISlider!
    @IBAction func backButtonPress() {
        dismiss(animated: false, completion: nil)
    }
    var color: UIColor = UIColor.white
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

    @IBAction func colorSliderValueChanged(_ sender: AnyObject) {
        let value = colorSlider.value
        if value < 1 && value > 0{
            color = UIColor(hue: CGFloat(colorSlider.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        else if value < 0{
            color = UIColor.black
        }
        else if value > 1{
            color = UIColor.white
        }
        if inTextField{
            textField?.textColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSlider.isHidden = true
        photo.image = photoToEdit
        guard let image = photo.image, let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return
        }
        coreImage = CIImage(cgImage: cgimg)
        swipeRightRec.direction = .right
        swipeRightRec.addTarget(self, action: #selector(EditPhotoViewController.swipedViewRight))
        swipeLeftRec.direction = .left
        swipeLeftRec.addTarget(self, action: #selector(EditPhotoViewController.swipedViewLeft))
        tapRec.addTarget(self, action: #selector(EditPhotoViewController.tappedImage))
        NotificationCenter.default.addObserver(self, selector: #selector(EditPhotoViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        photo.addGestureRecognizer(swipeRightRec)
        photo.addGestureRecognizer(swipeLeftRec)
        photo.addGestureRecognizer(tapRec)
        photo.isUserInteractionEnabled = true
        textField = UITextField(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 30))
        textField!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textField?.textColor = UIColor.white
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func pinchedText(_ sender: UIPinchGestureRecognizer){
        let imageView = sender.view as! TextImageView
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    func rotatedText(_ sender: UIRotationGestureRecognizer){
        let imageView = sender.view as! TextImageView
        imageView.transform = imageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    func draggedText(_ sender: UIPanGestureRecognizer){
        let imageView = sender.view as! TextImageView
        //let translation = sender.translationInView(imageView)
        //imageView.center = CGPointMake(imageView.location!.x + translation.x, imageView.location!.y + translation.y)
        //imageView.location = imageView.center
        imageView.transform = CGAffineTransform(translationX: sender.translation(in: imageView).x, y: sender.translation(in: imageView).y)
        //let finalLocation = imageView.locationInView(view)
        //imageView.center = finalLocation
        //imageView.frame = CGRectMake(finalLocation.x, finalLocation.y, imageView.frame.width, imageView.frame.height)
    }
    
    func tappedText(_ sender: UITapGestureRecognizer){
        if inPreviousText{
            view.addSubview(previousTextTapped!)
            inPreviousText = false
        }
        let imageView = sender.view as! TextImageView
        previousTextTapped = imageView
        colorSlider.isHidden = false
        inPreviousText = true
        textWriteLocation = CGPoint(x: imageView.frame.minX, y: imageView.frame.minY)
        imageView.removeFromSuperview()
        //how to delete?
        inTextField = true
        textField!.text = imageView.text
        self.view.addSubview(textField!)
        textField?.becomeFirstResponder()
        textField?.textColor = color
    }
    
    func tappedImage(){
        if inTextField{
            textField!.resignFirstResponder()
            colorSlider.isHidden = true
            inPreviousText = false
            if textField!.text != ""{
                let text = textField!.text
                textField!.text = ""
                textField!.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: 30)
                let textImage = textToImage(text! as NSString)
                let textImageView = TextImageView(frame: CGRect(x: textWriteLocation!.x - textImage.size.width/2, y: textWriteLocation!.y - textImage.size.height/2, width: textImage.size.width, height: textImage.size.height))
                textImageView.image = textImage
                textImageView.text = text
                view.addSubview(textImageView)
                textImageView.isUserInteractionEnabled = true
                textImageView.location = textImageView.center
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
                view.bringSubview(toFront: textImageView)
            }
            textField!.removeFromSuperview()
            view.endEditing(true)
            inTextField = false

        }
        else{
            textWriteLocation = tapRec.location(in: view)
            inTextField = true
            colorSlider.isHidden = false
            self.view.addSubview(textField!)
            textField!.becomeFirstResponder()

        }
    }
    
    func textToImage(_ drawText: NSString)->UIImage{
        let paragraphStyle = NSMutableParagraphStyle()
        let attrs = [NSFontAttributeName: UIFont(name: "Helvetica Bold", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: color]
        let width = (NSAttributedString(string: drawText as String, attributes: attrs).widthWithConstrainedHeight(50))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: 50), false, 0)
        let point = CGPoint(x: 0, y: 0)
        drawText.draw(at: point, withAttributes: attrs)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
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
            let openGLContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: openGLContext!)
            if let output = filters[curFilter]!.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(output, from: output.extent)
                let result = UIImage(cgImage: cgimgresult!)
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
            let openGLContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: openGLContext!)
            if let output = filters[curFilter]!.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(output, from: output.extent)
                let result = UIImage(cgImage: cgimgresult!)
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
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            textField!.frame = CGRect(x: 0, y: view.frame.maxY - keyboardSize.height - 30, width: view.frame.width, height: 30)
        }
        
    }

    
    
}

extension NSAttributedString{
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat{
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}
