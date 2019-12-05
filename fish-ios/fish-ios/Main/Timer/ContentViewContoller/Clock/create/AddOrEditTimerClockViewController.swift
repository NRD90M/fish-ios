//
//  AddOrEditTimerClockViewController.swift
//  fish-ios
//  创建或编辑定时任务
//  Created by caiwenshu on 2019/11/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

enum TimeIntervalType: Int {
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
    
    @IBOutlet weak var perDayButton:UIButton!
    @IBOutlet weak var perWeekButton:UIButton!
    @IBOutlet weak var perMonthButton:UIButton!
    
    @IBOutlet weak var weekMonthSelectViewHeight:NSLayoutConstraint!
    
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetPlanInfoModel(_ model:PlanInfoModel, _ viewModel:PageViewModel) {
        self.planInfoModel = model
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
        
        selectedStyleForButton(self.perDayButton)
        unselectedStyleForButton(self.perWeekButton)
        unselectedStyleForButton(self.perMonthButton)
        
        self.planInfoModel.day_of_month = nil
        self.planInfoModel.day_of_week = nil
        
        weekMonthSelectViewHeight.constant = 0
    }
    
    @IBAction func perWeekButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .week {
            return
        }
        
        self.intervalType = .week
        
        unselectedStyleForButton(self.perDayButton)
        selectedStyleForButton(self.perWeekButton)
        unselectedStyleForButton(self.perMonthButton)
        
        self.planInfoModel.day_of_month = nil
        
        weekMonthSelectViewHeight.constant = 44
    }
    
    @IBAction func perMonthButtonTouchUpInSide(_ sender: Any)  {
        
        if self.intervalType == .month {
            return
        }
        
        self.intervalType = .month
        
        unselectedStyleForButton(self.perDayButton)
        unselectedStyleForButton(self.perWeekButton)
        selectedStyleForButton(self.perMonthButton)
        
        self.planInfoModel.day_of_week = nil
        
        weekMonthSelectViewHeight.constant = 44
    }
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
//        self.client.
        self.makeActivity(nil)
        
        self.client.addPlan(params: self.planInfoModel.toJSON()) { (data, error) in
            
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
    
    @IBAction func cancelButtonTouchUpInSide(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func hourMinButtonTouchUpInSide(_ sender: Any)  {
        
        self.showHourMinPickerView(self.planInfoModel.hour ?? 0, self.planInfoModel.minute ?? 0)
        
    }
    
    @IBAction func monthDayButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSinglePickerView(self.planInfoModel.day_of_month ?? 0, SinglePickerType.monthDay)
        
    }

    @IBAction func weekDayButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSinglePickerView(self.planInfoModel.day_of_week ?? 0, SinglePickerType.weekDay)
        
    }
    
    // Privates
    func unselectedStyleForButton(_ btn:UIButton) {
        btn.backgroundColor = UIColor(hexString: "#E3E5E6")
    }
    
    func selectedStyleForButton(_ btn:UIButton) {
        btn.backgroundColor = UIColor(hexString: "#6ECFFF")
    }
    
    func showHourMinPickerView(_ hour:Int, _ min:Int) {
        
        let pickerVC = FishHourMinPickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.confirmCallBack = { (hour :Int, minute:Int) in
            //确定按钮回调
            self.planInfoModel.hour = hour
            self.planInfoModel.minute = minute
            
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
                break
                
            case SinglePickerType.weekDay:
                self.planInfoModel.day_of_week = val
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
            print(val.name)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
