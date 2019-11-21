//
//  VerifyCodeTimer.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation


public protocol VerifyCodeTimerDelegate: class {
    
    func verifyCodeTimerFinsh()
    
    func verifyCodeTimerUpdate(leftTime: Int)
}

/*
 当用户将APP退到后台或杀掉重新启动时，保证发送时间能够须接。保证指定时间(60秒)内只发送一次验证码
 */
open class VerifyCodeTimer {
    
    /// 存储上次发送验证码时间
    private var lastTimeKey: String!
    
    /// 存储上次发送验证码剩余时间
    private var leftTimeKey: String!
    
    /// delegate
    public weak var delegate: VerifyCodeTimerDelegate?
    
    /// 验证码剩余时间
    private var codeLeftTime: Int = 60
    
    /// 验证码发送间隔时间
    open var codeAllTime: Int = 60
    
    
    /// 构造方法
    /// uuid: 唯一标识，用来区分验证码的使用者
    /// - Parameter uuid: 唯一标识
    init(uuid: String) {
        self.leftTimeKey = "VERIFYCODETIME_".appending(uuid).appending("_LEFTTIMEKEY")
        self.lastTimeKey = "VERIFYCODETIME_".appending(uuid).appending("_LASTTIMEKEY")
    }
    
    /// 是否定时器仍然在进行
    final public func isTimerRunning() -> Bool {
        
        guard let lastTime = UserDefaults.standard.string(forKey: lastTimeKey) else { return false }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        
        guard let lastDate = dateFormatter.date(from: lastTime) else { return false}
        
        // 当前时间距离上次结束时间
        let timeInterval = Date().timeIntervalSince(lastDate)
        
        // 上次结束时剩余时间
        let leftTime = UserDefaults.standard.integer(forKey: leftTimeKey)
        
        return leftTime > 0 && (Int(timeInterval) < leftTime)
    }
    
    final public func continueTimer() {
        self.timeMiss()
    }
    
    /// 开始验证码
    open func beginVerifyCodeTimer() {
        self.recordCodeTime(self.codeLeftTime)
        self.delegate?.verifyCodeTimerUpdate(leftTime: self.codeLeftTime)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {[ weak self] in
            if let wSelf = self {
                wSelf.timeMiss()
            }
        }
    }
    
    fileprivate func timeMiss() {
        
        self.setCurrentCodeLeftTime()
        
        if self.codeLeftTime <= 0 {
            self.delegate?.verifyCodeTimerFinsh()
            self.codeLeftTime = codeAllTime
            UserDefaults.standard.removeObject(forKey: lastTimeKey)
            UserDefaults.standard.removeObject(forKey: leftTimeKey)
            return
        }
        self.delegate?.verifyCodeTimerUpdate(leftTime: self.codeLeftTime)
        self.recordCodeTime(self.codeLeftTime)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {[ weak self] in
            self?.timeMiss()
        }
    }
    
    /**
     检查上次发送验证码剩余的时间，是否在60秒内
     */
    private func setCurrentCodeLeftTime() {
        
        guard let lastTime = UserDefaults.standard.string(forKey: lastTimeKey) else { return }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        
        guard let lastDate = dateFormatter.date(from: lastTime) else { return }
        
        // 当前时间距离上次结束时间
        let timeInterval = Date().timeIntervalSince(lastDate)
        
        // 上次结束时剩余时间
        let leftTime = UserDefaults.standard.integer(forKey: leftTimeKey)
        
        if leftTime > 0 && (Int(timeInterval) < leftTime) {
            self.codeLeftTime = leftTime - Int(timeInterval)
        } else {
            self.codeLeftTime = 0
        }
    }
    
    /**
     记录发送验证码的时间，存储剩余时间
     */
    private func recordCodeTime(_ leftTime: Int) {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let curDate = dateFormatter.string(from: Date())
        
        // 保存最后一次时间
        UserDefaults.standard.setValue(curDate, forKey: self.lastTimeKey)
        // 保存剩余时间
        UserDefaults.standard.set(leftTime, forKey: self.leftTimeKey)
        UserDefaults.standard.synchronize()
    }
}
