//
//  UIImageViewExtension.swift
//  MarvelApp
//
//  Created by Günter Hertz on 21/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func getImageFromURL(url: String) {
        if let url = URL(string: url) {
            self.kf.setImage(with: ImageResource(downloadURL: url))
        }
    }
}
