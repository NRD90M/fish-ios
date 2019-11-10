//
//  FishWebSocketDataHelper.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/10.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation


public class FishWebSocketDataHelper {
    
    public static let shared: FishWebSocketDataHelper = FishWebSocketDataHelper()
    
    public var deviceStatusData = Dictionary<String, Any>()
    
    func refreshDeviceStatus(data:Dictionary<String, Any>?) -> Void {
        
        guard let statusData = data else {
            return
        }
        guard let device_mac = statusData["device_mac"] as? String else {
            return
        }

        var foundExistKey = false
        for key in deviceStatusData.keys
        {
            if (key == device_mac) {
                foundExistKey = true
            }
        }
        
        if (foundExistKey) {
            deviceStatusData.updateValue(statusData, forKey: device_mac)
        } else {
            deviceStatusData[device_mac] = statusData
        }
    }
    
    func getDeviceData(mac:String) -> Any? {
        return deviceStatusData[mac]
    }
    
    
}
