//
//  MarvelCharacter.swift
//  MarvelApp
//
//  Created by Günter Hertz on 19/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Foundation

// MARK: Marvel Character
struct MarvelCharacter: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let comics: [ComicBook]?
    let thumbnail: Thumbnail?
}

extension MarvelCharacter {
    enum CodingKeys: CodingKey {
        case id, name, comics, description, thumbnail
    }
    enum ComicsCodingKeys: CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        
        let internContainer = try values.nestedContainer(keyedBy: ComicsCodingKeys.self, forKey: .comics)
        
        comics = try internContainer.decodeIfPresent([ComicBook].self, forKey: .items)
    }
}

// MARK: Thumbnail
enum ImageVariant: String {
    case portrait_small, portrait_medium, portrait_xlarge, portrait_fantastic, portrait_uncanny, portrait_incredible
    case standard_small, standard_medium, standard_large, standard_xlarge, standard_fantastic, standard_amazing
    case landscape_small, landscape_medium, landscape_large, landscape_xlarge, landscape_amazing, landscape_incredible
}

struct Thumbnail: Decodable {
    var path: String?
    var `extension`: String?
}

// MARK: Comic
struct ComicBook: Decodable {
    var resourceURI: String?
    var name: String?
}


