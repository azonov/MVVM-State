//
//  MVVMExampleApp.swift
//  MVVMExample
//
//  Created by Andey on 06.06.2022.
//

import Combine
import Common
import DataModule
import SwiftUI

@main
struct MVVMExample: App {
    
    @State var presentingUIKit = false
    @State var presentingSwiftUI = false
    
    private var dependencies: DataModuleDependencies {
        DataModuleDependencies.githubAPI(successRate: .failHalf)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Button("SwiftUI") { self.presentingSwiftUI.toggle() }
                        .sheet(isPresented: $presentingSwiftUI) {
                            try! DataSwiftUIFactory(dependencies: dependencies).build(with: .init())
                        }
                    Button("UIKit") { self.presentingUIKit.toggle() }
                        .sheet(isPresented: $presentingUIKit) {
                            try! DataVCFactory(dependencies: dependencies).build(with: .init())
                        }
                }
            }
        }
    }
}
