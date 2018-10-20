//
//  CharactersListViewModel.swift
//  MarvelApp
//
//  Created by Günter Hertz on 20/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import RxDataSources
import Foundation
import RxSwift

class CharactersListViewModel {
    // MARK: private properties
    private let disposeBag = DisposeBag()
    private var service: MarvelService
    
    private let data = BehaviorSubject<[CharacterData]>(value: [])
    
    
    // MARK: output
    var selectedCharacter = PublishSubject<IndexPath>()
    var characters: Observable<[CharacterData]> {
        return data
    }

    init() {
        service = MarvelService()
    }
 
}


// MARK: RxDatasource representation
struct SectionOfCharacterDataInfo: Equatable {
    var items: [CharacterData]
    
    static func == (lhs: SectionOfCharacterDataInfo, rhs: SectionOfCharacterDataInfo) -> Bool {
        return lhs.items == rhs.items
    }
}

struct CharacterData: Equatable {
    let name: String
    let image: Thumbnail
    let id: String
    
    static func == (lhs: CharacterData, rhs: CharacterData) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}


extension SectionOfCharacterDataInfo: SectionModelType {
    
    typealias Item = CharacterData
    
    init(original: SectionOfCharacterDataInfo, items: [Item]) {
        self = original
        self.items = items
    }
}
