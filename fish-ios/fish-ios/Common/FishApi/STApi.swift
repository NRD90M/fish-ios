//
//  SMRosettaApiClient.swift
//  RosettaTobMainApp
//
//  Created by 王铁山 on 2017/3/14.
//  Copyright © 2017年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper
import SystemConfiguration


enum SMHTTPContentType {
    case json
    case form
}


// MARK: - Form
class STFormApi: STApi {
    
    override var contentType: ParameterEncoding {
        set { }
        get { return URLEncoding.default }
    }
    
    private static var privateInstance: STFormApi = STFormApi.init(contentType: SMHTTPContentType.form)
    
    override class func shared() -> STFormApi {
        return privateInstance
    }
}
// MARK: - Json
class STJSONApi: STApi {
    
    override var contentType: ParameterEncoding {
        set { }
        get { return JSONEncoding.default }
    }
    
    private static var privateInstance: STJSONApi = STJSONApi.init(contentType: SMHTTPContentType.json)
    
    override class func shared() -> STJSONApi {
        return privateInstance
    }
}

class STApi: NSObject {
    
    // 默认是form格式
    private static let privateInstance: STApi = STApi()
    
    // 判断是否是json请求
    var contentType: ParameterEncoding = URLEncoding.default
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30.0
        
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        return SessionManager(configuration: configuration)
    }()
    
    
    convenience init(contentType: SMHTTPContentType) {
        self.init()
        switch contentType {
        case .json:
            self.contentType = JSONEncoding.default
        case .form:
            self.contentType = URLEncoding.default
        }
    }
    
    class func shared() -> STApi {
        return privateInstance
    }
    
    
    // 设置超时时间
    class func setTimeoutInterval(_ time: Double){
        self.shared().manager.session.configuration.timeoutIntervalForRequest = time
    }
    
    func setTimeoutInterval(_ time: Double){
        self.manager.session.configuration.timeoutIntervalForRequest = time
    }
    
    // MARK: - params
    
    
    // MARK: - GET
    
    // get 无参数
    @discardableResult func getPath(_ path: String, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        return self.getPath(path, parameters: nil, block: block)
    }
    
    // get 有参数
    @discardableResult func getPath(_ path: String, parameters: [String: Any]?, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(false, path: path, parameters: parameters, block: block)
    }
    
    // get 有参数 有 header
    @discardableResult func getPath(_ path: String, parameters: [String: Any]?, header: [String: String]?, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(false, path: path, header: header, parameters: parameters, block: block)
    }

    // get 完整请求
    @discardableResult func getPath(_ path: String,
                                    parameters: [String: Any]?,
                                    success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                    failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(false, path: path, parameters: parameters, success: success, failure: failure)
    }
    
    
    // MARK: - POST
    
    // post 无参数
    @discardableResult func postPath(_ path: String, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        return self.postPath(path, parameters: nil, block: block)
    }
    
    // post 有参数
    @discardableResult func postPath(_ path: String, parameters: [String: Any]?, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(true, path: path, parameters: parameters, block: block)
    }
    
    // post 有参数 有请求头
    @discardableResult func postPath(_ path: String, parameters: [String: Any]?, header: [String: String]?, block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(true, path: path, header: header, parameters: parameters, block: block)
    }
    
    // post 完整请求
    @discardableResult func postPath(_ path: String,
                                     parameters: [String: Any]?,
                                     success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                     failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.getDeal(true, path: path, parameters: parameters, success: success, failure: failure)
    }
    
    // post 有参数
    func postPath(_ path: String, parameters: [String: Any]?, progress: @escaping((Progress)->Void), block: ((Any?, NSError?)->Void)?) {
        
        /// 上传数据的网络延时设置时长为1分钟
        self.setTimeoutInterval(60)
        
        var header: [String: String] = [String: String]()
        
        if FishUserInfo.token() != "" {
            header["authorization"] = FishUserInfo.token()
        }
        
        self.manager.request(path, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .downloadProgress(closure: progress)
            .responseJSON(completionHandler: { (response) in
                
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    block?(responseObject, nil)
                    
                }, failure: { (task, error) in
                    
                    block?(nil, error)
                })
            })
    }
    
    
    // MARK: - upload
    
    // 上传图片Post
    
    // 上传图片Post
    @discardableResult func postPath(_ path: String,
                                     parameters: [String: Any]?,
                                     constructingBodyWithBlock: @escaping ((MultipartFormData) -> Void),
                                     progress: ((Progress) -> Void)?,
                                     block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        return self.postPath(path, parameters: parameters, constructingBodyWithBlock: constructingBodyWithBlock, progress: progress, success: { (task, obj) in
            
            block?(obj, nil)
            
        }) { (task, error) in
            
            block?(nil,  error)
            
        }
    }
    
    // 上传图片Post
    @discardableResult func postPath(_ path: String,
                                     parameters: [String: Any]?,
                                     constructingBodyWithBlock: @escaping ((MultipartFormData) -> Void),
                                     success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                     failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask?{
        return self.postPath(path, parameters: parameters, constructingBodyWithBlock: constructingBodyWithBlock, progress: nil, success: success, failure: failure)
    }
    
    // 上传图片Post
    @discardableResult func postPath(_ path: String,
                                     parameters: [String: Any]?,
                                     constructingBodyWithBlock: @escaping ((MultipartFormData) -> Void),
                                     progress: ((Progress) -> Void)?,
                                     success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                     failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask?{
        
        // 判断网络是否连接，直接回调网路错误
        if !connectedToNetwork() {
            failure?(nil, NSError.init(domain: "com.sm.neterror", code: -1009, userInfo: nil))
            return nil
        }
        
        self.openNetworkActivityIndicator()
        
        /// 上传数据的网络延时设置时长为1分钟
        STApi.setTimeoutInterval(60)
        
        var header: [String: String] = [String: String]()
        
        if FishUserInfo.token() != "" {
            header["authorization"] = FishUserInfo.token()
        }
 
        
        // 开始 SMJRLog 网络日志收集
        //        SMJRLog.recordNetworkRequestTime(path)
        
        //开始上传
        manager.upload(multipartFormData: constructingBodyWithBlock, usingThreshold: UInt64(String.Encoding.utf8.rawValue), to: path, method: HTTPMethod.post, headers: header) { [weak self](encodingResult) in
            switch encodingResult {
                
            case .success(request: let request, streamingFromDisk: _ , streamFileURL: _):
                
                //上传进度回调
                request.uploadProgress(closure: { (currProgress) in
                    progress?(currProgress)
                })
                
                //上传结果回调
                request.responseJSON(completionHandler: { (response) in
                    
                    self?.dealResult(response: response, success: { (task, responseObject) in
                        
                        self?.closeNetworkActivityIndicator()
                        success?(task, responseObject)
                        
                    }, failure: { (task, error) in
                        
                        self?.closeNetworkActivityIndicator()
                        failure?(task, error)
                    })
                })
                
            case .failure(let error):
                
                self?.closeNetworkActivityIndicator()
                failure?(nil, error as NSError)
                
            }
        }
        
        return nil
    }
    // 上传图片
    func uploadImage(url: String, parameters: Dictionary<String, Any>?, data: Data, block: ((Any?, Error?) -> Void)?) {
        
        let headers = ["content-type": "multipart/form-data"]
        
        manager.upload(multipartFormData: { (multipartData) in
            
            multipartData.append(data, withName: "image", fileName: "uploadImage", mimeType: "image/jpeg")
            
            for param in (parameters ?? Dictionary<String, Any>()) {
                
                if let data = (param.value as? String)?.data(using: .utf8) {
                    
                    multipartData.append(data, withName: param.key)
                }
            }
            
        }, usingThreshold: UInt64(String.Encoding.utf8.rawValue), to: url, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                
                request.responseJSON(completionHandler: { (response) in
                    
                    block?(response.result.value, nil)
                })
                
            case .failure(let error):
                
                block?(nil, error)
            }
        }
    }
    
    // MARK: - retray
    
    @discardableResult func getPath(_ path: String,
                                    retryCount: Int,
                                    parameters: [String: Any]?,
                                    isCache: Bool,
                                    success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                    failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask? {
        
        // 判断网络是否连接，直接回调网路错误
        if !connectedToNetwork() {
            failure?(nil, NSError.init(domain: "com.sm.neterror", code: -1009, userInfo: nil))
            return nil
        }
        
        self.openNetworkActivityIndicator()
        
        if isCache {
            return self.getPath(path, parameters: parameters, success: success, failure: failure)
        }
        
        if let url = URL.init(string: path) {
            URLCache.shared.removeCachedResponse(for: URLRequest.init(url: url))
        }
        
        var header: [String: String] = [String: String]()
        
        if FishUserInfo.token() != "" {
            header["authorization"] = FishUserInfo.token()
        }
        
        // 开始 SMJRLog 网络日志收集
        //        SMJRLog.recordNetworkRequestTime(path)
        
        manager.request(path, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            self.dealResult(response: response, success: { (task, responseObject) in
                
                success?(task, responseObject)
                
            }, failure: { (task, error) in
                
                failure?(task, error)
                
            })
        }
        
        return nil
    }
    
    @discardableResult func getPath(_ path: String,
                                    parameters: [String: Any]?,
                                    isCache: Bool,
                                    success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                    failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask? {
        
        if !isCache {
            if let url = URL.init(string: path) {
                URLCache.shared.removeCachedResponse(for: URLRequest.init(url: url))
            }
        }
        return self.getPath(path,
                            parameters: parameters,
                            success: success,
                            failure: failure)
    }
    
    
    // MARK: - Deal
    
    @discardableResult fileprivate func getDeal(_ post: Bool,
                                                path: String,
                                                parameters: [String: Any]?,
                                                success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                                failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) -> URLSessionDataTask? {
        
        // 判断网络是否连接，直接回调网路错误
        if !connectedToNetwork() {
            failure?(nil, NSError.init(domain: "com.sm.neterror", code: -1009, userInfo: nil))
            return nil
        }
        
        self.openNetworkActivityIndicator()
        
        // 默认是表单格式
        let encoding: ParameterEncoding = self.contentType
        
        var request: DataRequest?
        
        var header: [String: String] = [String: String]()
        
        if FishUserInfo.token() != "" {
            header["authorization"] = FishUserInfo.token()
        }
        
        if post {
            
            request = manager.request(path, method: HTTPMethod.post, parameters: parameters, encoding: encoding, headers: header).responseJSON(completionHandler: { (response) in
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    success?(task, responseObject)
                    
                }, failure: { (task, error) in
                    
                    failure?(task, error)
                    
                })
            })
            
        }else {
            request = manager.request(path, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    success?(task, responseObject)
                    
                }, failure: { (task, error) in
                    
                    failure?(task, error)
                    
                })
            })
        }
        
        return request?.task as? URLSessionDataTask
    }
    
    @discardableResult fileprivate func getDeal(_ post: Bool,
                                                path: String,
                                                header: [String: String]?,
                                                parameters: [String: Any]?,
                                                block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        // 判断网络是否连接，直接回调网路错误
        if !connectedToNetwork() {
            block?(nil, NSError.init(domain: "com.sm.neterror", code: -1009, userInfo: nil))
            return nil
        }
        
        self.openNetworkActivityIndicator()
        
        // 默认是表单格式
        let encoding: ParameterEncoding = self.contentType
        
        var request: DataRequest?
        
        var requestHeader: [String: String] = header ?? [String: String]()
        
        if let token = requestHeader["token"] {
            requestHeader["authorization"] = token
        }
        else if FishUserInfo.token() != "" {
            requestHeader["authorization"] = FishUserInfo.token()
        }
        
        if post {
            
            request = manager.request(path, method: HTTPMethod.post, parameters: parameters, encoding: encoding, headers: requestHeader).responseJSON(completionHandler: { (response) in
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    block?(responseObject, nil)
                    
                }, failure: { (task, error) in
                    
                    block?(nil, error)
                    
                })
            })
            
        }else {
            request = manager.request(path, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    block?(responseObject, nil)
                    
                }, failure: { (task, error) in
                    
                    block?(nil, error)
                    
                })
            })
        }
        
        return request?.task as? URLSessionDataTask
    }

    @discardableResult fileprivate func getDeal(_ post: Bool,
                                                path: String,
                                                parameters: [String: Any]?,
                                                block: ((Any?, NSError?)->Void)?) -> URLSessionDataTask? {
        
        // 判断网络是否连接，直接回调网路错误
        if !connectedToNetwork() {
            block?(nil, NSError.init(domain: "com.sm.neterror", code: -1009, userInfo: nil))
            return nil
        }
        
        self.openNetworkActivityIndicator()
        
        //默认是表单格式
        let encoding: ParameterEncoding = self.contentType
        
        var request: DataRequest?
        
        var header: [String: String] = [String: String]()
        
        if FishUserInfo.token() != "" {
            header["authorization"] = FishUserInfo.token()
        }
        
        if post {
            
            request = manager.request(path, method: HTTPMethod.post, parameters: parameters, encoding: encoding, headers: header).responseJSON(completionHandler: { (response) in
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    block?(responseObject, nil)
                    
                }, failure: { (task, error) in
                    
                    block?(nil, error)
                    
                })
            })
            
        }else {
            request = manager.request(path, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                
                self.dealResult(response: response, success: { (task, responseObject) in
                    
                    block?(responseObject, nil)
                    
                }, failure: { (task, error) in
                    
                    block?(nil, error)
                    
                })
            })
        }
        
        return request?.task as? URLSessionDataTask
    }
    
    // MARK: - check net connected
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        // For Swift 3, replace the last two lines by
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // 处理网络请求结果
    fileprivate func dealResult(response: DataResponse<Any>,
                                success: ((_ task: URLSessionDataTask?, _ responseObject: Any?)->Void)?,
                                failure: ((_ task: URLSessionDataTask?, _ error: NSError?)->Void)?) {
        
        if response.error == nil{
            closeNetworkActivityIndicator()
            success?(nil, response.result.value)
        }else{
            self.closeNetworkActivityIndicator()
            failure?(nil, response.error as NSError?)
        }
    }
    
    fileprivate func openNetworkActivityIndicator() {
        mainSafe {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    fileprivate func closeNetworkActivityIndicator() {
        mainSafe {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    fileprivate func mainSafe(block: @escaping ()->Void) {
        if Thread.current.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
    
}
extension STApi: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 || response.statusCode == 403 {
            completion(true, 5.0) // 5秒后重试
        } else {
            completion(false, 0.0) // 不重连
        }
    }
}
