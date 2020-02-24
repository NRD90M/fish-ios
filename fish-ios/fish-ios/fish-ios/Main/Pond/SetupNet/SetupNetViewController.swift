//
//  SetupNetViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2020/2/21.
//  Copyright © 2020 caiwenshu. All rights reserved.
//

import UIKit
import NetworkExtension //导入网络扩展框架
import SystemConfiguration.CaptiveNetwork

class SetupNetViewController: UIViewController {

    var client: FishMainApi = FishMainApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "配网配置"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_arrow_back"), style: .plain, target: self, action: #selector(dismissViewController(animated:)))
        
       
        let wifiInfo = getWifiInfo()
        NSLog("SSID(WiFi名称): \(wifiInfo.0)")
        NSLog("BSSID(Mac地址): \(wifiInfo.1)")
        let ssid = wifiInfo.0
        
        if ssid != "smart" {
             connectWifi()
        }
        
        
//        scanWifiInfos()
//        connectWifi()
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
    
    
    @IBAction func netConfigButtonTouchUpInside(_ sender: Any) {
        
        sendWIFISSIDAndPassPhraseToDevice()
        
        //        self.delegate?.editTrigger(data:unpackedData)
        
    }
    
    
    
    func sendWIFISSIDAndPassPhraseToDevice() {
        
        let url = "http://192.168.12.1:9999/onekey-net-config"
        
        var params = [String:String]()
        params["ssid"] = "HW"
        params["psk"] = "11111111"
        
        self.client.getPath(url, parameters: params) { (data, error) in
            print(data)
        }
        
//        NEHotspotHelper.register(options: <#T##[String : NSObject]?#>, queue: <#T##DispatchQueue#>, handler: <#T##NEHotspotHelperHandler##NEHotspotHelperHandler##(NEHotspotHelperCommand) -> Void#>)
    }

    //获取 WiFi 信息
    func getWifiInfo() -> (ssid: String, mac: String) {
        if let cfas: NSArray = CNCopySupportedInterfaces() {
            for cfa in cfas {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(cfa as! CFString)) {
                    if let ssid = dict["SSID"] as? String, let bssid = dict["BSSID"] as? String {
                        return (ssid, bssid)
                    }
                }
            }
        }
        return ("未知", "未知")
    }
//  https://www.jianshu.com/p/0119548fe386 需要主动申请故忽略该方法
//    func scanWifiInfos() {
//
//        var options = [String: NSObject]()
//        options[kNEHotspotHelperOptionDisplayName] = "Try Here" as NSObject?
//
//        NSLog("Lets register", "")
//
//        let queue = DispatchQueue.init(label: "Demo")
//
//        let returnType = NEHotspotHelper.register(options: options, queue: DispatchQueue.main) { (cmd) in
//
////            let netWork:NEHotspotNetwork
//            NSLog("Returned", "")
//
//            print(cmd)
//
//            if cmd.commandType == NEHotspotHelperCommandType.evaluate || cmd.commandType ==  NEHotspotHelperCommandType.filterScanList {
//
//                for network in cmd.networkList! {
//
//                    let wifiInfoString = "SSID:" + network.ssid + " CommandType:" + String(Float((cmd.commandType).rawValue))
//                    print(wifiInfoString)
//
//                    if network.ssid == "smart" {
//
//                        network.setConfidence(NEHotspotHelperConfidence.high)
//                        let response = cmd.createResponse(NEHotspotHelperResult.success)
//                        print(response)
//
//                        response.setNetworkList([network])
//                        response.setNetwork(network)
//                        response.deliver()
//                    }
//                }
//            }
//        }
//
//
//        print(returnType)
//    }
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
