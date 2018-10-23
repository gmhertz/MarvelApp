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
    private var service = MarvelService()
    private var characters = [MarvelCharacter]()
    
    // MARK: output
    var data = BehaviorSubject<[SectionOfCharacterDataInfo]>(value: [])
    var selectedCharacter = PublishSubject<IndexPath>()
    var shouldLoadMoreCharacters = PublishSubject<Bool>()
    var characterToDetail = PublishSubject<MarvelCharacter>()
    
    init() {
        self.loadMoreData()
        
        shouldLoadMoreCharacters
            .distinctUntilChanged()
            .bind { _ in self.loadMoreData() }
            .disposed(by: disposeBag)
        
        selectedCharacter
            .map { self.characters[$0.row] }
            .bind(to: self.characterToDetail)
            .disposed(by: disposeBag)
    }
    
    func loadMoreData() {
        service.requestCharacters { err, completion in
            if err != nil {
                //error fetch
                //show to interface in some way
            } else {
                if let newCharacters = completion {
                    self.characters.append(contentsOf: newCharacters)
                    let newSections = [SectionOfCharacterDataInfo(items: self.characters.map { CharacterData(name: $0.name,
                                                                                                             image:$0.thumbnail,
                                                                                                             id: $0.id)})]
                    self.data.onNext(newSections)
                }
            }
        }
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
    let id: Int

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
