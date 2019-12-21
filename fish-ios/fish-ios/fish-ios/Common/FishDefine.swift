//
//  FishDefine.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/5.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import UIKit


struct FishDefine {
    
    static func weekDayToCHN(day:Int) -> String {
        
        switch day {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        default:
            return "周日"
        }
        
    }
}



public struct PickViewItem {
    public var code: String?
    public var name: String?
    
    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}

