//
//  Logger.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/11/22.
//

import Foundation


enum Log {
    enum LogLevel {
        case info
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info:
                return "ℹ️ INFO: "
            case .warning:
                return "⚠️ WARNING! "
            case .error:
                return "🚨 ERROR! 🚨 "
                
            }
        }
    }
    
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "     [ -File:\((file as NSString).lastPathComponent) | -Function:\(function) | -Line:\(line) ]"
        }
    }
    
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    static func warning(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    static func error(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)]", str]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += "\(context.description)"
        }
        
    #if DEBUG
        print(fullString)
    #endif
        
    }
}
