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


class FishCodeMsgResponseAnyModel<T>: CodeMsgResponseModel {
    
    open var data: T?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        data    <- map["data"]
    }

}
