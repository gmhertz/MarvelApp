//
//  CharactersListView.swift
//  MarvelApp
//
//  Created by Günter Hertz on 20/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class CharactersListView: UIViewController {
    // MARK: Outlet definitions
    @IBOutlet weak private var charactersTableView: UITableView! {
        didSet {
            charactersTableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "characterCell")
        }
    }
    
    // MARK:
    var viewModel: CharactersListViewModel = CharactersListViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    var characterDetails = PublishSubject<MarvelCharacter>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters List"
        self.navigationController?.navigationBar.barStyle = .black
        
        charactersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCharacterDataInfo>(configureCell: { (_, charactersTableView, indexPath, item) -> UITableViewCell in
            if let cell = charactersTableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell {
                cell.setup(name: item.name, thumbnail: item.image)
                return cell
            } else {
                fatalError("ERROR ON CELL LOADING")
            }
        })
        
        viewModel.data
            .bind(to: charactersTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        charactersTableView.rx.itemSelected
            .bind(to: viewModel.selectedCharacter)
            .disposed(by: disposeBag)
        
        charactersTableView.rx.didScroll
            .map { [unowned self] _ in self.charactersTableView.isBouncingBottom }
            .bind(to: viewModel.shouldLoadMoreCharacters )
            .disposed(by: disposeBag)
        
        
    }
}

extension CharactersListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
