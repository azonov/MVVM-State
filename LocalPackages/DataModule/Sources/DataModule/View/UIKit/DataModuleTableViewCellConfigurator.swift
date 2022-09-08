//
//  DataModuleTableViewCellConfigurator.swift
//  
//
//  Created by s.s.petrov on 22.06.2022.
//

import UIKit


struct DataModuleTableViewCellConfigurator {
    
    func cell(
        with tableView: UITableView,
        indexPath: IndexPath,
        itemIdentifier: AnyHashable
    ) -> UITableViewCell {
        switch itemIdentifier {
        case let itemIdentifier as TitleItem:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: type(of: UITableViewCell.self)),
                for: indexPath
            )
            cell.selectionStyle = .none
            cell.textLabel?.text = itemIdentifier.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .left
            return cell

        case is LoadingItem:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: type(of: UITableViewCell.self)),
                for: indexPath
            )
            cell.selectionStyle = .none
            cell.textLabel?.text = "Loading... ⌛⌛⌛"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            return cell

        case let item as LoadingErrorContentItem:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: type(of: UITableViewCell.self)),
                for: indexPath
            )
            cell.selectionStyle = .none
            cell.textLabel?.text = item.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            return cell

        case let item as LoadingErrorEmptyItem:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: type(of: UITableViewCell.self)),
                for: indexPath
            )
            cell.selectionStyle = .none
            cell.textLabel?.text = item.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            return cell

        case let item as EmptyItem:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: type(of: UITableViewCell.self)),
                for: indexPath
            )
            cell.selectionStyle = .none
            cell.textLabel?.text = item.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            return cell

        default:
            fatalError("Unexpected state")
        }
    }
}
