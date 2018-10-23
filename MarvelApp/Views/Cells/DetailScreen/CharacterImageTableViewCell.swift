//
//  CharacterImageTableViewCell.swift
//  MarvelApp
//
//  Created by Günter Hertz on 22/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit

class CharacterImageTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(thumbnail: Thumbnail){
        let url = thumbnail.fullPath(variant: .landscape_medium)
        self.imageView?.getImageFromURL(url: url)
    }
    
}
