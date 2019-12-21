//
//  AddOrEditTimerTriggerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/6.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import ObjectMapper

enum TriggerMonitorType: String {
    case o2
    case ph
    case water_temperature
}

class AddOrEditTimerTriggerViewController: FishPreViewController {

    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var o2View:UIView!
    @IBOutlet weak var phView:UIView!
    @IBOutlet weak var waterTemperatureView:UIView!
    
    @IBOutlet weak var valueTextField:UITextField!
    
    
    @IBOutlet weak var conditionDisplayLabel:UILabel!
    @IBOutlet weak var operactionDisplayLabel:UILabel!
    @IBOutlet weak var deviceDisplayLabel:UILabel!
    
    
    var intervalType:TriggerMonitorType = .water_temperature
    
    var selectedSceneModel:PondSceneModel?
    
    var client: FishMainApi = FishMainApi()
    
    var pageModel:PageViewModel = .create
    
    var triggerInfoModel:TriggerInfoModel = TriggerInfoModel()
    
    let conditionInitList:[PickViewItem] = [PickViewItem.init(code: ">", name: "大于"),
                                            PickViewItem.init(code: "<", name: "小于")]
    
    let operactionInitList:[PickViewItem] = [PickViewItem.init(code: "open", name: "开启"),
                                             PickViewItem.init(code: "close", name: "关闭")]
    override func viewDidLoad() {
        super.viewDidLoad()

         self.title = "添加触发"
        // Do any additional setup after loading the view.
        
        // Do any additional
        self.valueTextField.layer.borderColor = UIColor.colorWithHexString("#F1F3F4")?.cgColor
        
        // 6ECFFF 选中蓝
        // E3E5E6 灰白
        self.valueTextField.isAvoidKeyBoardEnable = true
        self.valueTextField.avoidKeyBoardDistance = 80.0
        
        
        self.scrollView.isUserInteractionEnabled = true
        // ScrollView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        if pageModel == .create {
            self.triggerInfoModel.monitor = self.intervalType.rawValue
        } else {
            
            let deleteItem = UIBarButtonItem.init(title: "删除", style: UIBarButtonItemStyle.plain, target: self, action:#selector(deleteButtonTouchUpInSide))
            
            deleteItem.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem = deleteItem
            
        }
        self.refreshData()
        
    }
    
    func doubleTapped() {
        // do something cool here
        self.scrollView.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetTriggerInfoModel(_ model:TriggerInfoModel, _ viewModel:PageViewModel) {
        
        if let plan = Mapper<TriggerInfoModel>().map(JSON: model.toJSON()) {
            self.triggerInfoModel = plan
            
            if self.triggerInfoModel.monitor == TriggerMonitorType.o2.rawValue {
                self.intervalType = .o2
            }
            
            if self.triggerInfoModel.monitor == TriggerMonitorType.ph.rawValue {
                self.intervalType = .ph
            }
            
            if self.triggerInfoModel.monitor == TriggerMonitorType.water_temperature.rawValue {
                self.intervalType = .water_temperature
            }
            
        }
        
        self.pageModel = viewModel
        
    }
    
    // o2，ph，water_temperature
    @IBAction func o2ButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .o2 {
            return
        }
        
        self.intervalType = .o2
        
        self.triggerInfoModel.monitor = self.intervalType.rawValue
        
        self.refreshData()
    }
    
    @IBAction func phButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .ph {
            return
        }
        
        self.intervalType = .ph
        
        self.triggerInfoModel.monitor = self.intervalType.rawValue
        
        self.refreshData()
        
    }
    
    @IBAction func waterTemperatureButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .water_temperature {
            return
        }
        
        self.intervalType = .water_temperature
    
        self.triggerInfoModel.monitor = self.intervalType.rawValue
        
        self.refreshData()
    }
    
    
    @IBAction func deviceButtonTouchUpInSide(_ sender: Any)  {
        
        self.showDevicePickerView()
        
    }
    
    @IBAction func conditionButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSingleCustomPickerView(selectVal: self.triggerInfoModel.condition, list: self.conditionInitList, callback: { (item) in
            
            self.triggerInfoModel.condition = item.code
            
            self.refreshData()
//            self.conditionForDisplay()
        })
    }
    
    
    @IBAction func operactionButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSingleCustomPickerView(selectVal: self.triggerInfoModel.operaction, list: self.operactionInitList, callback: { (item) in
            
            self.triggerInfoModel.operaction = item.code
            
            self.refreshData()
//            self.operactionForDisplay()
        })
    }
    
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
        //        self.client.
        
        
        self.view.endEditing(true)
        
        self.makeActivity(nil)
        
        let param:[String : Any] = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                    "trigger":["id":self.triggerInfoModel.id as Any ,
                                            "monitor":self.triggerInfoModel.monitor  as Any  ,
                                            "condition":self.triggerInfoModel.condition  as Any ,
                                            "condition_val":self.triggerInfoModel.condition_val  as Any ,
                                            "io_code":self.triggerInfoModel.io_code  as Any ,
                                            "io_name":self.triggerInfoModel.io_name  as Any ,
                                            "io_type":self.triggerInfoModel.io_type  as Any ,
                                            "operaction":self.triggerInfoModel.operaction  as Any ,
                                            "duration":self.triggerInfoModel.duration  as Any ,
                                            "enabled":self.triggerInfoModel.enabled  as Any ]
        ]
        
        self.client.addTrigger(params: param) { (data, error) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                    self.view.makeHint("触发添加成功")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
            
            self.view.makeHint("操作失败，请稍后再试")
        }
    }
    
    
    @IBAction func deleteButtonTouchUpInSide(_ sender: Any)  {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        let continueAction = UIAlertAction(title: "确认删除", style: .default) { [weak self] (action) in
            guard let wSelf = self else { return }
            
            wSelf.removeRequest()
        }
        actionSheet.addAction(continueAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTouchUpInSide(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Privates
    func removeRequest() {
        
        self.makeActivity(nil)
        
        let param = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                     "id":self.triggerInfoModel.id ?? "-"]
        
        self.client.removeTrigger(params: param) { (data, error) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                    self.view.makeHint("删除成功")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
            
            self.view.makeHint("操作失败，请稍后再试")
        }
    }
    
    func showDevicePickerView() {
        
        let pickerVC = DevicePickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        
        pickerVC.reset(code: self.triggerInfoModel.io_code)
        
        pickerVC.confirmCallBack = { (val :PondIOInfoModel) in
            //确定按钮回调
            self.triggerInfoModel.io_code = val.code
            self.triggerInfoModel.io_type = val.type
            self.triggerInfoModel.io_name = val.name
            
            self.refreshData()
//            print(val.name)
        }
        
        self.view.makeActivity()
        
        pickerVC.startLoadingData(deviceMac:self.selectedSceneModel?.deviceMac ?? "-") { (success, error) in
            
            self.view.hiddenActivity()
            
            if success {
                self.present(pickerVC, animated: true, completion: nil)
            } else {
                self.view.makeHint(error)
            }
        }
        
    }
    
    
    func showSingleCustomPickerView(selectVal:String?, list:[PickViewItem], callback:@escaping (PickViewItem) ->()) {
        
        let pickerVC = SingleCustomPickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        
        pickerVC.reset(val: selectVal, list: list)
        
        pickerVC.confirmCallBack = { (val :PickViewItem) in
            //确定按钮回调
            callback(val)
//            print(val.name)
        }
        
        self.present(pickerVC, animated: true, completion: nil)
        
    }
    

    func unselectedStyleForButton(_ btn:UIView) {
        btn.backgroundColor = UIColor(hexString: "#E3E5E6")
    }
    
    func selectedStyleForButton(_ btn:UIView) {
        btn.backgroundColor = UIColor(hexString: "#6ECFFF")
    }
    
    
    func conditionForDisplay() -> String? {
        
        let index = self.conditionInitList.index(where: { (info) -> Bool in
            return info.code == self.triggerInfoModel.condition
        })
        
        if let val = index {
            return self.conditionInitList[val].name
        }
        
        return nil
    }
    
    func operactionForDisplay() -> String? {
        
        let index = self.operactionInitList.index(where: { (info) -> Bool in
            return info.code == self.triggerInfoModel.operaction
        })
        
        if let val = index {
             return self.operactionInitList[val].name
        }
        
        return nil
        
    }
    
    func refreshData() {
        // 刷新页面数据
        resetIntervalUI()

        if let name =  self.triggerInfoModel.io_name {
            self.deviceDisplayLabel.text = name
        } else {
            self.deviceDisplayLabel.text = "请选择"
        }
        
        if let val = self.conditionForDisplay() {
            self.conditionDisplayLabel.text = val
        } else {
            self.conditionDisplayLabel.text = "请选择"
        }
        
        if let val = self.operactionForDisplay() {
            self.operactionDisplayLabel.text = val
        } else {
            self.operactionDisplayLabel.text = "请选择"
        }
        
        if let conditionVal = self.triggerInfoModel.condition_val {
            self.valueTextField.text = String(conditionVal)
        }
        
    }
    

    
    func resetIntervalUI() {
        
        if self.intervalType == .o2 {
            
            selectedStyleForButton(self.o2View)
            unselectedStyleForButton(self.phView)
            unselectedStyleForButton(self.waterTemperatureView)
            
            self.triggerInfoModel.monitor = self.intervalType.rawValue
            
        } else if (self.intervalType == .ph) {
            
            unselectedStyleForButton(self.o2View)
            selectedStyleForButton(self.phView)
            unselectedStyleForButton(self.waterTemperatureView)
            
            self.triggerInfoModel.monitor = self.intervalType.rawValue
            
        } else {
            
            unselectedStyleForButton(self.o2View)
            unselectedStyleForButton(self.phView)
            selectedStyleForButton(self.waterTemperatureView)
            
            self.triggerInfoModel.monitor = self.intervalType.rawValue
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
        
    }
}


extension AddOrEditTimerTriggerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.triggerInfoModel.condition_val = Double(text)
        } else {
            self.triggerInfoModel.condition_val = nil
        }
    }
}

