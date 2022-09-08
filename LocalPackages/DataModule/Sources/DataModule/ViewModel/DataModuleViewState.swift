//
//  DataModuleContentViewState.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//


// No imports of Foundation/Combine/SwiftUI/UIKit etc


struct DataModuleViewState: Equatable {
    var query: String
    var content: DataModuleContentViewState
}

enum DataModuleContentViewState: Equatable {
    
    struct DisplayData: Equatable {
        enum LoadMore: Equatable {
            case available(Pagination)
            case failed(Pagination)
            case unavailable
        }
        
        var isRefreshing: Bool = false
        var isAlertPresenting: Bool = false
        let titles: [String]
        var loadMore: LoadMore
    }
    case loading(Pagination)
    case loaded(DisplayData)
    case error(String)
}

enum DataModuleViewIntent {
    case onLoad
    case onLoadMore
    case onRefresh
    case onRetry
    case onAlertPresented(Bool)
    case onSearch(String)
}
