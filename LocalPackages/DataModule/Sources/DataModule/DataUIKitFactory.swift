//
//  ModuleFactory.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

import Common
import UIKit

public struct DataUIKitFactory: Factory {
    
    private let dependencies: DataModuleDependencies
    
    public init(dependencies: DataModuleDependencies) {
        self.dependencies = dependencies
    }
    
    public func build(with context: DataModuleContext) throws -> UIViewController {
        let viewModel = DataModuleViewModel(dataLoader: dependencies.loader)
        return DataModuleViewController(viewModel: viewModel)
    }
}
