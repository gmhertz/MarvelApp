//
//  CharacterTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 20/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel! {
        didSet {
            characterName.textColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.softBlue
    }

    func setup(name: String, thumbnail: Thumbnail) {
        self.characterName.text = name
        self.characterImage.getImageFromURL(url: thumbnail.fullPath(variant: .portrait_incredible))
    }
}
