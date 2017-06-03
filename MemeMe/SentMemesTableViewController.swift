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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMemes()
    }
    
    @IBAction func addMeme(_ sender: AnyObject) {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTableViewCell
        
        let meme = memes[indexPath.item]
        
        cell.setText(meme.top, bottom: meme.bottom)
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            // remove meme from meme-array
            memes.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            
            // remove row from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            loadMemes()
        }
    }
    
    func loadMemes() {
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        tableView.reloadData()
    }
}
