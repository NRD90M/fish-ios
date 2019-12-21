//
//  UserInfoModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/19.
//  Copyright © 2019 caiwenshu. All rights reserved.
//
import UIKit

import ObjectMapper

//{
//    "code": 1000,
//    "data": {
//        "user": {
//            "id": "f8316388-1562-11e9-ab14-d663bd873d93",
//            "icon": null,
//            "display_name": "NewbBeach",
//            "mobile": "18616514687",
//            "create_time": "2019-01-11T05:49:17.000Z",
//            "update_time": "2019-03-23T07:36:16.000Z"
//        },
//        "scenes": [
//        {
//        "device_mac": "b827eb170977",
//        "scene_name": "小小渔场1",
//        "create_time": "2019-09-11T03:37:33.000Z",
//        "update_time": "2019-09-11T03:39:42.000Z"
//        },
//        {
//        "device_mac": "b827eb540371",
//        "scene_name": "小小渔场2",
//        "create_time": "2019-09-11T03:37:42.000Z",
//        "update_time": "2019-09-11T03:39:41.000Z"
//        },
//        {
//        "device_mac": "b827ebe99675",
//        "scene_name": "重命名场景",
//        "create_time": "2019-09-21T13:49:37.000Z",
//        "update_time": "2019-11-25T07:06:35.000Z"
//        }
//        ]
//    }
//}

open class UserInfoModel: Mappable {
    
    open var scenes: [UserInfoSceneModel]?
    open var user: UserInfoUserModel?
    
    init() {
    }
    
    open func mapping(map: Map) {
        
        scenes    <- map["scenes"]
        user <- map["user"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

//            "id": "f8316388-1562-11e9-ab14-d663bd873d93",
//            "icon": null,
//            "display_name": "NewbBeach",
//            "mobile": "18616514687",
//            "create_time": "2019-01-11T05:49:17.000Z",
//            "update_time": "2019-03-23T07:36:16.000Z"

open class UserInfoUserModel: Mappable {
    
    open var id: String?
    open var icon: String?
    open var display_name: String?
    open var mobile: String?
    open var create_time: String?
    open var update_time: String?
    
    init() {
    }
    
    open func mapping(map: Map) {
        
        id    <- map["id"]
        icon <- map["icon"]
        display_name <- map["display_name"]
        mobile <- map["mobile"]
        create_time <- map["create_time"]
        update_time <- map["update_time"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}

//        "device_mac": "b827ebe99675",
//        "scene_name": "重命名场景",
//        "create_time": "2019-09-21T13:49:37.000Z",
//        "update_time": "2019-11-25T07:06:35.000Z"

open class UserInfoSceneModel: Mappable {
    
    open var device_mac: String?
    open var scene_name: String?
    open var create_time: String?
    open var update_time: String?
    
    init() {
    }
    
    open func mapping(map: Map) {
        
        device_mac    <- map["device_mac"]
        scene_name <- map["scene_name"]
        create_time <- map["create_time"]
        update_time <- map["update_time"]
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
        
    }
    
}
