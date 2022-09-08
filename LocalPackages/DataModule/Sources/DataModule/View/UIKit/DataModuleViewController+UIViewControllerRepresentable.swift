//
//  DataModuleViewController+UIViewControllerRepresentable.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 09.06.2022.
//

import Common
import UIKit
import SwiftUI

public struct DataModuleVC: UIViewControllerRepresentable {
    
    var viewModel: DataModuleViewModel
    
    public func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: DataModuleViewController(viewModel: viewModel))
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

public struct DataVCFactory: Factory {
    
    private let dependencies: DataModuleDependencies
    
    public init(dependencies: DataModuleDependencies) {
        self.dependencies = dependencies
    }
    
    public func build(with context: DataModuleContext) throws -> DataModuleVC {
        return DataModuleVC(viewModel: DataModuleViewModel(dataLoader: dependencies.loader))
    }
}
