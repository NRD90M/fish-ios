//
//  Logger.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/25.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Logger {
    // 单例
    static let shared: Logger = Logger()
    
    func setUpConfig() -> Void {
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}

public func FLogInfo(_ message:String) {
    DDLogInfo(message)
}


public func FLogVerbose(_ message:String) {
    DDLogVerbose(message)
}

public func FLogWarn(_ message:String) {
    DDLogWarn(message)
}

public func FLogDebug(_ message:String) {
    DDLogDebug(message)
}

public func FLogError(_ message:String) {
    DDLogError(message)
}
