//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Sascha Stanic on 11.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    let imagesPerRow = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set dimension of collection items
        // need to divide by 5 to get 4 items on the screen in portrait orientation
        let space: CGFloat = 2.0
        
        // (simple) check for orientation to set the correct size
        var dimension: CGFloat!
        if (view.frame.size.width < view.frame.size.height) {
            dimension = (view.frame.size.width - (2 * space)) / 5.0
        }
        else {
            dimension = (view.frame.size.height - (2 * space)) / 5.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMemes()
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let newMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        self.presentViewController(newMemeViewController, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let meme = memes[indexPath.item]
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    func loadMemes() {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }
}