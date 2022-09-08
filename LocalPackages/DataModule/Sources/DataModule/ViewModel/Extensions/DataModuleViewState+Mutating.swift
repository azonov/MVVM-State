//
//  DataModuleContentViewState+Mutating.swift
//  
//
//  Created by Andey on 21.06.2022.
//

import Common

extension DataModuleContentViewState {
    
    var pagination: Pagination {
        switch self {
        case .loading(let pagination):
            return pagination
            
        case .loaded(let data):
            switch data.loadMore {
            case .available(let pagination), .failed(let pagination):
                return pagination
                
            case .unavailable:
                assertionFailure(CoreError.unexpectedCase.localizedDescription)
                return .firstPage
            }
            
        case .error:
            return .firstPage
        }
    }
    
    func loadMore() -> DataModuleContentViewState {
        guard case .loaded(var displayData) = self,
              case .available(let pagination) = displayData.loadMore else
        {
            assertionFailure(CoreError.unexpectedCase.localizedDescription)
            return self
        }
        displayData.loadMore = .available(pagination)
        return .loaded(displayData)
    }
    
    func failedRefresh() -> DataModuleContentViewState {
        guard case .loaded(var displayData) = self else {
            assertionFailure(CoreError.unexpectedCase.localizedDescription)
            return self
        }
        if displayData.isRefreshing {
            displayData.isRefreshing = false
            displayData.isAlertPresenting = true
        } else {
            displayData.loadMore = .failed(pagination)
        }
        return .loaded(displayData)
    }
    
    func refresh() -> DataModuleContentViewState {
        if case .error = self {
            return self
        }
        
        guard case .loaded(var displayData) = self else {
            assertionFailure(CoreError.unexpectedCase.localizedDescription)
            return self
        }
        displayData.isRefreshing = true
        return .loaded(displayData)
    }
    
    func alert(isPresented: Bool) -> DataModuleContentViewState {
        guard case .loaded(var displayData) = self else {
            assertionFailure(CoreError.unexpectedCase.localizedDescription)
            return self
        }
        displayData.isAlertPresenting = isPresented
        return .loaded(displayData)
    }
}
