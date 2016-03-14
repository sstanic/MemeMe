//
//  CustomMemeCell.swift
//  MemeMe
//
//  Created by Sascha Stanic on 11.03.16.
//  Copyright © 2016 Sascha Stanic. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeText: UITextField!
    
    let maxChars = 7
    
    func setText(top: String, bottom: String) {
        let mintopIndex = min(top.characters.count, maxChars)
        let minbottomIndex = min(bottom.characters.count, maxChars)
        
        memeText.text = top.substringToIndex(top.startIndex.advancedBy(mintopIndex)) + "...." + bottom.substringFromIndex(bottom.endIndex.advancedBy(-minbottomIndex))
    }
}
