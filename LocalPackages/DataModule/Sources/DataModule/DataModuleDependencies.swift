//
//  DataModuleDependencies.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 07.06.2022.
//

public struct DataModuleContext {
    public init() {}
}

public struct DataModuleDependencies {
    let loader: DataLoading
}

extension DataModuleDependencies {
    
    public static func githubAPI(successRate: SuccessRate) -> DataModuleDependencies {
        DataModuleDependencies(loader: GithubAPI(successRate: successRate))
    }
}
