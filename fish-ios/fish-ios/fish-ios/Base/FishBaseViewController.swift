//
//  FishBaseViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/24.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class FishBaseViewController: UIViewController {

    // MARK: - 处理状态栏颜色问题，高效快捷
    open var statusBarStyle: UIStatusBarStyle = .default
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    open func setNavigationItemBackButtonTitle(title: String?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: title ?? "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /// 登录过期
    open func loginTimeOut() {
        NotificationCenter.default.post(name: NSNotification.Name.AlterLoginToRootViewController, object: true)
    }
}


class FishPreViewController: FishBaseViewController {
    
    
   
    /// 展示一个 loading
    /// 状体使用 isRequesting
    /// - Parameter message: 展示 loading 中的文本
    func makeActivity(_ message: String?) {
        SafeMain { self.view.makeActivity(title: message) }
    }
    
    /// 隐藏 loading
    func hiddenActivity() {
        SafeMain { self.view.hiddenActivity() }
    }
    
//    func requestingAlter(_ reqesting: Bool) {
//        if reqesting {self.makeActivity(nil)}
//        else { self.hiddenActivity() }
//    }
//
//    func loadingAlter(_ loading: Bool) {
//        if loading {self.makeActivity(nil)}
//        else { self.hiddenActivity() }
//    }
    
//    func sourceDataAlter(_ flag: Int) {}
    
//    func errorShow(_ error: SMError?) {
//        guard let er = error else { return }
//        if er.isTokenInvalidError() { self.loginTimeOut() }
//        else { self.showMessage(error?.showMessage) }
//    }
    
    func showMessage(_ message: String?) {
        SafeMain { self.view.makeHint(message) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


