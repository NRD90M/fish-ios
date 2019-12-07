//
//  PlanInfoModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import ObjectMapper

open class PlanInfoModel: Mappable {
    
    open var id: String?
    open var per: String?
    open var day_of_month: Int?
    open var day_of_week: Int?
    open var hour: Int?
    open var minute: Int?
    open var second: Int?
    open var io_code: String?
    open var io_type: String?
    open var io_name: String?
    open var duration: Int?
    open var enabled: Bool?
    open var weight: Int?
    
    init() {
        self.second = 0
        self.enabled = true
        self.day_of_month = nil
        self.day_of_week = nil
        self.weight = nil
    }
    
    open func mapping(map: Map) {
        
        id    <- map["id"]
        per <- map["per"]
        day_of_month <- map["day_of_month"]
        day_of_week <- map["day_of_week"]
        hour <- map["hour"]
        minute <- map["minute"]
        second <- map["second"]
        io_code <- map["io_code"]
        io_type <- map["io_type"]
        io_name <- map["io_name"]
        duration <- map["duration"]
        enabled <- map["enabled"]
        weight <- map["weight"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
