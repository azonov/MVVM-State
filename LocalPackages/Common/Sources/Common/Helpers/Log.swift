//
//  Log.swift
//  
//
//  Created by Andey on 20.06.2022.
//

import os

public final class Log {
    
    private static var infoMessage: String? {
        didSet {
            guard let value = infoMessage, oldValue != value else {
                return
            }
            os_log("| Log | %s", type: .info, value)
        }
    }
    
    public static func info(_ message: String) {
        infoMessage = message
    }
}
