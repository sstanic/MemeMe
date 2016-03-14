//
//  ViewController.swift
//  MemeMe
//
//  Created by Sascha Stanic on 01.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    // remark: Udacity launch image is used only for design, could be removed
    
    // outlets
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var meme: Meme!
    
    // only bottom textfield will move keyboard up
    var moveKeyboard = false
    
    // selectable font, <Impact> is standard font
    var font = UIFont(name: "Impact", size: 40)!
    
    // image source
    var imagePickedFromCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init textfield delegates
        topText.delegate = self
        bottomText.delegate = self
        
        // scroll view
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        
        self.initializeStartValues()
        
        // check for camera availability
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden=true;
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    // pick, cancel, share, fonts actions
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self

        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        imagePickedFromCamera = true

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera

        presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func cancelMeme(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        moveKeyboard = false
        
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: imageView.image!, memedImage: createMemedImage())

        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: [])
        
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.dismissViewControllerAnimated(true, completion: nil)
            
            if let newError = error {
                self.showAlert("Ooops an error occured: \(newError)")
            }
            else {
                if (success) {
                    // make this optional later (save original/meme/both/none)
                    
                    if (self.imagePickedFromCamera) {
                        self.saveImage(meme.originalImage)
                    }
                    
                    if (activity != UIActivityTypeSaveToCameraRoll) {
                        self.saveImage(meme.memedImage)
                    }
                    
                    self.saveMeme(meme)
                    self.meme = nil
                    self.initializeStartValues()
                }
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }

    @IBAction func changeFont(sender: AnyObject) {
        let alertController = UIAlertController(title: "Fonts", message: "Choose font", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            // cancel (nothing happens)
        }
        alertController.addAction(cancelAction)

        let impactFontAction: UIAlertAction = UIAlertAction(title: "Impact", style: .Default) { action -> Void in
            self.font = UIFont(name: "Impact", size: 40)!
            self.initializeTextfields()
        }
        alertController.addAction(impactFontAction)

        let markerFeltWideAction: UIAlertAction = UIAlertAction(title: "Marker Felt Wide", style: .Default) { action -> Void in
            self.font = UIFont(name: "MarkerFelt-Wide", size: 40)!
            self.initializeTextfields()
        }
        alertController.addAction(markerFeltWideAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // initialization
    func initializeStartValues() {
        // edit mode for already sent meme
        if meme != nil {
            topText.text = meme.top
            bottomText.text = meme.bottom
            imageView.image = meme.originalImage
            shareButton.enabled = true
        }
        else { // new meme
            imageView.image = nil
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            shareButton.enabled = false
        }

        cancelButton.enabled = true // always enabled
        imagePickedFromCamera = false
        scrollView.zoomScale = 1.0
        
        initializeTextfields()
    }
    
    func initializeTextfields() {
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : font,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topText.defaultTextAttributes = textAttributes
        bottomText.defaultTextAttributes = textAttributes
        
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // for some reason the textfield loses the black outline if no text is added. Need to re-init the attributes.
        initializeTextfields()
        
        if (textField == bottomText) {
            moveKeyboard = true
        }
        else {
            moveKeyboard = false
        }
    }
    
    // gesture
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // if text is edited and iphone is rotated, <keyboardWillShow> is called twice. Check for y=0.0 before moving view.
        if (moveKeyboard && self.view.frame.origin.y == 0.0) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // the behavior of iPhone6 and iPhone6s (at least in the simulator) is different. Check for y<0.0 before moving view.
        if (moveKeyboard && self.view.frame.origin.y < 0.0) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // memes
    func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func saveMeme(meme: Meme) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func createMemedImage() -> UIImage {
        
        // hide toolbar and navbar
        navigationBar.hidden = true
        toolBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

    // user alert
    func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Info", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
        }
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

