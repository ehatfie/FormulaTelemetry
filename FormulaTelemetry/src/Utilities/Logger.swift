//
//  Logger.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/30/22.
//

import Foundation

enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case warning = 2
    case error = 3
}

private let printLogLevel: LogLevel = .debug

func log(_ message: String, level: LogLevel = .debug) {
    if level.rawValue >= printLogLevel.rawValue {
        print("log \(message)")
    }
}
