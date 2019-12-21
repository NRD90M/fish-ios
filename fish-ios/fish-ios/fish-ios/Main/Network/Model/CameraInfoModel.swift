//
//  CameraInfoModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/11.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import ObjectMapper

open class CameraRootModel: Mappable {

    
    
    open var usable_cams: [CameraInfoModel]?
    open var not_available_cams: [CameraInfoModel]?
    
    init() {
        
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        usable_cams    <- map["usable_cams"]
        not_available_cams <- map["not_available_cams"]
        
    }
}


open class CameraInfoModel: Mappable {
    
    open var key: String?
    open var hostname: String?
    open var profiles: [CameraInfoProfileModel]?
    open var preview_image: String?
    
    init() {
    }
    
    open func mapping(map: Map) {
        
        key    <- map["key"]
        hostname <- map["hostname"]
        profiles <- map["profiles"]
        preview_image <- map["preview_image"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

//"token": "profile_2",
//"width": 640,
//"height": 480,
//"label": "流畅",
//"rtsp_url": "rtsp://ed.ypcxpt.com/b827eb170977/1921688110/profile_2",
//"selected": false

open class CameraInfoProfileModel: Mappable {
    
    open var token: String?
    open var width: Double?
    open var height: Double?
    open var label: String?
    open var rtsp_url: String?
    open var selected: Bool?
    
    init() {
    }
    
    open func mapping(map: Map) {
        
        token    <- map["token"]
        width <- map["width"]
        height <- map["height"]
        label <- map["label"]
        rtsp_url <- map["rtsp_url"]
        selected <- map["selected"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

