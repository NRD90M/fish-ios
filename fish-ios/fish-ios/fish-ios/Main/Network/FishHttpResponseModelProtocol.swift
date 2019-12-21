//
//  FishHttpResponseModelProtocol.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/25.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let FishHTTPResponseParseTokenFail: Notification.Name = Notification.Name.init("FishHTTPResponseParseTokenFailNotificationKey")
}

/// 网络请求数据返回模型遵守协议
public protocol FishHTTPResponseModelProtocol {
    
    /// 自身判断是否成功
    func isSuccess()        -> Bool
   
    /// token 是否失效
    func tokenInvalid()          -> Bool
    
    func errorCode() -> String?
    
    func errorMessage() -> String?
    
}


public protocol FishHTTPResponseParseProtocol {
    
    // MARK: - 解析。。。。
    
    /**
     解析网络请求回来的数据，提取code 或 error 或 error message 返回 FishError 供UI显示
     不会自动调用代理方法通知代理
     
     - parameter data:  网络请求返回来的数据模型。继承自UserCBSBaseResponseModel
     - parameter error: 网络请求返回的网络错误
     
     - returns: 错误 FishError
     */
    func parseResponse(_ data: FishHTTPResponseModelProtocol?, _ error: NSError?) -> FishError?
    
    /**
     解析网络请求返回的数据模型
     
     - parameter data: 网络请求返回来的数据模型。继承自UserCBSBaseResponseModel
     
     - returns: code 所对应的错误FishError
     */
    func parseResponseModel(_ data: FishHTTPResponseModelProtocol) -> FishError?
    
    /**
     解析网络请求返回的 NSError
     
     - parameter error: 网络错误
     
     - returns: 网络错误所对应的 FishError
     */
    func parseError(_ error: NSError) -> FishError
    
}


extension FishHTTPResponseParseProtocol {
    
    // MARK: - 解析。。。。
    
    /**
     解析网络请求回来的数据，提取code 或 error 或 error message 返回 FishError 供UI显示
     不会自动调用代理方法通知代理
     
     - parameter data:  网络请求返回来的数据模型。继承自UserCBSBaseResponseModel
     - parameter error: 网络请求返回的网络错误
     
     - returns: 错误 FishError
     */
    public func parseResponse(_ data: FishHTTPResponseModelProtocol?, _ error: NSError?) -> FishError? {
        if let eError = error {
            return self.parseError(eError)
        }
        
        // 无网络错误
        guard let response = data else {
            // 返回无数据则为服务器数据返回错误
            // reason：因为model一定存在。不存在则为服务器数据错误
            return FishError.serviceFormatError()
        }
        
        return self.parseResponseModel(response)
    }
    
    /**
     解析网络请求返回的数据模型
     
     - parameter data: 网络请求返回来的数据模型。继承自UserCBSBaseResponseModel
     
     - returns: code 所对应的错误FishError
     */
    public func parseResponseModel(_ data: FishHTTPResponseModelProtocol) -> FishError? {
        
        if data.isSuccess() {
            return nil
        }
        
        // 1. 判断是否是 token 失效
        if data.tokenInvalid() {
            /// 发送 tokenInvalid 通知
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.FishHTTPResponseParseTokenFail, object: nil)
            }
            return FishError.tokenInvalidError()
        }
        
        // 返回非1000的其他code，交由对应页面处理
        return FishError(code: data.errorCode(), showMessage: data.errorMessage())
    }
    
    /**
     解析网络请求返回的 NSError
     
     - parameter error: 网络错误
     
     - returns: 网络错误所对应的 FishError
     */
    public func parseError(_ error: NSError) -> FishError {
        
        let description = error.localizedDescription
        
        if description == "Request failed: 内部服务器错误 (500)" || description == "Request failed: internal server error (500)" || error.code == 500 {
            
            return FishError(code: "500", showMessage: "内部服务器错误(500)")
        } else if error.code == Int(FishServiceInvalidErrorCode) || description == "Request failed: service unavailable (503)" {
            
            return FishError(code: "\(FishServiceInvalidErrorCode)", showMessage: "内部服务器不可用(503)")
            
        } else if error.code == NSURLErrorBadServerResponse {
            
            return FishError(code: "\(NSURLErrorBadServerResponse)", showMessage: FishURLErrorBadServerResponseMessage)
        } else if error.code == NSURLErrorTimedOut {
            
            return FishError(code: "\(NSURLErrorTimedOut)", showMessage: FishURLErrorTimedOutMessage)
        } else if error.code == NSURLErrorCannotConnectToHost {
            
            return FishError(code: "\(NSURLErrorCannotConnectToHost)", showMessage: FishURLErrorCannotConnectToHostMessage)
        } else if error.code == NSURLErrorNotConnectedToInternet {
            
            return FishError(code: "\(NSURLErrorNotConnectedToInternet)", showMessage: FishURLErrorNotConnectedToInternetMessage)
        } else if error.code == NSURLErrorCancelled {
            
            return FishError(code: "\(NSURLErrorCancelled)", showMessage: FishURLErrorCancelledMessage)
        } else if error.code == NSURLErrorCannotFindHost {
            
            return FishError(code: "\(NSURLErrorCannotFindHost)", showMessage: FishURLErrorCannotFindHostMessage)
        }
        
        return FishError(code: "\(error.code)", showMessage: "请求失败(\(error.code))")
        
        // 其它所有的网络方面的错误均返回网络请求的错误
        // 如需针对某种网络错误，如上格式添加
        // return FishError.netRequestError()
    }
    
}

/// 暴漏一个基于 SMHTTPResponseParseProtocol 的对象，便于直接调用
public struct _Parse: FishHTTPResponseParseProtocol {}

/// 暴漏一个基于 SMHTTPResponseParseProtocol 的对象，便于直接调用
public let Parse = _Parse()

/// 使用此结构体传输错误信息
/// 背景：产生错误时，要么向用户展示错误信息，要么后台处理.故如下错误封装
/// 1. 减少解析难度 2. 实事为 view 提供所需要的数据 3. 统一网络错误或服务器错误的处理和提示
public struct FishError {
    
    public var code: String?
    
    public var showMessage: String?
    
}


public extension FishError {
    
    public static func serviceFormatError() -> FishError {
        return FishError(code:FishServiceDataFormatInvalid, showMessage: FishServiceDataFormatInvalidMessage )
    }
    public func isServiceFormatError() -> Bool {
        guard let code = self.code else {
            return false
        }
        return code == FishServiceDataFormatInvalid
    }
    
    public static func tokenInvalidError() -> FishError {
        return FishError(code:FishTokenInvalidErrorCode, showMessage: FishTokenInvalidErrorMessage )
    }
    public func isTokenInvalidError() -> Bool {
        guard let code = self.code else {
            return false
        }
        return code == FishTokenInvalidErrorCode
    }
}


/**
 
 以下 code 和 message 的定义
 是为了统一网络错误时的提示语
 并且都是使用 var 定义，意味着我们可以方便的修改不同网络错误时用户的提示语
 当然更多的是对系统定义好的 code 的一个提示语的定义。可以参考 NSURLErrorUnknown 下面的多个错误code。
 
 */

// MARK: - 自定义的网络错误代码

/// 服务器返回数据格式错误(例如：code 不存在或为空)
public var FishServiceDataFormatInvalid: String = "FishServiceDataFormotInvalid"
public var FishServiceDataFormatInvalidMessage: String = "服务器数据格式错误"

/// token 失效
public var FishTokenInvalidErrorCode: String = "FishTokenInvalidErrorCode"
public var FishTokenInvalidErrorMessage: String = ""

/// 内部服务器不可用(503)
public var FishServiceInvalidErrorCode: String = "503"
public var FishServiceInvalidErrorCodeMessage: String = "内部服务器不可用(503)"

/// 内部服务器错误(500)
public var FishServiceCodeErrorCode: String = "500"
public var FishServiceCodeErrorCodeMessage: String = "内部服务器错误(500)"

// MARK: - 系统网络错误的提示语统一整理。便于全局统一修改
public var FishURLErrorNotConnectedToInternetMessage: String = "网络无连接 请检查网络" // -1009
public var FishURLErrorCancelledMessage: String = ""   // 网络取消一般不提示 -999
public var FishURLErrorTimedOutMessage: String = "请求超时，请在网络好的情况下重试" // -1001
public var FishURLErrorBadServerResponseMessage: String = "无法连接服务器" // -1011
public var FishURLErrorCannotConnectToHostMessage: String = "未能连接到服务器" // -1004
public var FishURLErrorCannotFindHostMessage: String = "未能连接到服务器" // -1003


