//
//  LoadingService.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

import Combine

public struct ModuleData {
    let items: [ModuleItem]
}

public struct ModuleItem {
    let name: String
}

public struct Pagination: Equatable {
    let page: Int
    let count: Int
}

public protocol DataLoading {
    
    func refreshData(pagination: Pagination, query: String) -> AnyPublisher<Void, Error>
    func subscribeForData() -> AnyPublisher<ModuleData, Never>
}
