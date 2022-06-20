//
//  ViewController.swift
//  FlatMapProject
//
//  Created by 노건호 on 2022/06/20.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색하고 싶은 값을 입력하세요"
        return searchBar
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let viewModel = ViewModel.shared
    let disposeBag = DisposeBag()
}

// MARK: View Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayout()
        bind()
    }
}

// MARK: View
extension ViewController {
    func setLayout() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension ViewController {
    func bind() {
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.result
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { (indexPath, cellViewModel, cell) in
                if #available(iOS 14.0, *) {
                    var config = cell.defaultContentConfiguration()
                    config.text = cellViewModel.fullName
                    
                    cell.contentConfiguration = config
                } else {
                    cell.textLabel?.text = cellViewModel.fullName
                }
            }
            .disposed(by: disposeBag)
    }
}
