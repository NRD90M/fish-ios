//
//  AddOrEditTimerClockViewController.swift
//  fish-ios
//  创建或编辑定时任务
//  Created by caiwenshu on 2019/11/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import ObjectMapper

enum TimeIntervalType: String {
    case day
    case week
    case month
}

enum PageViewModel: Int {
    case create
    case edit
}

class AddOrEditTimerClockViewController: FishPreViewController {

    @IBOutlet weak var feederWeightTextField:UITextField!
    
    @IBOutlet weak var perDayView:UIView!
    @IBOutlet weak var perWeekView:UIView!
    @IBOutlet weak var perMonthView:UIView!
    
    @IBOutlet weak var monthView:UIView!
    @IBOutlet weak var weekView:UIView!
    
    @IBOutlet weak var monthDisplayLabel:UILabel!
    @IBOutlet weak var weekDisplayLabel:UILabel!
    
    @IBOutlet weak var weekSelectViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var monthSelectViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var executeDisplayLabel:UILabel!
    
    @IBOutlet weak var deviceDisplayLabel:UILabel!
    
    @IBOutlet weak var durationView:UIView!
    @IBOutlet weak var weightView:UIView!
    @IBOutlet weak var durationDisplayLabel:UILabel!
    @IBOutlet weak var durationSelectViewHeight:NSLayoutConstraint!
    @IBOutlet weak var weightSelectViewHeight:NSLayoutConstraint!
    
    var selectedSceneModel:PondSceneModel?
    
    var client: FishMainApi = FishMainApi()
    
    var intervalType:TimeIntervalType = .day
    var pageModel:PageViewModel = .create
    
    var planInfoModel:PlanInfoModel = PlanInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加定时"
        
        // Do any additional
        self.feederWeightTextField.layer.borderColor = UIColor.colorWithHexString("#F1F3F4")?.cgColor
        
        // 6ECFFF 选中蓝
        // E3E5E6 灰白
        self.feederWeightTextField.isAvoidKeyBoardEnable = true
        self.feederWeightTextField.avoidKeyBoardDistance = 80.0
        
        if pageModel == .create {
            self.planInfoModel.per = self.intervalType.rawValue
        } else {
            
            let deleteItem = UIBarButtonItem.init(title: "删除", style: UIBarButtonItemStyle.plain, target: self, action:#selector(deleteButtonTouchUpInSide))
            
            deleteItem.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem = deleteItem
            
        }
        self.refreshData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetPlanInfoModel(_ model:PlanInfoModel, _ viewModel:PageViewModel) {
        
        if let plan = Mapper<PlanInfoModel>().map(JSON: model.toJSON()) {
          self.planInfoModel = plan
            
            if self.planInfoModel.per == "day" {
                    self.intervalType = .day
            }
            
            if self.planInfoModel.per == "week" {
                self.intervalType = .week
            }
            
            if self.planInfoModel.per == "month" {
                self.intervalType = .month
            }
            
        }
        
//        PlanInfoModel.init(map: )
        self.pageModel = viewModel
        
//        if self.planInfoModel.per == "day" {
//
//            self.intervalType = .day
//            selectedStyleForButton(self.perDayButton)
//            unselectedStyleForButton(self.perWeekButton)
//            unselectedStyleForButton(self.perMonthButton)
//
//        } else if self.planInfoModel.per == "week" {
//
//            self.intervalType = .week
//            unselectedStyleForButton(self.perDayButton)
//            selectedStyleForButton(self.perWeekButton)
//            unselectedStyleForButton(self.perMonthButton)
//        } else {
//            self.intervalType = .month
//            unselectedStyleForButton(self.perDayButton)
//            unselectedStyleForButton(self.perWeekButton)
//            selectedStyleForButton(self.perMonthButton)
//        }
        
    }
    
    
    @IBAction func perDayButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .day {
            return
        }
        
        self.intervalType = .day
        
        self.planInfoModel.per = self.intervalType.rawValue
        
        self.refreshData()
    }
    
    @IBAction func perWeekButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .week {
            return
        }
        
        self.intervalType = .week
        
        self.planInfoModel.per = self.intervalType.rawValue
        
        self.refreshData()
    }
    
    @IBAction func perMonthButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .month {
            return
        }
        
        self.intervalType = .month
        
        self.planInfoModel.per = self.intervalType.rawValue
        
        self.refreshData()
    }
    
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
//        self.client.
        
        self.view.endEditing(true)
        
        self.makeActivity(nil)
        
        let param:[String : Any] = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                    "plan":["id":self.planInfoModel.id as Any ,
                                            "per":self.planInfoModel.per  as Any  ,
                                            "day_of_month":self.planInfoModel.day_of_month  as Any ,
                                            "day_of_week":self.planInfoModel.day_of_week  as Any ,
                                            "hour":self.planInfoModel.hour  as Any ,
                                            "minute":self.planInfoModel.minute  as Any ,
                                            "second":self.planInfoModel.second  as Any ,
                                            "io_code":self.planInfoModel.io_code  as Any ,
                                            "io_type":self.planInfoModel.io_type  as Any ,
                                            "duration":self.planInfoModel.duration  as Any ,
                                            "enabled":self.planInfoModel.enabled  as Any ,
                                            "weight":self.planInfoModel.weight  as Any ]
        ]
        
        self.client.addPlan(params: param) { (data, error) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                    self.view.makeHint("定时添加成功")
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
    
    
    @IBAction func hourMinButtonTouchUpInSide(_ sender: Any)  {
        
        self.showHourMinPickerView(self.planInfoModel.hour ?? 0, self.planInfoModel.minute ?? 0 ,callback: { (hour, minute) in
            
            //确定按钮回调
            self.planInfoModel.hour = hour
            self.planInfoModel.minute = minute
          
            self.refreshData()
        })
        
    }
    
    @IBAction func monthDayButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSinglePickerView(self.planInfoModel.day_of_month ?? 0, SinglePickerType.monthDay)
        
    }

    @IBAction func weekDayButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSinglePickerView(self.planInfoModel.day_of_week ?? 0, SinglePickerType.weekDay)
        
    }
    
    @IBAction func deviceButtonTouchUpInSide(_ sender: Any)  {
        
        self.showDevicePickerView()
        
    }
    
    
    @IBAction func durationButtonTouchUpInSide(_ sender: Any)  {
        
        let duration = self.planInfoModel.duration ?? 0
        
        let (hour,minute) = millisecondToHourAndMinute(duration)
        
        // 运行时长
        self.showHourMinPickerView(hour, minute,callback: { (hour, minute) in
            
            //确定按钮回调
            self.planInfoModel.duration = hour * 60 * 60 * 1000 + minute * 60 * 1000
            
            self.refreshData()
        })
    }
    
    
    func millisecondToHourAndMinute(_ millisecond:Int) -> (Int, Int) {
        
        let second:Int = millisecond / 1000
        let minute:Int = second / 60
        let hour:Int = minute / 60
        
        let returnMin = minute - hour * 60
        
        return (hour, returnMin)
    }
    
    
    
    // Privates
    
    func removeRequest() {
        self.makeActivity(nil)
        
        let param = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                     "id":self.planInfoModel.id ?? "-"]
        
        self.client.removePlan(params: param) { (data, error) in
            
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
    
    func unselectedStyleForButton(_ btn:UIView) {
        btn.backgroundColor = UIColor(hexString: "#E3E5E6")
    }
    
    func selectedStyleForButton(_ btn:UIView) {
        btn.backgroundColor = UIColor(hexString: "#6ECFFF")
    }
    
    func showHourMinPickerView(_ hour:Int, _ min:Int, callback:@escaping (Int, Int) ->()) {
        
        let pickerVC = FishHourMinPickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.reset(hour: hour, minute: min)
        pickerVC.confirmCallBack = { (sHour :Int, sMinute:Int) in
           
            
            callback(sHour, sMinute)
        }
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    
    func showSinglePickerView(_ val:Int, _ type:SinglePickerType) {
        
        let pickerVC = SinglePickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.reset(val: val, type: type)
        
        pickerVC.confirmCallBack = { (val :Int, type:SinglePickerType) in
            //确定按钮回调
            switch type {
                
            case SinglePickerType.monthDay:
                self.planInfoModel.day_of_month = val
                self.refreshData()
                break
                
            case SinglePickerType.weekDay:
                self.planInfoModel.day_of_week = val
                self.refreshData()
                break
            }
        }
        
        self.present(pickerVC, animated: true, completion: nil)
    }
    
    func showDevicePickerView() {
        
        let pickerVC = DevicePickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        
        pickerVC.reset(code: self.planInfoModel.io_code)
        
        pickerVC.confirmCallBack = { (val :PondIOInfoModel) in
            //确定按钮回调
            self.planInfoModel.io_code = val.code
            self.planInfoModel.io_type = val.type
            self.planInfoModel.io_name = val.name
            
            self.refreshData()
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
    
    
    func refreshData() {
        // 刷新页面数据
        resetIntervalUI()
        
        self.deviceDisplayLabel.text = self.planInfoModel.io_name
        
        if let duration = self.planInfoModel.duration {
            let (hour,minute) = millisecondToHourAndMinute(duration)
            
            self.durationDisplayLabel.text = String(hour) + ":" + String(minute)
        } else {
            self.durationDisplayLabel.text = "请选择"
        }
        
        if let dayOfMonth = self.planInfoModel.day_of_month {
            self.monthDisplayLabel.text = String(dayOfMonth) + "号"
        } else {
             self.monthDisplayLabel.text = "请选择"
        }
        
        
        if let dayOfWeek = self.planInfoModel.day_of_week {
            self.weekDisplayLabel.text = FishDefine.weekDayToCHN(day: dayOfWeek)
        } else {
            self.weekDisplayLabel.text = "请选择"
        }
        
        if let excuteHour = self.planInfoModel.hour, let executeMinute = self.planInfoModel.minute {
            
             self.executeDisplayLabel.text = String(excuteHour) + "小时" + String(executeMinute) + "分钟"
        } else {
            self.executeDisplayLabel.text = "请选择"
        }
        
        if let weight = self.planInfoModel.weight {
            self.feederWeightTextField.text = String(weight)
        }
        
        // 投喂机
        if self.planInfoModel.io_type == "feeder" {
            
            self.durationSelectViewHeight.constant = 0
            self.weightSelectViewHeight.constant = 50
            
            self.durationView.isHidden = true
            self.weightView.isHidden = false
            
            self.planInfoModel.duration = nil
            
        } else {
            self.durationSelectViewHeight.constant = 50
            self.weightSelectViewHeight.constant = 0
            
            self.durationView.isHidden = false
            self.weightView.isHidden = true
            
            self.planInfoModel.weight = nil
        }
        
    }
    
    func resetIntervalUI() {
        
        if self.intervalType == .week {
            
            unselectedStyleForButton(self.perDayView)
            selectedStyleForButton(self.perWeekView)
            unselectedStyleForButton(self.perMonthView)
            
            self.planInfoModel.day_of_month = nil
            
            self.weekView.isHidden = false
            self.monthView.isHidden = true
            weekSelectViewHeight.constant = 50
            monthSelectViewHeight.constant = 0
            
        } else if (self.intervalType == .month) {
            
            self.intervalType = .month
            
            unselectedStyleForButton(self.perDayView)
            unselectedStyleForButton(self.perWeekView)
            selectedStyleForButton(self.perMonthView)
            
            self.planInfoModel.day_of_week = nil
            
            self.weekView.isHidden = true
            self.monthView.isHidden = false
            
            weekSelectViewHeight.constant = 0
            monthSelectViewHeight.constant = 50
            
        } else {
            selectedStyleForButton(self.perDayView)
            unselectedStyleForButton(self.perWeekView)
            unselectedStyleForButton(self.perMonthView)
            
            self.planInfoModel.day_of_month = nil
            self.planInfoModel.day_of_week = nil
            
            self.weekView.isHidden = true
            self.monthView.isHidden = true
            
            weekSelectViewHeight.constant = 0
            monthSelectViewHeight.constant = 0
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


extension AddOrEditTimerClockViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.planInfoModel.weight = Int(text)
        } else {
            self.planInfoModel.weight = nil
        }
    }
}
