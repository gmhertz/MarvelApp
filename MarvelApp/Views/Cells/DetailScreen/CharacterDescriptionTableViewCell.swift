//
//  CharacterDescriptionTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 22/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class CharacterDescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(description: String){
        descriptionTextView.text = description
    }
}
