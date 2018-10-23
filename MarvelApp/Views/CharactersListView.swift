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
            
            charactersTableView.register(UINib(nibName: "MarvelCharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "marvelCharacterCell")
//            charactersTableView.register(MarvelCharacterTableViewCell.self, forCellReuseIdentifier: "marvelCharacterCell")
        }
    }
    
    // MARK:
    var viewModel: CharactersListViewModel = CharactersListViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    var characterDetails = PublishSubject<MarvelCharacter>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Characters List"
        self.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCharacterDataInfo>(configureCell: { (_, charactersTableView, indexPath, item) -> UITableViewCell in
            if let cell = charactersTableView.dequeueReusableCell(withIdentifier: "marvelCharacterCell", for: indexPath) as? MarvelCharacterTableViewCell {
                cell.setup(with: item.name, thumbnail: item.image)
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

        viewModel.characterToDetail
            .subscribe(onNext: { character in
                let detailViewModel = CharacterDetailViewModel(with: character)
                let characterDetailVC = CharacterDetailView.with(detailViewModel)
                self.navigationController?.pushViewController(characterDetailVC, animated: true)
            }).disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { msg in
                let fetchErrorAlert: UIAlertController = UIAlertController(title: "Ooops", message: msg, preferredStyle: .alert)
                self.present(fetchErrorAlert, animated: true, completion: nil)
                
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.viewModel.loadMoreData()
                })
                
                fetchErrorAlert.addAction(retryAction)
            })
            .disposed(by: disposeBag)
    }
    
    
    func configure() {
        navigationItem.largeTitleDisplayMode = .always
    }
}

extension CharactersListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
