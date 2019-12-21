//
//  DevicePickerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/5.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class DevicePickerViewController: UIViewController {

    //定义block
    typealias confirmBlock = (_ val :PondIOInfoModel) ->()
    //创建block变量
    var confirmCallBack:confirmBlock?
    
    var client: FishMainApi = FishMainApi()
    var ioDevicesList:[PondIOInfoModel] = []
    
    var selectedCode:String?
    
    @IBOutlet weak var devicePickerView:DevicePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = PondIOInfoModel()
        model.code = self.selectedCode
        self.devicePickerView.resetSelected(selectedModel: model, list: self.ioDevicesList)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset(code :String?) {
//        self.singlePickerView.resetSelected(val: val, type: type)
        self.selectedCode = code
    }
    
    // MARK: Actions
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
        
        if let callback = confirmCallBack{
            callback(self.devicePickerView.getSelectedInfoModel())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTouchUpInSide(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bgButtonTouchUpInSide(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startLoadingData(deviceMac:String, block:@escaping (_ success:Bool, _ error:String?)->Void) {
        
        self.client.getIOInfo(params: ["device_mac": deviceMac], callBack: { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                block(false, err.showMessage)
                return
            }
            if let d = data?.data, !d.isEmpty {
                self.ioDevicesList = d
                var enableDevicesList:[PondIOInfoModel] = []
                for model in d {
                    if let enable = model.enabled {
                        if (enable) {
                            enableDevicesList.append(model)
                        }
                    }
                }
                self.ioDevicesList = enableDevicesList
//                let selectedDeviceModel:PondIOInfoModel? = nil
                block(true, nil)
            } else {
                block(false, "数据获取失败，请稍后再试")
            }
            
        })
        
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
