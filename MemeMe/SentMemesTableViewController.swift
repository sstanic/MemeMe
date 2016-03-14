//
//  SentMemesListViewController.swift
//  MemeMe
//
//  Created by Sascha Stanic on 11.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMemes()
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let memeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        presentViewController(memeViewController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let meme = memes[indexPath.item]
        
        cell.setText(meme.top, bottom: meme.bottom)
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            
            // remove meme from meme-array
            memes.removeAtIndex(indexPath.row)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            
            // remove row from table view
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            loadMemes()
        }
    }
    
    func loadMemes() {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }
}
