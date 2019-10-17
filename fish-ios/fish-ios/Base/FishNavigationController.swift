//
//  STNavigationController.swift
//  ShenmaEV
//
//  Created by cheng on 2018/6/14.
//  Copyright © 2018年 SHENMA NETWORK TECHNOLOGY (SHANGHAI) Co.,Ltd. All rights reserved.
//

import UIKit

class FishNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavbarAppearance()
    }
    
    fileprivate func setNavbarAppearance() {
        
        navigationBar.tintColor = UIColor.black
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage(named: "navigationbar_shadow")
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_arrow_back"), style: .plain, target: self, action: #selector(popViewController(animated:)))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        let topVC: UIViewController? = self.topViewController
        
        if let vc = topVC {
            return vc.preferredStatusBarStyle
        }
        
        return .default
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return self.topViewController
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
