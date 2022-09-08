//
//  Binding.swift
//  
//
//  Created by Andey on 21.06.2022.
//

import SwiftUI

extension Binding {
    
    public static var falseBinding: Binding<Bool> {
        Binding<Bool>(get: { false }, set: { _ in })
    }
}
