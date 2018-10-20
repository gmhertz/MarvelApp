//
//  Thumbnail.swift
//  MarvelApp
//
//  Created by Günter Hertz on 19/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Foundation

enum ImageVariant: String {
    case portrait_small, portrait_medium, portrait_xlarge, portrait_fantastic, portrait_uncanny, portrait_incredible
    case standard_small, standard_medium, standard_large, standard_xlarge, standard_fantastic, standard_amazing
    case landscape_small, landscape_medium, landscape_large, landscape_xlarge, landscape_amazing, landscape_incredible
}


struct Thumbnail: Decodable {
    let path: String
    let ext: String
    
    func fullPath(variant: ImageVariant)-> String {
        return path + variant.rawValue + ext
    }
}
