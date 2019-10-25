//
//  FishAlamofireLogger.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/25.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation

class FishAlamofireLogger: AlmofireLoggerProtocol {
    
    var id: String = "FishAlamofireLogger"
    
    var filterPredicate: NSPredicate?
    
    init() {
      
    }
    
    func URLSessionTaskDidResume(task: URLSessionTask) {
        
        if let info = self.getSimpleConsolByTask(task: task) {
            let content = NSString.init(format: "DidResume: %@\n%@", (info["URL"] as? String) ?? "", info)
            FLogInfo(content as String)
        }
    }
    
    func URLSessionTaskDidCancel(task: URLSessionTask) {
        
        if let info = self.getSimpleConsolByTask(task: task) {
            let content = NSString.init(format: "DidCancel: %@\n%@", (info["URL"] as? String) ?? "", info)
            FLogInfo(content as String)
        }
    }
    
    func URLSessionTaskDidSuspend(task: URLSessionTask) {
        
        if let info = self.getSimpleConsolByTask(task: task) {
            let content = NSString.init(format: "DidSuspend: %@\n%@", (info["URL"] as? String) ?? "", info)
            FLogInfo(content as String)
        }
    }
    
    func URLSessionTaskDidComplete(task: URLSessionTask, content: Any?, error: Error?) {
        /*
         if let info = self.getConsolByTask(task: task, content: content) {
         let content = NSString.init(format: "DidComplete: %@\n%@", (info["URL"] as? String) ?? "", info)
         DDLogUtil.logInfo(content as String)
         }
         */
        
        if let info = getCleanlilyPrintByTask(task: task, content: content) {
            let content = NSString.init(format: "⏬⏬⏬\n%@\n\n", info)
            FLogInfo(content as String)
        }
    }
    
    func getSimpleConsolByTask(task: URLSessionTask) -> [String: Any]? {
        
        guard let request = task.originalRequest else {
            return nil
        }
        
        if request.url?.absoluteString.contains("oss/api/entry") ?? false {
            return nil
        }
        
        var body: String?
        
        if let b = request.httpBody {
            
            body = String.init(data: b, encoding: String.Encoding.utf8)
        }
        
        var result = [String: Any]()
        
        result["HTTPMethod"] = request.httpMethod ?? ""
        
        result["URL"] = request.url?.absoluteString ?? ""
        
        result["allHTTPHeaderFields"] = request.allHTTPHeaderFields
        
        result["body"] = body ?? ""
        
        result["KKType"] = "发出的网络请求 URL: "
        
        return result
    }
    
    // 临时打印
    func getCleanlilyPrintByTask(task: URLSessionTask, content: Any?) -> [String: Any]? {
        
        guard let request = task.originalRequest else {
            return nil
        }
        
        var body: String?
        
        if let b = request.httpBody {
            
            body = String.init(data: b, encoding: String.Encoding.utf8)
        }
        
        var result = [String: Any]()
        
        result["URL"] = request.url?.absoluteString ?? ""
        
        result["Header"] = request.allHTTPHeaderFields ?? ""
        
        result["body"] = body ?? ""
        
        result["content"] = content
        
        if let e = task.error {
            
            result["error"] = e
        }
        
        if let url = request.url?.absoluteString {
            if url.contains("upload/fileUpload") || url.contains("upload/fileDownload") {
                result["body"] = "内容太多先屏蔽掉"
            }
        }
        
//        self.dealErrorLogToUMeng(url: request.url?.absoluteString, content: content)
        
        return result
    }
    
    /// 处理错误信息到友盟
//    func dealErrorLogToUMeng(url: String?, content: Any?) {
//
//        guard let u = url else {
//            return
//        }
//
//        guard let c = URLComponents.init(string: u) else {
//            return
//        }
//
//        guard let data = content as? [String: Any] else {
//            return
//        }
//
//        guard let code = data["code"] as? String, code != "200" else {
//            return
//        }
//
//        let path = c.path.replacingOccurrences(of: "://", with: "_").replacingOccurrences(of: "/", with: "_")
//
//        SMAnalyticTool.event(eventId: "EV_NET_ERROR", attributes: [path: c.path])
//
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
