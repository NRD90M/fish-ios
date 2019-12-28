//
//  SensorDataDetailModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/28.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "water_temperature": 15.6,
//    "ph": 8.9,
//    "o2": 0,
//    "create_time": "2019-10-31T16:00:00.000Z"
//},

open class SensorDataDetailModel: Mappable {
    
    open var create_time: String?
    open var water_temperature: Double?
    open var ph: Double?
    open var o2: Double?
   
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        create_time    <- map["create_time"]
        water_temperature <- map["water_temperature"]
        ph <- map["ph"]
        o2 <- map["o2"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
