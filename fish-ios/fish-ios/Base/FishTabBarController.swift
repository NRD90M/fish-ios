//
//  STTabBarController.swift
//  ShenmaEV
//
//  Created by cheng on 2018/6/14.
//  Copyright © 2018年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//

import UIKit

/// STTabBarController中页面
///
/// - pond: 鱼塘
/// - carSource: 定时
/// - financial: 报警
/// - user: 我的
enum FishTabBarControllerPageType: Int {
    
    case pond

    case timer
    
    case alert
    
    case user
}

class FishTabBarController: UITabBarController {
    
    /// 创建 TabBar 时传递进来的参数。预留参数。
    /// 可根据此参数做一些额外的事情
    var params: [String: Any]
    
    var pond: FishNavigationController?
    
    var timer: FishNavigationController?
    
    var alert: FishNavigationController?
    
    var user: FishNavigationController?
    
    init(params: [String: Any]?) {
        self.params = params ?? [:]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.params = [:]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sm_prefersNavigationBarHidden = true

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.delegate = self;
        setTabbarAppearance()
        
        setupChildViewControllers(page: .pond)
        
    }
    
    fileprivate func setTabbarAppearance() {
        tabBar.tintColor = UIColor(netHex: 0x4a4a4a)
        tabBar.isTranslucent = false
    }
    
    /// 设置自控制器，含有缓存
    ///
    /// - Parameter page: 默认展示的界面
    public func setupChildViewControllers(page: FishTabBarControllerPageType) {
        
        var vcs: [FishNavigationController] = []
        
            if let pond = self.pond {
                vcs.append(pond)
            } else {
                let mall: PondViewController = PondViewController()
                setupChildViewController(mall, title: "首页", image: "icon_tabbar_timer", selectedImage: "icon_tabbar_timer")
                let mallNa = FishNavigationController(rootViewController: mall)
                vcs.append(mallNa)
                self.pond = mallNa
            }
       
        
        if let timer = self.timer {
            vcs.append(timer)
        } else {
            let shopCart: TimerViewController = TimerViewController()
            setupChildViewController(shopCart, title: "计划", image: "icon_tabbar_timer", selectedImage: "icon_tabbar_timer")
            let shopCartNa = FishNavigationController(rootViewController: shopCart)
            vcs.append(shopCartNa)
            self.timer = shopCartNa
        }
        
        if let alertNa = self.alert {
            vcs.append(alertNa)
        } else {
            let alertVC: AlertViewController = AlertViewController()
            setupChildViewController(alertVC, title: "店管家", image: "icon_tabbar_timer", selectedImage: "icon_tabbar_timer")
            let homeNa = FishNavigationController(rootViewController: alertVC)
            vcs.append(homeNa)
            self.alert = homeNa
        }
        
        if let userNa = self.user {
            vcs.append(userNa)
        } else {
            let user: UserViewController = UserViewController()
            setupChildViewController(user, title: "我的", image: "icon_tabbar_timer", selectedImage: "icon_tabbar_timer")
            let userNa = FishNavigationController(rootViewController: user)
            vcs.append(userNa)
            self.user = userNa
        }
        
        // 新的个数与当前的一致，则只更换数据源，不能改索引
         self.setViewControllers(vcs, animated: false)
        
    }
    
    func setupChildViewController(_ viewController: UIViewController, title: String, image: String, selectedImage: String) {
        
        viewController.tabBarItem.title = title
        viewController.title = title
        viewController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}

extension FishTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true;
        
    }
}

/// tabbar 红点
//extension FishTabBarController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        configMessageNoticeView()
//
//        STMessageNoticeView.refreshMessageCount()
//    }
//
//    func configMessageNoticeView() {
//        guard let navs = viewControllers else {
//            return
//        }
//        for (index, nav) in navs.reversed().enumerated() {
//            if let viewControlers = (nav as? UINavigationController)?.viewControllers {
//                for vc in viewControlers {
//                    if vc is STUserViewController {
//                        //防止重复添加：
//                        for subView in tabBar.subviews.reversed()[index].subviews {
//                            if subView is STMessageNoticeView {
//                                return
//                            }
//                        }
//                        let messageView = STMessageNoticeView.createTabbarPoint()
//                        tabBar.subviews.reversed()[index].addSubview(messageView)
//                    }
//                }
//            }
//        }
//    }
//}
