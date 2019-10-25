//
//  FishCodeMsgResponseAnyModel.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/24.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import ObjectMapper

/// 网络接口返回 code message 格式基类
open class CodeMsgResponseModel: Mappable {
    
    open var code: Int?
    
    // 状态信息
    open var message: String?
    
    
    init() {
        
    }
    
    open func mapping(map: Map) {
        
        code    <- map["code"]
        
        message <- map["message"]
        
    }
    
    public required init?(map: Map) {
        self.mapping(map: map)
    }
}


extension CodeMsgResponseModel : FishHTTPResponseModelProtocol {
    
    public func errorCode() -> String? {
        if let c = code {
            return String(c);
        }
        return "-"
    }
    
    public func errorMessage() -> String? {
        return message
    }
    
    open func isSuccess() -> Bool {
        
        if code == 1000 {
            return true
        }
        return false
    }
    
    // 5001 渠道 5001 代表 token 失效
    // code = 101 兼容订单系统，token 失效
    open func tokenInvalid() -> Bool {
        
        if (code == 1200) {
            return true
        }
        return false
    }
    
}


class FishCodeMsgResponseAnyModel<T>: CodeMsgResponseModel {
    
    open var data: T?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        data    <- map["data"]
    }

}

/// 可以指定 data 类型
open class FishCodeMsgResponseObjectModel<T: Mappable>: CodeMsgResponseModel {
    
    open var data: T?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        data    <- map["data"]
    }
}

/// 可以指定 data 类型
open class FishCodeMsgResponseArrayTypeModel<T: Mappable>: CodeMsgResponseModel {
    
    open var data: [T]?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        data    <- map["data"]
    }
}


