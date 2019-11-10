//
//  FishWebSocket.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/3.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Starscream

public extension Notification.Name {
    
    public static let FishWebSocketNotification: Notification.Name = Notification.Name("FishWebSocketNotification")
}


//{
//    "type": 1,
//    "device_mac": "b827eb170977",
//    "data": {
//        "online": 1,
//        "status": {
//            "water_temperature": 17.7,
//            "o2": 9.7,
//            "ph": 8.8,
//            "uptime": 1572028865754,
//            "lamp1": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            },
//            "lamp2": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            },
//            "pump1": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            },
//            "aerator1": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            },
//            "aerator2": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            },
//            "feeder1": {
//                "opened": 0,
//                "start_time": null,
//                "duration": null
//            }
//        }
//    }
//}

public class FishWebSocket {
    
    public static let shared: FishWebSocket = FishWebSocket()
    
    var socket: WebSocket?
    
    var debug: Bool = false
    
    var serverUrl: String = "fish.ypcxpt.com/"
    
    var login_account: String?
    var login_username: String?
    var login_store_name: String?
    
//    wss://fish.ypcxpt.com/?token=b5fff1337ab14429b7880d5678c94651
    public func createSocket(urlStr: String) {
        
        guard let url = URL(string: "wss://\(urlStr)?token=\(FishUserInfo.token())") else {
            return
        }
        socket = WebSocket(url: url)
        
        configSocket()
    }
    
    
    func configSocket() {
        #if DEBUG
        debug = true
        #endif
        
        socket?.onConnect = { [weak self] in
            debugPrint("---> FishWebSocket is connected on \(self?.socket?.currentURL.absoluteString ?? "")")
//            self?.sendDeviceInfo()
        }
        
        socket?.onDisconnect = { (error: Error?) in
            debugPrint("---> FishWebSocket is disconnected: \(error?.localizedDescription)")
        }
        
        socket?.onText = { [weak self] (text: String) in
            debugPrint("---> FishWebSocket got some text: \(text)")
            self?.getText(text)
        }
        
        socket?.onData = { (data: Data) in
            debugPrint("got some data: \(data.count)")
        }
    }
    
    
//    public func setUserInfo(login_account: String?, login_username: String?, login_store_name: String?) {
//
//        guard self.login_account != login_account
//            || self.login_username != login_username
//            || self.login_store_name != login_store_name else {
//                return
//        }
//
//        self.login_account = login_account
//        self.login_username = login_username
//        self.login_store_name = login_store_name
//
//        self.sendDeviceInfo()
//    }
    
    // 连接日志socket
    public class func socketConnect(urlStr: String?) {
        
        guard let socket = shared.socket else {
            
            if let url = urlStr {
                shared.serverUrl = url
            }
            
            shared.createSocket(urlStr: shared.serverUrl)
            
            shared.socket?.connect()
            
            return
        }
        
        socket.connect()
    }
    
    // 断开日志socket
    public class func socketDisconnect() {
        shared.socket?.disconnect()
    }
    
    
    func getText(_ str: String) {
        
        print(str)
        
//        guard str != "success" else {
//            return
//        }
//
        guard let jsonData = str.data(using: String.Encoding.utf8) else {
            return
        }

        guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String : Any]
            else {
                return
        }
        
        // 刷新共有数据
        FishWebSocketDataHelper.shared.refreshDeviceStatus(data: dic)
        
         NotificationCenter.default.post(name: Notification.Name.FishWebSocketNotification, object: dic, userInfo: nil)
        
//
//        if type == "logback" { // 日志回捞
//            socket?.write(string: "logback")
//            NotificationCenter.default.post(name: Notification.Name.SMSocketLogBackNotification, object: self, userInfo: dic)
//        }
    }
    
    
//    // 在成功获取用户信息之后发送
//    fileprivate func sendDeviceInfo() {
//
//        let deviceInfo = ["platform" : "iOS",
//                          "deviceid" : SMSocketHelper.getUUID(),
//                          "osverison" : UIDevice.current.systemVersion,
//                          "brand" : UIDevice.current.model,
//                          "model" : SMSocketHelper.iphoneType(),
//                          "rom" : UIDevice.current.systemName,
//                          "type" : "status",
//                          "login_account" : login_account ?? "ACCOUNT_EMPTY",
//                          "login_username" : login_username ?? "ACCOUNT_EMPTY",
//                          "login_store_name" : login_store_name ?? "ACCOUNT_EMPTY"]
//
//        socket?.write(string: SMSocketHelper.getJSONStringFromDic(deviceInfo))
//    }
}
