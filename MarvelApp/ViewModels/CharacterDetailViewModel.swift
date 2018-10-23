//
//  CharacterDetailViewModel.swift
//  MarvelApp
//
//  Created by Günter Hertz on 20/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class CharacterDetailViewModel {
    private let disposeBag = DisposeBag()
    private var marvelCharacter = ReplaySubject<MarvelCharacter>.create(bufferSize: 1)
    
    //Attributes
    var comics = ReplaySubject<[ComicBook]>.create(bufferSize: 1)
    var image = ReplaySubject<Thumbnail>.create(bufferSize: 1)
    var description = ReplaySubject<String>.create(bufferSize: 1)
    var name = ReplaySubject<String>.create(bufferSize: 1)
    
    var data = BehaviorSubject<[MultipleSectionModel]>(value: [])

    init(with character: MarvelCharacter) {
        self.marvelCharacter.onNext(character)
        
        marvelCharacter
            .map { $0.comics ?? [] }
            .bind(to: comics)
            .disposed(by: disposeBag)
        
        marvelCharacter
            .map { $0.description ?? ""}
            .bind(to: description)
            .disposed(by: disposeBag)
        
        marvelCharacter
            .map { $0.thumbnail }
            .bind(to: image)
            .disposed(by: disposeBag)
        
        marvelCharacter
            .map { $0.name }
            .bind(to: name)
            .disposed(by: disposeBag)
        
        
        Observable.zip(description,image,comics)
            .subscribe(onNext: { chardDesc, image, comicList in
                let sections: [MultipleSectionModel] = [
                    .CharacterImageSection(title: "", items: [ .ThumbnailItem(thumbnail: image)]),
                    .CharacterDescriptionSection(title: "Description", items: [ .DescriptionItem(desc: chardDesc) ] ),
                    .CharacterComicsSection(title: "Comics Participations", items: comicList.map { .ComicItem(comic: $0) })
                ]
                self.data.onNext(sections)
            }).disposed(by: disposeBag)
    }
}



// MARK: RxDatasource representation
enum MultipleSectionModel {
    case CharacterImageSection(title: String, items: [SectionItem])
    case CharacterDescriptionSection(title: String, items: [SectionItem])
    case CharacterComicsSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case ThumbnailItem(thumbnail: Thumbnail)
    case DescriptionItem(desc: String)
    case ComicItem(comic: ComicBook)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items:[SectionItem] {
        switch self {
        case .CharacterComicsSection(title: _, items: let items):
            return items.map { $0 }
        case .CharacterDescriptionSection(title: _, items: let items):
            return items.map { $0 }
        case .CharacterImageSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .CharacterImageSection(title: title, items: _):
            self = .CharacterImageSection(title: title, items: items)
        case let .CharacterDescriptionSection(title: title, items: _):
            self = .CharacterDescriptionSection(title: title, items: items)
        case let .CharacterComicsSection(title: String, items: _):
            self = .CharacterComicsSection(title: String, items: items)
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .CharacterImageSection(title: let title, items: _):
            return title
        case .CharacterComicsSection(title: let title, items: _):
            return title
        case .CharacterDescriptionSection(title: let title, items: _):
            return title
        }
    }
}
