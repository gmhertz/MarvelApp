//
//  CharacterComicsTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 22/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class CharacterComicsTableViewCell: UITableViewCell {
    @IBOutlet weak var comicTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(comicName: String) {
        comicTitleLabel.text = comicName
    }
}
