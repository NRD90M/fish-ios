//
//  MonthPowerDataModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "code": 1000,
//    "data": {
//        "list": [
//        {
//        "date": "2019-11-01",
//        "sum_wh": 4698.15
//        },
//        {
//        "date": "2019-11-02",
//        "sum_wh": 10.09
//        }
//        ],
//        "data_by_device": [
//        {
//        "io_name": "增氧机",
//        "io_code": "aerator1",
//        "io_type": "aerator",
//        "sum_wh": 10473.9
//        },
//        {
//        "io_name": "投喂机1",
//        "io_code": "feeder1",
//        "io_type": "feeder",
//        "sum_wh": 140.88
//        },
//        {
//        "io_name": "水泵",
//        "io_code": "pump1",
//        "io_type": "pump",
//        "sum_wh": 23422.65
//        }
//        ]
//    }
//}

open class MonthPowerDataModel: Mappable {
    
    open var list: [MonthPowerListDataModel]?
    open var data_by_device: [MonthPowerSumDataModel]?
   
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        list    <- map["list"]
        data_by_device <- map["data_by_device"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}


open class MonthPowerListDataModel: Mappable {
    
    open var date: String?
    open var sum_wh: Double?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        date    <- map["date"]
        sum_wh <- map["sum_wh"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

open class MonthPowerSumDataModel: Mappable {
    
    open var io_name: String?
    open var io_code: String?
    open var io_type: String?
    open var sum_wh: Double?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        io_name    <- map["io_name"]
        io_code    <- map["io_code"]
        io_type    <- map["io_type"]
        sum_wh <- map["sum_wh"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

