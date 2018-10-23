//
//  MarvelCharacterTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 22/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class MarvelCharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var characterImage: UIImageView! {
        didSet {
            characterImage.layer.cornerRadius = characterImage.frame.size.height/2
            characterImage.clipsToBounds = true
            characterImage.layer.borderWidth = 3.0
            characterImage.layer.borderColor = UIColor.marvelRed.cgColor
        }
    }
    @IBOutlet weak var characterName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 0.5
            self.detailView.alpha = 1.0
        }
    }
    
    func setup(with name: String, thumbnail: Thumbnail) {
        self.characterName.text = name
        let imageUrl = thumbnail.fullPath(variant: .landscape_medium)
        self.characterImage.getImageFromURL(url: imageUrl)
    }
    
}
