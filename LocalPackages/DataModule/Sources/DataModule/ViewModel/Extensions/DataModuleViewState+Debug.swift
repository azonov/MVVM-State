//
//  DataModuleContentViewState+Debug.swift
//  
//
//  Created by Andey on 21.06.2022.
//

extension DataModuleContentViewState: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .loading(let pagination):
            return ".loading(page:\(pagination.page))"
            
        case .loaded(let displayData):
            var page: String {
                switch displayData.loadMore {
                case .unavailable:
                    return "Unavailable"
                case .available(let page):
                    return "Available(page:\(page.page))"
                case .failed(let page):
                    return "Failed(page:\(page.page))"
                }
            }
            return ".loaded(.loadMore\(page))"
            
        case .error:
            return ".error"
        }
    }
}
