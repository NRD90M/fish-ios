//
//  SetupNetViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2020/2/21.
//  Copyright © 2020 caiwenshu. All rights reserved.
//

import UIKit
import NetworkExtension //导入网络扩展框架

class SetupNetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "配网配置"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_arrow_back"), style: .plain, target: self, action: #selector(dismissViewController(animated:)))
        
        connectWifi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissViewController(animated:Bool) {
        self.dismiss(animated: true, completion: nil)
    }

    //核心代码（@available(iOS 11.0, *)）
    func connectWifi(){
        
        let urlStr:String = "App-Prefs:root=WIFI"
        let url = NSURL.init(string: urlStr)
        
        if #available(iOS 11.0, *) {
            let hcg =  NEHotspotConfiguration(ssid: "smart", passphrase: "", isWEP: false)
            NEHotspotConfigurationManager.shared.apply(hcg) { (erro) in
                if erro == nil {
                    print("链接wifi成功")
                }else{
                    print(erro?.localizedDescription ?? "未知错误")
                }
            }
        } else if #available(iOS 10.0, *) {
            // 跳转至设置界面
             UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
             UIApplication.shared.openURL(url! as URL)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
