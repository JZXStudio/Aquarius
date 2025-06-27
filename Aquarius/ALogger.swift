//
//  ALog.swift
//  Aquarius
//
//  Created by SONG JIN on 2023/1/11.
//

import Foundation

public enum ALoggerType {
    case VERBOSE
    case DEBUG
    case INFO
    case WARNING
    case ERROR
    case NONE
}

open class ALogger: NSObject {
    public static let shared = ALogger()
    
    private func a_print<T>(_ message: T) {
        #if DEBUG
        //这句声明日期显示范围精确到秒
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print("\(dateFormatter.string(from: Date())) | \(message)")
        #endif
    }
    //, file: String = #file, method: String = #function, line: Int = #line
    public func a_print<T>(_ message: T, type: ALoggerType) {
        switch type {
        case .VERBOSE:
            verbose(message)
            break
        case .DEBUG:
            debug(message)
            break
        case .INFO:
            info(message)
            break
        case .WARNING:
            warning(message)
            break
        case .ERROR:
            error(message)
            break
        case .NONE:
            a_print(message)
        }
    }
    
    public func verbose<T>(_ message: T) {
        let emoji: String =  "💙[verbose]💙 | "
        a_print("\(emoji)\(message)")
    }
    
    public func debug<T>(_ message: T) {
        let emoji: String = " 💚[debug]💚  | "
        a_print("\(emoji)\(message)")
    }
    
    public func info<T>(_ message: T) {
        let emoji: String = " 💜[info]💜   | "
        a_print("\(emoji)\(message)")
    }
    
    public func warning<T>(_ message: T) {
        let emoji: String = "⚠️[warning]⚠️ | "
        a_print("\(emoji)\(message)")
    }
    
    public func error<T>(_ message: T) {
        let emoji: String =  " ❌[error]❌  | "
        a_print("\(emoji)\(message)")
    }
}
