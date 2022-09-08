//
//  Factory.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

public protocol Factory {
    associatedtype Result

    associatedtype Context

    func build(with context: Context) throws -> Result
}
