//
//  MonthFeedDataModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/31.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "date": "2019-11-01",
//    "sum_actual_weight": 450.02
//},
open class MonthFeedDataModel: Mappable {
    
    open var date: String?
    open var sum_actual_weight: Double?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        date    <- map["date"]
        sum_actual_weight <- map["sum_actual_weight"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
