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
        // need to divide by n+1 to get n items on the screen in portrait orientation
        let space: CGFloat = 2.0
        let nrOfItems: CGFloat = 5.0
        
        // (simple) check for orientation to set the correct size
        var dimension: CGFloat!
        if (view.frame.size.width < view.frame.size.height) {
            dimension = (view.frame.size.width - (2 * space)) / nrOfItems
        }
        else {
            dimension = (view.frame.size.height - (2 * space)) / nrOfItems
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMemes()
    }
    
    @IBAction func addMeme(_ sender: AnyObject) {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        let meme = memes[indexPath.item]
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    func loadMemes() {
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }
}
