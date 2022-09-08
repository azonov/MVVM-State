//
//  GithubRepoLoader.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 07.06.2022.
//

import Combine
import Common
import Foundation

struct GithubAPI: DataLoading {
    
    private let cacheSubject = CurrentValueSubject<ModuleData?, Never>(nil)
    private let errorGenerator: ErrorGenerator

    init(successRate: SuccessRate) {
        errorGenerator = ErrorGenerator(successRate: successRate)
    }
    
    func refreshData(pagination: Pagination, query: String) -> AnyPublisher<Void, Error> {
        Log.info("APICall | page \(pagination.page) query \(query)")
        guard !errorGenerator.isError else {
            return Future { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    promise(.failure(CoreError.unexpectedCase))
                }
            }.eraseToAnyPublisher()
        }
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&sort=stars&per_page=\(pagination.count)&page=\(pagination.page)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap {
                let items = try JSONDecoder().decode(GithubSearchResult<Repository>.self, from: $0.data).items
                let moduleData = ModuleData(items: items.map({ ModuleItem(name: "id: \($0.id), \nname: \($0.name)") }))
                if let items = cacheSubject.value?.items, pagination.page != 1 {
                    self.cacheSubject.send(ModuleData(items: items + moduleData.items))
                } else {
                    self.cacheSubject.send(moduleData)
                }
                return Void()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func subscribeForData() -> AnyPublisher<ModuleData, Never> {
        cacheSubject
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct GithubSearchResult<T: Codable>: Codable {
    let items: [T]
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
}
