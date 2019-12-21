//
//  STUserInfo.swift
//  ShenmaEV
//
//  Created by cheng on 2018/6/14.
//  Copyright © 2018年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//

import UIKit

import ObjectMapper

/*
 * 用户信息管理类
 */
class FishUserInfo {
    // 单例
    static let shared: FishUserInfo = FishUserInfo()
    
    /// 退出登录, 并清理相关用户信息
    class func logout() {
        logoutOnlyClearInfo()
    }

    /// 退出登录, 只清理相关用户信息
    class func logoutOnlyClearInfo() {
    }
    
   
}

// MARK: - App用户信息基本参数 登录相关
extension FishUserInfo {
    
    /// ********** Token(用户登录成功时返回) **********
    class func setToken(_ token: String?) {
        setValue(token, key: "FISH_LOGIN_TOKEN")
    }
    
    class func token() -> String {
        return getValue("FISH_LOGIN_TOKEN") ?? ""
    }
}


extension FishUserInfo {
    
    fileprivate class func getValue(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    fileprivate class func setValue(_ value: String?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - 私有设置和取出数据
    fileprivate class func privateValueForKey(_ key: String) -> String? {
        return self.getValue(key)
    }
    
    fileprivate class func privateSetValue(_ value: String?, key: String) {
        self.setValue(value, key: key)
    }
}
