//
//  AlamofireLoggers.swift
//  AlamofireLoggers
//
//  Created by 王铁山 on 2017/9/4.
//  Copyright © 2017年 king. All rights reserved.
//

import Foundation

import Alamofire

public protocol AlmofireLoggerProtocol {
    
    var id: String { get }
    
    var filterPredicate: NSPredicate? { get }
    
    func URLSessionTaskDidResume(task: URLSessionTask)
    
    func URLSessionTaskDidCancel(task: URLSessionTask)
    
    func URLSessionTaskDidSuspend(task: URLSessionTask)
    
    func URLSessionTaskDidComplete(task: URLSessionTask, content: Any?, error: Error?)
    
}


open class AlamofireLoggers {
    
    static let shareInstance: AlamofireLoggers = AlamofireLoggers()
    
    open var loggers: [AlmofireLoggerProtocol] = [AlmofireLoggerProtocol]()
    
    open func addLogger(logger: AlmofireLoggerProtocol) {
        self.removeLogger(logger: logger)
        self.loggers.append(logger)
    }
    
    open func removeLogger(logger: AlmofireLoggerProtocol) {
        if let index = self.loggers.index(where: {$0.id == logger.id}) {
            self.loggers.remove(at: index)
        }
    }
    
    public func startLogging() {
        
        self.stopLogging()
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestDidResume(notification:)), name: NSNotification.Name.Task.DidResume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestDidSuspend(notification:)), name: NSNotification.Name.Task.DidSuspend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestDidCancel(notification:)), name: NSNotification.Name.Task.DidCancel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestDidComplete(notification:)), name: NSNotification.Name.Task.DidComplete, object: nil)
    }
    
    public func stopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func requestDidResume(notification: Notification) {
        
        guard !self.loggers.isEmpty else { return }
        
        guard let request = notification.object as? Request, let task = request.task else { return }
        
        for logger in self.loggers {
            
            if let predicate = logger.filterPredicate, predicate.evaluate(with: task) {
                logger.URLSessionTaskDidResume(task: task)
            } else {
                logger.URLSessionTaskDidResume(task: task)
            }
        }
    }
    
    @objc func requestDidSuspend(notification: Notification) {
        
        guard !self.loggers.isEmpty else { return }
        
        guard let request = notification.object as? Request, let task = request.task else { return }
        
        for logger in self.loggers {
            
            if let predicate = logger.filterPredicate, predicate.evaluate(with: task) {
                logger.URLSessionTaskDidSuspend(task: task)
            } else {
                logger.URLSessionTaskDidSuspend(task: task)
            }
        }
    }
    
    @objc func requestDidCancel(notification: Notification) {
        
        guard !self.loggers.isEmpty else { return }
        
        guard let request = notification.object as? Request, let task = request.task else { return }
        
        for logger in self.loggers {
            
            if let predicate = logger.filterPredicate, predicate.evaluate(with: task) {
                logger.URLSessionTaskDidCancel(task: task)
            } else {
                logger.URLSessionTaskDidCancel(task: task)
            }
        }
    }
    
    @objc func requestDidComplete(notification: Notification) {
        
        guard !self.loggers.isEmpty else { return }
        
        guard let sessionDelegate = notification.object as? Alamofire.SessionDelegate, let userinfo = notification.userInfo, let task = userinfo[Notification.Key.Task] as? URLSessionTask else {
            return
        }
        
        guard let data = sessionDelegate[task]?.delegate.data  else { return }
        
        var content: Any?
        
        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) {
            content = jsonObj
        } else {
            content = String.init(data: data, encoding: String.Encoding.utf8)
        }
        
        for logger in self.loggers {
            
            if let predicate = logger.filterPredicate, predicate.evaluate(with: task) {
                logger.URLSessionTaskDidComplete(task: task, content: content, error: task.error)
            } else {
                logger.URLSessionTaskDidComplete(task: task, content: content, error: task.error)
            }
        }
    }

}









