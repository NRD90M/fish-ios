//
//  TriggerInfoModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "io_name": "增氧机2",
//    "io_type": "aerator",
//    "io_enabled": false,
//    "id": "cf92ad20-bc13-42a1-8bdd-9a72df875b74",
//    "monitor": "o2",
//    "condition": "<",
//    "condition_val": 0.4,
//    "io_code": "aerator2",
//    "operaction": "open",
//    "duration": null,
//    "enabled": false
//},

open class TriggerInfoModel: Mappable {

    open var id: String?
    open var monitor: String?
    open var condition: String?
    open var condition_val: Double?
    open var io_code: String?
    open var io_name: String?
    open var io_type: String?
    open var io_enabled: String?
    open var operaction: String?
    open var duration: Int?
    open var enabled: Bool?

    init() {
        self.enabled = true
    }
    
    open func mapping(map: Map) {
        
        id    <- map["id"]
        monitor <- map["monitor"]
        condition <- map["condition"]
        condition_val <- map["condition_val"]
        io_code <- map["io_code"]
        io_name <- map["io_name"]
        io_type <- map["io_type"]
        io_enabled <- map["io_enabled"]
        operaction <- map["operaction"]
        duration <- map["duration"]
        enabled <- map["enabled"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
