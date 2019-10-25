//
//  AppDelegate+extension.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/24.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation

// MARK: - Login TabBar 切换
extension Notification.Name {
    
    public static let AlterLoginToRootViewController: Notification.Name = Notification.Name.init("AlterLoginToRootViewController")
    
    public static let AlterTabBarToRootViewController: Notification.Name = Notification.Name.init("AlterTabBarToRootViewController")
    
}

extension AppDelegate {
    
    /// 配置接受更改 KeyWindow RootViewController 的通知
    func setRootAlterNotification() {
        DispatchQueue.global().async {
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.alterRootToLogin(notification:)), name: NSNotification.Name.AlterLoginToRootViewController, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.alterRootToTabBar(notification:)), name: NSNotification.Name.AlterTabBarToRootViewController, object: nil)
            /// 只要是通过 SMURLResponseProtocol 解析类解析的 tokenFail 都会发送此通知
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.alterRootToLogin(notification:)), name: NSNotification.Name.FishHTTPResponseParseTokenFail, object: nil)
        }
    }
    
    /// 切换到登录
    func alterRootToLogin(notification: Notification) {
        MainAsync {
            objc_sync_enter(self)
            /// 根视图已经是 Login 则不用再次更改
            if let na = FishKeyWindow().rootViewController as? FishNavigationController, let _ = na.viewControllers.first as? LoginViewController {
                return
            }
            self.switchRootToLogin()
            objc_sync_exit(self)
        }
    }
    
    func switchRootToLogin() {
        FishKeyWindow().rootViewController = FishNavigationController.init(rootViewController: LoginViewController())
    }
    
    /// 切换到 TabBar
    func alterRootToTabBar(notification: Notification) {
        let parmas = notification.userInfo as? [String: Any]
        
        MainAsync {
            self.switchRootToTabBar(parmas)
        }
    }
    
    func switchRootToTabBar(_ params:[String: Any]?) {
        let tabBar: FishTabBarController = FishTabBarController(params: params)
        FishKeyWindow().rootViewController =  FishNavigationController.init(rootViewController:tabBar)
        
    }
}
