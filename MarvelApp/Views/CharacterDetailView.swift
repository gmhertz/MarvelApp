//
//  CharacterDetailView.swift
//  MarvelApp
//
//  Created by Günter Hertz on 20/10/18.
//  Copyright © 2018 Günter Hertz. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CharacterDetailView: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: CharacterDetailViewModel! = nil
        
    @IBOutlet weak var detailsTableView: UITableView! {
        didSet {
            detailsTableView.register(UINib(nibName: "CharacterComicsTableViewCell", bundle: nil), forCellReuseIdentifier: "characterComic")
            
            detailsTableView.register(UINib(nibName: "CharacterDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "characterDescriptionCell")
            
            detailsTableView.register(UINib(nibName: "CharacterImageTableViewCell", bundle: nil), forCellReuseIdentifier: "characterImageDetail")
        }
    }
    
    //function to create a character detail with a model
    static func with(_ viewModel: CharacterDetailViewModel) -> CharacterDetailView {
        let vc = CharacterDetailView()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        
        detailsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.name
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { (dataSource, detailsTableView, idxPath, _) in
                switch dataSource[idxPath] {
                case let .ThumbnailItem(image):
                    let cell: CharacterImageTableViewCell = detailsTableView.dequeueReusableCell(withIdentifier: "characterImageDetail", for: idxPath) as! CharacterImageTableViewCell
                    cell.setup(thumbnail: image)
                    return cell
                case let .DescriptionItem(desc):
                    let cell: CharacterDescriptionTableViewCell = detailsTableView.dequeueReusableCell(withIdentifier: "characterDescriptionCell", for: idxPath) as! CharacterDescriptionTableViewCell
                    cell.setup(description: desc)
                    
                    return cell
                case let .ComicItem(comics):
                    let cell: CharacterComicsTableViewCell = detailsTableView.dequeueReusableCell(withIdentifier: "characterComic", for: idxPath) as! CharacterComicsTableViewCell
                    cell.setup(comicName: comics.name ?? "Comic name unavailable")
                    
                    return cell
                }
        },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
        })
        
        
        viewModel.data.bind(to: detailsTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

    }
    

    func configure() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.title = ""
    }
}

extension CharacterDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 200
        case 2:
            return 60
        default:
            fatalError("This should not happen")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.darkBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
    }
}
