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
            let cell = UINib(nibName: "CharacterTableViewCell", bundle: nil)
            charactersTableView.register(cell, forCellReuseIdentifier: "characterCell")
        }
    }
    
//    private var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<MarvelCharacter>>()
    // MARK:
    var viewModel: CharactersListViewModel = CharactersListViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters List"
        
        _ = RxTableViewSectionedReloadDataSource<SectionOfCharacterDataInfo>(configureCell: { (_, charactersTableView, indexPath, item) -> UITableViewCell in
            // TO DO: CONFIGURE THE CELL AND REPLACE THIS CODE ABOVE
            let cell = UITableViewCell(style: .default, reuseIdentifier: "teste")
            cell.textLabel?.text = "agora vai"
            return cell
        })
        
        charactersTableView.rx.itemSelected.bind(to: viewModel.selectedCharacter).disposed(by: disposeBag)
        
        
        
    }
    
    
}

