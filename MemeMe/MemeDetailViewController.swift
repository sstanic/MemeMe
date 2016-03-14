//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sascha Stanic on 11.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editMeme")
    }
    override func viewWillAppear(animated: Bool) {
        memeImage.image = meme.memedImage
    }
    
    func editMeme() {
        let newMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        newMemeViewController.meme = meme
        
        self.presentViewController(newMemeViewController, animated: true, completion: nil)
    }
}
