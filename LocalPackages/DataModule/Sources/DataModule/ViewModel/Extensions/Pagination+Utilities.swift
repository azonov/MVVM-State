//
//  Pagination+Utilities.swift
//  
//
//  Created by Andey on 21.06.2022.
//
import Common

extension Pagination {
    
    private enum Constants {
        static let batch = 15
    }
    
    init(page: Int) {
        self.page = page
        self.count = Constants.batch
    }
    
    static var firstPage = Pagination(page: 1)
    
    var nextPage: Pagination {
        Pagination(page: self.page + 1, count: self.count)
    }
}
