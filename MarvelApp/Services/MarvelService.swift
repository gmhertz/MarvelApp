//
//  MarvelService.swift
//  MarvelApp
//
//  Created by Günter Hertz on 19/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Alamofire
import CryptoSwift
import Foundation
import RxSwift

enum ErrorTypes: Error {
    case parseError, fetchError
}

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
    private var total: Int = 0
    private let fetchAmount: Int = 20
    private(set) var isFetchAvailable = false
    
    func requestCharacters(completion: @escaping (Error?, [MarvelCharacter]?)-> Void) {
        if let url = URL(string: endPoint + FetchType.characters.rawValue + generateBaseKeys()) {
            
            let param = ["offset": self.offset]
            
            Alamofire.request(url, method : .get, parameters: param).validate().responseJSON { response in
                switch response.result {
                case .success(let value):

                    guard let json = value as? [String: Any],
                        let data = json["data"] as? [String: Any],
                        let results = data["results"] as? [Any], let total = data["total"] as? Int else {
                            completion(ErrorTypes.parseError, nil)
                        return
                        
                    }
                    self.total = total
                        if let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted){
                            if let persons = try? JSONDecoder.init().decode([MarvelCharacter].self, from: newData) {
                                self.offset += self.fetchAmount
                                self.isFetchAvailable = self.offset < self.total
                                completion(nil,persons)
                            }
                        }
                        completion(ErrorTypes.parseError, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(error, nil)
                }
            }
        }
    }
    
}
// MARK: Marvel Authentication
extension MarvelService {
    //Those parameters are used to authenticate the request
    func generateBaseKeys() -> String {
        let timestamp = Date().ticks.description
        let data = timestamp + privateKey + publicKey
        let hashValue = data.md5()
        
        return "?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hashValue)"
    }
    
}
