//
//  Models.swift
//  MVVMExample (iOS)
//
//  Created by s.s.petrov on 17.06.2022.
//

import Foundation

struct TitleItem: Hashable {
    let title: String
}

struct EmptyItem: Hashable {
    let title: String
}

struct LoadingErrorEmptyItem: Hashable {
    let title: String
}

struct LoadingItem: Hashable {
    private let id = "LoadingItem"
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct LoadingErrorContentItem: Hashable {
    private let id = UUID()
    let title: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
