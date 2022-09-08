//
//  ViewModel.swift
//  Tests iOS
//
//  Created by Andey on 06.06.2022.
//

import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Intent

    var state: State { get }
    func trigger(_ intent: Intent)
}
