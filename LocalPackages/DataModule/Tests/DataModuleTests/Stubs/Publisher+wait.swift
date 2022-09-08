//
//  Publisher+wait.swift
//  
//
//  Created by Andey on 20.06.2022.
//

import Combine
import Foundation
import XCTest

extension Publisher {
    func waitForCompletion(timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) throws -> [Output] {
        let expectation = XCTestExpectation(description: "wait for completion")
        var completion: Subscribers.Completion<Failure>?
        var output = [Output]()
        
        let subscription = self.collect()
            .sink(receiveCompletion: { receiveCompletion in
                completion = receiveCompletion
                expectation.fulfill()
            }, receiveValue: { value in
                output = value
            })
        
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        subscription.cancel()
        
        switch try XCTUnwrap(completion, "Publisher never completed", file: file, line: line) {
        case let .failure(error):
            throw error
        case .finished:
            return output
        }
    }
    
    func waitForFirstOutput(timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) throws -> Output {
        return try XCTUnwrap(prefix(1).waitForCompletion(file: file, line: line).first, "", file: file, line: line)
    }
}
