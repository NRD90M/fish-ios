//
//  KKInputAvoidKeyboardManager.swift
//  KKInputAvoidKeyBoard
//
//  Created by 王铁山 on 2018/8/19.
//  Copyright © 2018年 wangtieshan. All rights reserved.
//

import Foundation

import UIKit

open class KKInputAvoidKeyboardManager: NSObject {
    
    /// 开启功能，默认开启
    open class func openFunc() {
        
    }
    
    /// 关闭功能，默认开启
    open class func closeFunc() {
        
    }
    
    open class func setup() {
        Manager.share.setup()
    }
    
    /// 是否显示日志
    open class func logEnable(enable: Bool) {
        
    }
}

private class Manager {
    
    static let share: Manager = Manager()
    
    /// 强制开启
    var forceOn: Bool = false
    
    /// 当前管理的视图
    weak var mView: UIView?
    
    /// APP 根视图界面初始 frame
    var rootFrame: CGRect?
    
    /// 键盘 frame
    var keyFrame: CGRect?
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.tfDidBegin(nf:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.tfDidEnd(nf:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.kbDidShow(nf:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.kbDidShow(nf:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.kbDidShow(nf:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Manager.kbDidHidden(nf:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func tfDidBegin(nf: Notification) {
        guard let tf = nf.object as? UITextField else {
            return
        }
        guard self.isNeedDeal(view: tf) else {
            /// 不能处理
            self.mView = nil
            return
        }
        /// 能处理，则更新管理的视图为 tf
        self.mView = tf
        
        self.adjustView()
    }
    
    @objc func tfDidEnd(nf: Notification) {

    }
    
    @objc func kbDidHidden(nf: Notification) {
        if let v = self.mView {
            self.mView = nil
            if let sc = self.dealScrollView(view: v) {
                /// 复原 UIScrollView
                if (sc.contentOffset.y + sc.frame.size.height > sc.contentSize.height) {
                    // 内容小于高度。则回归 0
                    if sc.contentSize.height < sc.frame.size.height {
                        sc.setContentOffset(CGPoint.init(x: sc.contentOffset.x, y: 0), animated: true)
                    } else {
                        // 滚动到最底部
                        sc.setContentOffset(CGPoint.init(x: sc.contentOffset.x, y: sc.contentSize.height - sc.frame.size.height), animated: true)
                    }
                }
            } else if let vcv = self.dealRootView(view: v) {
                UIView.animate(withDuration: 0.1) {
                    vcv.frame = UIScreen.main.bounds
                }
            }
        }
        self.keyFrame = nil
    }
    
    @objc func kbDidShow(nf: Notification) {
        guard let userInfo = nf.userInfo as? [String: Any] else {
            return
        }
        guard let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        // 键盘 frame
        let kFrame = frameValue.cgRectValue
        // 键盘 frame 改变进入此方法。但是键盘是因为消失而导致的 Frame 改变，则不处理
        if kFrame.origin.y == UIScreen.main.bounds.size.height {
            return
        }

        self.keyFrame = kFrame
        
        self.adjustView()
    }
    
    func adjustView() {
        guard let v = self.mView, let kFrame = self.keyFrame else {
            return
        }
        // 所在的窗口
        guard let window = v.inWindow() else {
            return
        }
        // 视图在窗口上的 frame
        let vFrame = v.inWindowFrame(window: window)
        guard vFrame != CGRect.zero else {
            return
        }
        // 键盘和输入框底部的距离
        var extra: CGFloat = 10
        if let tf = v as? UITextField {
            extra = CGFloat(tf.avoidKeyBoardDistance)
        } else if let tv = v as? UITextView {
            extra = CGFloat(tv.avoidKeyBoardDistance)
        }
        // 视图底部
        let vMaxY = vFrame.maxY + extra
        // 判断键盘是否遮挡
        if vMaxY < kFrame.origin.y {
            // 键盘没有遮挡，恢复 window rootVC view frame
        } else {
            // 键盘遮挡
            if let sc = self.dealScrollView(view: v) {
                sc.setContentOffset(CGPoint.init(x: sc.contentOffset.x, y: sc.contentOffset.y + vMaxY - kFrame.origin.y), animated: true)
            } else if let vcv = self.dealRootView(view: v) {
                UIView.animate(withDuration: 0.2) {
                    let size = UIScreen.main.bounds.size
                    vcv.frame = CGRect.init(x: 0, y: (kFrame.origin.y - vMaxY), width: size.width, height: size.height)
                }
            }
        }
    }
    
    /// 是否能够处理该视图
    func isNeedDeal(view: UIView) -> Bool {
        if self.forceOn {
            return true
        }
        if let tf = view as? UITextField, tf.isAvoidKeyBoardEnable {
            return (view.firstVC() as? UITableViewController) == nil
        } else if let tv = view as? UITextView, tv.isAvoidKeyBoardEnable {
            return (view.firstVC() as? UITableViewController) == nil
        }
        return false
    }
    
    /// 调整的 scrollView
    /// 1. 父视图查找
    /// 2. 不能超过 ViewController
    /// 3. 查找到第一个 scrollView
    func dealScrollView(view: UIView) -> UIScrollView? {
        func find(view: UIResponder?) -> (UIViewController?, UIScrollView?) {
            guard let next = view else {
                return (nil, nil)
            }
            if let sc = next as? UIScrollView {
                return (nil, sc)
            } else if let vc = next as? UIViewController {
                return (vc, nil)
            }
            return find(view: next.next)
        }
        let findResult = find(view: view.next)
        if let _ = findResult.0 {
            // 找到了 UIViewContorller，但是没有 scrollView
            return nil
        } else if let sc = findResult.1 {
            return sc
        }
        return nil
    }
    
    /// 处理的根视图
    func dealRootView(view: UIView) -> UIView? {
        guard let w = view.inWindow() else {
            return nil
        }
        return w
    }
}

extension Manager {
    
    fileprivate func rootWindow() -> UIWindow? {
        if let ww = UIApplication.shared.delegate?.window, let w = ww {
            return w
        } else if let k = UIApplication.shared.keyWindow {
            return k
        }
        return nil
    }
}

extension UIView {
    
    /// 当前视图在窗口上的位置
    func inWindowFrame(window: UIWindow?) -> CGRect {
        let ew = window ?? self.inWindow()
        if let w = ew {
            return self.convert(self.bounds, to: w)
        }
        return CGRect.zero
    }
    
    /// 获取视图所在的 UIWindow，通过各种方法查找
    func inWindow() -> UIWindow? {
        return self.findWindow(view: self)
    }
    
    func findWindow(view: UIView) -> UIWindow? {
        if let w = windowFindSuperView(view: self) {
            return w
        } else if let ww = UIApplication.shared.delegate?.window, let w = ww {
            return w
        } else if let k = UIApplication.shared.keyWindow {
            return k
        }
        return nil
    }

    /// 获取视图所在的 UIWindow，通过父视图的方法查找
    func windowFindSuperView(view: UIView?) -> UIWindow? {
        guard let v = view else {
            return nil
        }
        if let w = v as? UIWindow {
            return w
        }
        return self.windowFindSuperView(view: v.superview)
    }
    
    /// 获取指定视图所在的 UIViewController，查找第一个
    func firstVC() -> UIViewController? {
        return getResponderUntilVC(responder: self.next) as? UIViewController
    }
    
    func getResponderUntilVC(responder: UIResponder?) -> UIResponder? {
        guard let r = responder else {
            return nil
        }
        if let vc = r as? UIViewController {
            return vc
        }
        return getResponderUntilVC(responder: r.next)
    }
}








