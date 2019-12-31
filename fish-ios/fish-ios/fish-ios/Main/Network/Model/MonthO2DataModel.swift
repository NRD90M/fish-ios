//
//  MonthO2DataModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/31.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "date": "2019-11-01",
//    "sum_actual_duration": 53
//}
open class MonthO2DataModel: Mappable {
    
    open var date: String?
    open var sum_actual_duration: Double?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        date    <- map["date"]
        sum_actual_duration <- map["sum_actual_duration"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
