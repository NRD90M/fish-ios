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
    open var condition: Int?
    open var condition_val: Int?
    open var io_code: String?
    open var operaction: String?
    open var duration: Int?
    open var enabled: Bool?

    init() {
        
    }
    
    open func mapping(map: Map) {
        
        id    <- map["id"]
        monitor <- map["monitor"]
        condition <- map["condition"]
        condition_val <- map["condition_val"]
        io_code <- map["io_code"]
        operaction <- map["operaction"]
        duration <- map["duration"]
        enabled <- map["enabled"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
}
