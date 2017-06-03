//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sascha Stanic on 11.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!

    var meme: Meme!
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(MemeDetailViewController.editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memeImage.image = meme.memedImage
    }
    
    func editMeme() {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        memeViewController.meme = meme
        
        present(memeViewController, animated: true, completion: nil)
    }
}
