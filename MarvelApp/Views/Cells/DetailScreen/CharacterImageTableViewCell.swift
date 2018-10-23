//
//  CharacterImageTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 22/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class CharacterImageTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView! {
        didSet {
            characterImage.clipsToBounds = true
            characterImage.layer.borderWidth = 3.0
            characterImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(thumbnail: Thumbnail){
        let url = thumbnail.fullPath(variant: .landscape_large)
        self.characterImage?.getImageFromURL(url: url)
    }
    
}
