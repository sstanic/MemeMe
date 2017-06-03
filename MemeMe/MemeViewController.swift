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
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden=true;
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    // pick, cancel, share, fonts actions
    @IBAction func pickAnImage(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self

        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        imagePickedFromCamera = true

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera

        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func cancelMeme(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        moveKeyboard = false
        
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: imageView.image!, memedImage: createMemedImage())

        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: [])
        
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if let newError = error {
                self.showAlert("Ooops an error occured: \(newError)")
            }
            else {
                if (success) {
                    self.dismiss(animated: true, completion: nil)
                    
                    // make this optional later (save original/meme/both/none)
                    if (self.imagePickedFromCamera) {
                        self.saveImage(meme.originalImage)
                    }
                    
                    if (activity != UIActivityType.saveToCameraRoll) {
                        self.saveImage(meme.memedImage)
                    }
                    
                    self.saveMeme(meme)
                    self.meme = nil
                    self.initializeStartValues()
                }
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }

    @IBAction func changeFont(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Fonts", message: "Choose font", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            // cancel (nothing happens)
        }
        alertController.addAction(cancelAction)

        let impactFontAction: UIAlertAction = UIAlertAction(title: "Impact", style: .default) { action -> Void in
            self.font = UIFont(name: "Impact", size: 40)!
            self.initializeTextfields()
        }
        alertController.addAction(impactFontAction)

        let markerFeltWideAction: UIAlertAction = UIAlertAction(title: "Marker Felt Wide", style: .default) { action -> Void in
            self.font = UIFont(name: "MarkerFelt-Wide", size: 40)!
            self.initializeTextfields()
        }
        alertController.addAction(markerFeltWideAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // initialization
    func initializeStartValues() {
        // edit mode for already sent meme
        if meme != nil {
            topText.text = meme.top
            bottomText.text = meme.bottom
            imageView.image = meme.originalImage
            shareButton.isEnabled = true
        }
        else { // new meme
            imageView.image = nil
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            shareButton.isEnabled = false
        }

        cancelButton.isEnabled = true // always enabled
        imagePickedFromCamera = false
        scrollView.zoomScale = 1.0
        
        initializeTextfields()
    }
    
    func initializeTextfields() {
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : font,
            NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
        
        topText.defaultTextAttributes = textAttributes
        bottomText.defaultTextAttributes = textAttributes
        
        topText.textAlignment = NSTextAlignment.center
        bottomText.textAlignment = NSTextAlignment.center
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // if text is edited and iphone is rotated, <keyboardWillShow> is called twice. Check for y=0.0 before moving view.
        if (moveKeyboard && self.view.frame.origin.y == 0.0) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // the behavior of iPhone6 and iPhone6s (at least in the simulator) is different. Check for y<0.0 before moving view.
        if (moveKeyboard && self.view.frame.origin.y < 0.0) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // memes
    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func saveMeme(_ meme: Meme) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func createMemedImage() -> UIImage {
        
        // hide toolbar and navbar
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }

    // user alert
    func showAlert(_ alertMessage: String) {
        let alertController = UIAlertController(title: "Info", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}

