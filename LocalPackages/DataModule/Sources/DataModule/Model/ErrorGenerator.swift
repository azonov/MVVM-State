//
//  File.swift
//  
//
//  Created by Andey on 20.06.2022.
//

public enum SuccessRate: CaseIterable {
    case successful
    case failHalf
    case failThird
    case failQuarter
}

final class ErrorGenerator {
    
    var successRate: SuccessRate
    private var counter = 1
    
    init(successRate: SuccessRate) {
        self.successRate = successRate
    }
    
    var isError: Bool {
        defer {
            counter += 1
        }
        switch successRate {
        case .successful:
            return false
        case .failHalf:
            return (counter % 2) == 0
        case .failThird:
            return (counter % 3) == 0
        case .failQuarter:
            return (counter % 4) == 0
        }
    }
}
