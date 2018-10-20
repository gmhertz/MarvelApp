//
//  MarvelCharacter.swift
//  MarvelApp
//
//  Created by Günter Hertz on 19/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Foundation

struct Item: Decodable {
    let resourceURI: String
    let name: String
}

struct MarvelCharacter: Decodable {
    let id: String
    let name: String
    let description: String
    let items: [Item]
    let thumbnail: [Thumbnail]
}
