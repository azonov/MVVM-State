//
//  DataSwiftUIFactory.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 07.06.2022.
//

import Common
import SwiftUI

public struct DataSwiftUIFactory: Factory {
    
    private let dependencies: DataModuleDependencies
    
    public init(dependencies: DataModuleDependencies) {
        self.dependencies = dependencies
    }
    
    public func build(with context: DataModuleContext) throws -> some View {
        let viewModel = DataModuleViewModel(dataLoader: dependencies.loader)
        return DataModuleView(viewModel: viewModel)
    }
}
