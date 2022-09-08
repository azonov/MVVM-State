//
//  Weakify.swift
//  MVVMExample (iOS)
//
//  Created by Andey on 06.06.2022.
//

public func weak<T: AnyObject>(_ obj: T, _ block: @escaping (T) -> () -> Void) -> () -> Void {
    return { [weak obj] in
        obj.map(block)?()
    }
}

public func weak<T: AnyObject, Argument>(_ obj: T, _ block: @escaping (T) -> (Argument) -> Void) -> (Argument) -> Void {
    return { [weak obj] a in
        obj.map(block)?(a)
    }
}
