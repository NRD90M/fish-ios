//
//  PondIOInfoModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/3.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import ObjectMapper

open class PondIOInfoModel: Mappable {
    
    open var code: String?
    open var type: String?
    open var name: String?
    open var pin: Int?
    open var enabled: Bool?
    open var powerW: Int?
    open var weightPerSecond: Float?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        code    <- map["code"]
        
        type <- map["type"]
        name <- map["name"]
        pin <- map["pin"]
        enabled <- map["enabled"]
        powerW <- map["power_w"]
        weightPerSecond <- map["weight_per_second"]
        
        
        
        
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
}
