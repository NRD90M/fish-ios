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
    func userInfo(callBack: ((FishCodeMsgResponseObjectModel<UserInfoModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/user/load"), params: getParams(), callBack: callBack)
    }
    
    /// 获取用户场景列表
    func getAllScene(callBack: ((FishCodeMsgResponseArrayTypeModel<PondSceneModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/scene/get_all_scene"), params: getParams(), callBack: callBack)
    }
    
    /// 获取设备状态列表
    func getIOInfo(params: [String: Any], callBack: ((FishCodeMsgResponseArrayTypeModel<PondIOInfoModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/device/get_io_info"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    ///实时视频
    func getCamsConfig(params: [String: String], callBack: ((FishCodeMsgResponseObjectModel<CameraRootModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/cams/get_config"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func getCamsPlay(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/cams/play"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func getCamsStop(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/cams/stop"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func getCamsSwitchProfile(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/cams/switch_profile"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    ///------计划模块-----------
    /// 获取定时任务列表
    func getAllPlan(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<PlanInfoModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/get_all_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func disablePlan(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/disable_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func enablePlan(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/enable_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func addPlan(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/add_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func editPlan(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/edit_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func removePlan(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/plan/remove_plan"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 获取触发任务列表
    func getAllTrigger(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<TriggerInfoModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/get_all_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func disableTrigger(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/disable_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func enableTrigger(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/enable_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func addTrigger(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/add_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func editTrigger(params: [String: Any], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/edit_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }

    func removeTrigger(params: [String: String], callBack: ((FishCodeMsgResponseAnyModel<String>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/trigger/remove_trigger"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 报表相关
    func getMonthSensorData(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<MonthSensorDataModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/report/get_sensor_data"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    func getSensorDataDetail(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<SensorDataDetailModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/report/get_sensor_data_detail"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 饼图
    func getMonthPowerData(params: [String: String], callBack: ((FishCodeMsgResponseObjectModel<MonthPowerDataModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/report/get_power_data"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    /// 饲料月报表
    func getMonthFeedData(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<MonthFeedDataModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/report/get_feed_data"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
    
    /// o2月报表
    func getMonthO2Data(params: [String: String], callBack: ((FishCodeMsgResponseArrayTypeModel<MonthO2DataModel>?, NSError?)->Void)?) {
        self.post(path: safeJoinURL(pre: baseURL(), suf: "api/report/get_aeration_data"), params: dictExtend(p1: params, p2: getParams()), callBack: callBack)
    }
    
}
