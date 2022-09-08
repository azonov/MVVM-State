//
//  DataLoadingStub.swift
//  
//
//  Created by Andey on 20.06.2022.
//

@testable import DataModule
import Combine

class DataLoadingStub: DataLoading {
    
    var refreshDataPromise: Future<Void, Error>.Promise?
    var subscribeForDataPromise: Future<ModuleData, Never>.Promise?
    var cancelledRequests: [Pagination] = []
    
    func refreshData(pagination: Pagination, query: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.refreshDataPromise = promise
        }
        .handleEvents(receiveCancel: { [weak self] in
            self?.cancelledRequests.append(pagination)
        })
        .eraseToAnyPublisher()
    }
    
    func subscribeForData() -> AnyPublisher<ModuleData, Never> {
        Future<ModuleData, Never> { promise in
            self.subscribeForDataPromise = promise
        }
        .eraseToAnyPublisher()
    }
}
