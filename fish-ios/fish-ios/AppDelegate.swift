//
//  AppDelegate.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/14.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

/// 提供统一的获取 KeyWindow 的方法
public func FishKeyWindow() -> UIWindow {
    return _keyWindow
}
private var _keyWindow: UIWindow!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Logger 配置
        Logger.shared.setUpConfig()
        
        /// 配置网络日志收集
        AlamofireLoggers.shareInstance.addLogger(logger: FishAlamofireLogger())
        AlamofireLoggers.shareInstance.startLogging()
        
        /// 增加跳转通知
        setRootAlterNotification()
        
        /// set key window
        let keyWindow = UIWindow.init(frame: UIScreen.main.bounds)
        
        keyWindow.backgroundColor = UIColor.white
        
        self.window = keyWindow
        
        /// 配置全局 SMKeyWindow
        _keyWindow = keyWindow
        
        switchRootToLogin()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
//    func switchRootToLogin() {
//        FishKeyWindow().rootViewController = FishNavigationController.init(rootViewController: LoginViewController())
//    }
    
//    func switchRootToTabbar(_ params:[String: Any]?) {
//        let tabBar: FishTabBarController = FishTabBarController(params: params)
//        FishKeyWindow().rootViewController =  FishNavigationController.init(rootViewController:tabBar)
//
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

