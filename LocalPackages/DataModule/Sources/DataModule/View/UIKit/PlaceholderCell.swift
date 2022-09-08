//
//  PlaceholderCell.swift
//  MVVMExample (iOS)
//
//  Created by s.s.petrov on 08.06.2022.
//

import UIKit


final class PlaceholderCell: UITableViewCell {
    
    // MARK: Internal Structures
    
    enum State: Equatable {
        case loading
        case error(String)
    }
    
    // MARK: Private Properties
    
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    private lazy var titleLabel: UILabel = UILabel()
    
    // MARK: Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configure(_ state: State) {
        refreshControl.isHidden = state != .loading
        titleLabel.isHidden = state == .loading
        switch state {
        case .loading:
            refreshControl.beginRefreshing()
        case let .error(text):
            titleLabel.text = text
        }
    }
    
    // MARK: Private
    
    private func setupConstraints() {
        contentView.addSubview(refreshControl)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        refreshControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
