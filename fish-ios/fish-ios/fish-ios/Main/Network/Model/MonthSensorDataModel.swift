//
//  MonthSensorDataModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/28.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "date": "2019-12-04",
//    "max_water_temperature": 9.7,
//    "min_water_temperature": 5.6,
//    "avg_water_temperature": 7.1,
//    "max_ph": 8.7,
//    "min_ph": 8.2,
//    "avg_ph": 8.3,
//    "max_o2": 8.7,
//    "min_o2": 0,
//    "avg_o2": 2.9
//}

open class MonthSensorDataModel: Mappable {
    
    open var date: String?
    open var max_water_temperature: Double?
    open var min_water_temperature: Double?
    open var avg_water_temperature: Double?
    open var max_ph: Double?
    open var min_ph: Double?
    open var avg_ph: Double?
    open var max_o2: Double?
    open var min_o2: Double?
    open var avg_o2: Double?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        date    <- map["date"]
        max_water_temperature <- map["max_water_temperature"]
        min_water_temperature <- map["min_water_temperature"]
        avg_water_temperature <- map["avg_water_temperature"]
        max_ph <- map["max_ph"]
        min_ph <- map["min_ph"]
        avg_ph <- map["avg_ph"]
        max_o2 <- map["max_o2"]
        min_o2 <- map["min_o2"]
        avg_o2 <- map["avg_o2"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
