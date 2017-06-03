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
    
    func setText(_ top: String, bottom: String) {
        let mintopIndex = min(top.characters.count, maxChars)
        let minbottomIndex = min(bottom.characters.count, maxChars)
        
        memeText.text = top.substring(to: top.characters.index(top.startIndex, offsetBy: mintopIndex)) + "...." + bottom.substring(from: bottom.characters.index(bottom.endIndex, offsetBy: -minbottomIndex))
    }
}
