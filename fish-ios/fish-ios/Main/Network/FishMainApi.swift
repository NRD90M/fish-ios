//
//  FishApi.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/24.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import ObjectMapper

class FishMainApi: STJSONApi {

    func getParams() -> [String: Any] {
        return [:]
    }
    
    func baseURL() -> String {
        return "https://fish.ypcxpt.com/"
    }
    
    /// 登录
//    func login(params: [String: Any], callBack: ((SMCodeMsgResponseAnyModel<[String: Any]>?, NSError?)->Void)?) {
//        self.post(path: safeJoinURL(pre: channelURL(), suf: "login"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
//    }
    
    /// 发送验证码
    func sendVerifyCode(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/user/send_vali_sms"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 登录
    func login(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/user/login"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 获取用户基本信息
    func userInfo(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/user/load"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 获取用户场景列表
    func getAllScene(callBack: ((FishCodeMsgResponseArrayTypeModel<PondSceneModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/scene/get_all_scene"), params: getParams(), callBack: callBack)
    }
    
    /// 获取设备状态列表
    func getIOInfo(params: [String: Any], callBack: ((FishCodeMsgResponseArrayTypeModel<PondIOInfoModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/device/get_io_info"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
}
