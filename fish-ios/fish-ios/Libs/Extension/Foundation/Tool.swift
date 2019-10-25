//
//  SMTool.swift
//  RosettaTobMainApp
//
//  Created by KING on 2016/12/27.
//  Copyright © 2016年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//

import UIKit

/// 当前状态屏幕宽
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

/// 当前状态屏幕高
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// 导航栏高度 64，视情况定是否使用此高度
let NAVIGATION_BAT_HEIGHT: CGFloat = 64.0

func RGB(_ red: NSInteger, green: NSInteger, blue: NSInteger) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}

public func GlobalLowAsync(_ block: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async(execute: block)
}

public func GlobalBackgroundAsync(_ block: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: block)
}

public func GlobalAsync(_ block: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: block)
}

public func MainAsync(_ block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}

public func SafeMain(_ block: @escaping ()->()) {
    if Thread.current.isMainThread {
        block()
    }else {
        DispatchQueue.main.async(execute: block)
    }
}

public func After(_ seconds: Int, queue: DispatchQueue, block: @escaping ()->Void) {
    queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC),
                     execute: block)
}

public func MainAfter(_ seconds: Int, block: @escaping ()->Void) {
    After(seconds, queue: DispatchQueue.main, block: block)
}

public func GlobalAfter(_ seconds: Int, block: @escaping ()->Void) {
    After(seconds, queue: DispatchQueue.global(), block: block)
}

public func CachePath() -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    guard let first = paths.first else {
        return NSHomeDirectory() + "/Library/Caches"
    }
    return first
}

