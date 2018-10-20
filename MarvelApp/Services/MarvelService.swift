//
//  MarvelService.swift
//  MarvelApp
//
//  Created by Günter Hertz on 19/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Alamofire
import Foundation
import CryptoSwift

enum FetchType: String {
    case characters = "v1/public/characters"
    case comics = "v1/public/characters/{characterId}/comics"
    
    func comicFetch(characterId: String) -> String {
        return "v1/public/characters/\(characterId)/comics"
    }
}

class MarvelService {
    // MARK: API Keys
    private let endPoint: String = "http://gateway.marvel.com/"
    
    private lazy var privateKey: String = {
        if let path = Bundle.main.path(forResource: "MarvelKeys", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path),
            let key = values["privateKey"] as? String {
            return key
        } else {
            return ""
        }
    }()
    
    private lazy var publicKey: String = {
        if let path = Bundle.main.path(forResource: "MarvelKeys", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path),
            let key = values["publicKey"] as? String {
            return key
        } else {
            return ""
        }
    }()
    
    // MARK: Control Variables
    private var offset: Int = 0
    private var fetchAmount: Int = 25
    
    
    func requestCharacters(using parameters: [String:Any]){
        //http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150
        let link = self.endPoint + FetchType.characters.rawValue + self.generateBaseKeys()
        
        print(link)
        Alamofire.request(link).responseJSON { response2 in
            print(response2)
        }
    }
    
}

// Marvel Authentication
extension MarvelService {
    
    func generateBaseKeys() -> String {
        let timestamp = Date().ticks
        print(timestamp)
        let data = timestamp.description + privateKey + publicKey
        let hashValue = data.md5()
        
        return "?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hashValue)"
    }
    
}
