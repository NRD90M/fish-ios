////
////  PondSocketModel.swift
////  fish-ios
////
////  Created by caiwenshu on 2019/11/3.
////  Copyright © 2019 caiwenshu. All rights reserved.
////
//import UIKit
//
//import ObjectMapper
//
//open class PondSocketModel: Mappable {
//    
//    open var device_mac: String?
//    open var type: String?
//    open var data: String?
// 
//    init() {
//        
//    }
//    
//    open func mapping(map: Map) {
//        
//        code    <- map["code"]
//        
//        type <- map["type"]
//        name <- map["name"]
//        pin <- map["pin"]
//        enabled <- map["enabled"]
//        powerW <- map["power_w"]
//        weightPerSecond <- map["weight_per_second"]
//        
//        
//        
//        
//    }
//    
//    public required init?(map: Map) {
//        self.mapping(map: map)
//        
//    }
//}
//
//
//
//open class PondSocketDataModel: Mappable {
//    
//    open var online: String?
//    open var status: String?
//    
//    init() {
//        
//    }
//    
//    open func mapping(map: Map) {
//        
//        code    <- map["code"]
//        
//        type <- map["type"]
//        name <- map["name"]
//        pin <- map["pin"]
//        enabled <- map["enabled"]
//        powerW <- map["power_w"]
//        weightPerSecond <- map["weight_per_second"]
//        
//        
//        
//        
//    }
//    
//    public required init?(map: Map) {
//        self.mapping(map: map)
//        
//    }
//}
//
//
//
//
//open class PondSocketDataStatusModel: Mappable {
//    
//    open var waterTemperature: Float?
//    
//    open var o2: Float?
//    
//    open var ph: Float?
//    
//    open var uptime: Float?
//    
//    init() {
//        
//    }
//    
//    open func mapping(map: Map) {
//        
//        waterTemperature    <- map["water_temperature"]
//        
//        o2 <- map["o2"]
//        
//        ph <- map["ph"]
//        
//        uptime <- map["uptime"]
//        
//    }
//    
//    public required init?(map: Map) {
//        self.mapping(map: map)
//        
//    }
//}
//
//
//
