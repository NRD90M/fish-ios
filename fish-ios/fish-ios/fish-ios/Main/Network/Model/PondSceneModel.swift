//
//  PondSceneModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/3.
//  Copyright © 2019 caiwenshu. All rights reserved.
//


import UIKit

import ObjectMapper

open class PondSceneModel: Mappable {
    
    open var deviceMac: String?
    
    open var sceneName: String?
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        deviceMac    <- map["device_mac"]
        
        sceneName <- map["scene_name"]
        
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)

    }
}
