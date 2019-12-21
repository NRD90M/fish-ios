//
//  STBaseAPI.swift
//  ShenmaEV
//
//  Created by 王铁山 on 2018/6/17.
//  Copyright © 2018年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//

import Foundation

import ObjectMapper

extension STApi {
    
    /// 合并两个字典
    open func dictExtend(p1: [String: Any], p2: [String: Any]) -> [String: Any] {
        var r = p1
        for (key, value) in p2 {
            r[key] = value
        }
        return r
    }
    
    /// 拼接URL
    open func safeJoinURL(pre: String, suf: String) -> String {
        return modifierSuffixURLSep(url: pre).appending(modifierPrefixURLSep(url: suf))
    }
    
    /// post 请求
    @discardableResult
    open func post<T: Mappable>(path: String, params: [String: Any], callBack: ((T?, NSError?) -> Void)?) -> URLSessionDataTask? {
        
        return self.postPath(path, parameters: params) { (response, error) in
            
            self.dealResponseAndError(response: response, error: error, callBack: callBack)
        }
    }
    
    /// get 请求
    open func get<T: Mappable>(path: String, params: [String: Any], callBack: ((T?, NSError?) -> Void)?) {
        
        self.getPath(path, parameters: params) { (response, error) in
            
            self.dealResponseAndError(response: response, error: error, callBack: callBack)
        }
    }
    
    private func dealResponseAndError<T: Mappable>(response: Any?, error: NSError?, callBack: ((T?, NSError?) -> Void)?) {
        
        guard let obj = response, let model = Mapper<T>().map(JSONObject: obj) else {
            callBack?(nil, error)
            return
        }
        callBack?(model, error)
    }
    
    /// 保证以 / 结束
    private func modifierSuffixURLSep(url: String)->String {
        if url.hasSuffix("/") {
            return url
        }
        return url.appending("/")
    }
    
    /// 保证不以 / 开头
    private func modifierPrefixURLSep(url: String)->String {
        if url.hasPrefix("/") {
            return url.substring(from: url.index(after: url.startIndex))
        }
        return url
    }
}
