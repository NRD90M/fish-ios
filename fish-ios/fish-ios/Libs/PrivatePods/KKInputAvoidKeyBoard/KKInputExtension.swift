//
//  InputExtension.swift
//  KKInputAvoidKeyBoard
//
//  Created by 王铁山 on 2018/8/19.
//  Copyright © 2018年 wangtieshan. All rights reserved.
//

import Foundation

import UIKit

import ObjectiveC.runtime

private struct PK {
    
    static let tfKey: UnsafePointer<Int> = UnsafePointer<Int>.init(bitPattern: "tfKey".hashValue)!
    
    static let tfDistanceKey: UnsafePointer<Int> = UnsafePointer<Int>.init(bitPattern: "tfDistanceKey".hashValue)!
    
    static let tvKey: UnsafePointer<Int> = UnsafePointer<Int>.init(bitPattern: "tvKey".hashValue)!
    
    static let tvDistanceKey: UnsafePointer<Int> = UnsafePointer<Int>.init(bitPattern: "tvDistanceKey".hashValue)!
}

extension UITextField {
    
    public var isAvoidKeyBoardEnable: Bool {
        set {
            objc_setAssociatedObject(self, PK.tfKey, newValue ? "true" : "false", objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            if let enable = objc_getAssociatedObject(self, PK.tfKey) as? String {
                return enable == "true"
            }
            return false
        }
    }
    
    public var avoidKeyBoardDistance: Float {
        set {
            objc_setAssociatedObject(self, PK.tfDistanceKey, NSNumber.init(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            if let enable = objc_getAssociatedObject(self, PK.tfDistanceKey) as? NSNumber {
                return enable.floatValue
            }
            return 10
        }
    }
}

extension UITextView {
    
    public var isAvoidKeyBoardEnable: Bool {
        set {
            objc_setAssociatedObject(self, PK.tvKey, newValue ? "true" : "false", objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            if let enable = objc_getAssociatedObject(self, PK.tvKey) as? String {
                return enable == "true"
            }
            return false
        }
    }
    
    public var avoidKeyBoardDistance: Float {
        set {
            objc_setAssociatedObject(self, PK.tvDistanceKey, NSNumber.init(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            if let enable = objc_getAssociatedObject(self, PK.tvDistanceKey) as? NSNumber {
                return enable.floatValue
            }
            return 10
        }
    }
}
