//
//  DataModuleViewController.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

import Combine
import Common
import UIKit
import SwiftUI

class DataModuleViewController<ViewModel: DataViewModeling>: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    enum Section: Int {
        case contents
        case errors
        case loaders
    }

    // Private Properties
    
    @ObservedObject
    private var viewModel: ViewModel
    private var cellConfigurator = DataModuleTableViewCellConfigurator()
    private var bag = Set<AnyCancellable>()
    
    private lazy var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, AnyHashable>!
    private lazy var refreshControl = UIRefreshControl()
    private lazy var searchBar = UISearchBar()

    // MARK: Lifecycle
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureIO()
        viewModel.trigger(.onLoad)
    }
    
    // MARK: Private
    
    private func setupUI() {
        title = "UIKit"
        setupTableView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onRefreshControl), for: .valueChanged)
        setupSearchBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: String(describing: type(of: UITableViewCell.self))
        )
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource<Int, AnyHashable>(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            self.cellConfigurator.cell(with: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
    }
    
    @objc
    private func onRefreshControl() {
        viewModel.trigger(.onRefresh)
    }
    
    private func configureIO() {
        viewModel
            .objectWillChange
            .throttle(for: 0, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: weak(self, DataModuleViewController.render))
            .store(in: &bag)
    }
    
    private func render() {
        let state = viewModel.state
        refreshControl.endRefreshing()
        showAlertIfNeeded(state)
        searchBar.text = state.query
        var snapshot = makeBlankSnapshot()
        switch state.content {
        case .loading:
            snapshot.appendItems([LoadingItem()], toSection: Section.loaders.rawValue)
        case let .error(error):
            snapshot.appendItems([LoadingErrorContentItem(title: error)], toSection: Section.errors.rawValue)
        case let .loaded(data):
            let cellData = cellItemData(from: data)
            snapshot.appendItems(cellData, toSection: Section.contents.rawValue)
            switch data.loadMore {
            case .available:
                snapshot.appendItems([LoadingItem()], toSection: Section.loaders.rawValue)
            case .failed:
                snapshot.appendItems([LoadingErrorEmptyItem(title: "Refresh")], toSection: Section.errors.rawValue)
            case .unavailable:
                break
            }
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showAlertIfNeeded(_ state: DataModuleViewState) {
        if case let .loaded(data) = state.content, data.isAlertPresenting {
            let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    private func makeBlankSnapshot() -> NSDiffableDataSourceSnapshot<Int, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()

        snapshot.appendSections([Section.contents.rawValue])
        snapshot.appendSections([Section.errors.rawValue])
        snapshot.appendSections([Section.loaders.rawValue])

        return snapshot
    }

    private func cellItemData(from displayData: DataModuleContentViewState.DisplayData) -> [TitleItem] {
        return displayData.titles.enumerated().map { idx, data -> TitleItem in
            return TitleItem(title: "\(data) + \(idx)")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = DataModuleViewController.Section(rawValue: indexPath.section)
        guard case .loaders = section else {
            return
        }

        viewModel.trigger(.onLoadMore)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch itemIdentifier {
        case is LoadingErrorEmptyItem:
            viewModel.trigger(.onRetry)
        default:
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.trigger(.onSearch(searchText))
    }
}
