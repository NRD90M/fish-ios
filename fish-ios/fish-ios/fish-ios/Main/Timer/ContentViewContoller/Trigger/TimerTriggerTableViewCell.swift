//
//  TimerTriggerTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let TimerTriggerTableViewCellReuseID = "TimerTriggerTableViewCellReuseID"

protocol TimerTriggerTableViewCellDelegate : class {
    func disableOrEnableTrigger(enable:Bool, id:String)
    func editTrigger(data:TriggerInfoModel)
}

//enum TimeIntervalType: String {
//    case waterTemperature
//    case o2
//    case ph
//}

class TimerTriggerTableViewCell: UITableViewCell {

    @IBOutlet weak var openCloseButton:UIButton!
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var typeImageView:UIImageView!
    @IBOutlet weak var conditionLabel:UILabel! // 条件
    @IBOutlet weak var operactionLabel:UILabel! // 操作
    
    var data:TriggerInfoModel?
    
    weak var delegate: TimerTriggerTableViewCellDelegate?
    
//    weak var delegate: TimerClockTableViewCellDelegate?
    
    //{
    //    "io_name": "增氧机2",
    //    "io_type": "aerator",
    //    "io_enabled": false,
    //    "id": "cf92ad20-bc13-42a1-8bdd-9a72df875b74",
    //    "monitor": "o2",
    //    "condition": "<",
    //    "condition_val": 0.4,
    //    "io_code": "aerator2",
    //    "operaction": "open",
    //    "duration": null,
    //    "enabled": false
    //},
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.editButton.layer.borderColor = UIColor.colorWithHexString("#3F97E8")?.cgColor
        
        self.openCloseButton.layer.borderColor = UIColor.colorWithHexString("#69CDFF")?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openOrCloseButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        let enabled:Bool = unpackedData.enabled ?? false
        self.delegate?.disableOrEnableTrigger(enable: enabled, id: unpackedData.id ?? "-")
        
    }
    
    
    @IBAction func editButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        self.delegate?.editTrigger(data:unpackedData)
        
    }
    
    func showData(model:TriggerInfoModel) -> Void {
        
        self.data = model
        
        if self.data?.monitor == "o2" {
            
            self.typeImageView.image = UIImage(named: "icon_trigger_o2")
            
        } else if self.data?.monitor == "ph" {
            
            self.typeImageView.image = UIImage(named: "icon_trigger_ph")
            
        } else {
            
            self.typeImageView.image = UIImage(named: "icon_trigger_watertemperature")
            
        }
        
        self.conditionLabel.text = buildConditionForDisplay()
        self.operactionLabel.text =  buildOperactionForDisplay()
        
        
        let enabled:Bool = model.enabled ?? false
        if enabled {
            
            self.openCloseButton.setTitle("禁用", for: .normal)
            self.openCloseButton.backgroundColor = UIColor.colorWithHexString("#3F97E8")
            self.openCloseButton.layer.borderColor = UIColor.colorWithHexString("#3F97E8")?.cgColor
        } else {
            self.openCloseButton.setTitle("启用", for: .normal)
            self.openCloseButton.backgroundColor = UIColor.colorWithHexString("#EA7676")
            self.openCloseButton.layer.borderColor = UIColor.colorWithHexString("#EA7676")?.cgColor
        }
        
    }
    
    private func buildConditionForDisplay() -> String {
        
        var conditionCHN = "-"
        if self.data?.condition == "<" {
            conditionCHN = "小于"
        }
        
        if self.data?.condition == ">" {
            conditionCHN = "大于"
        }
        
        var typeName = "-"
        var unit = "-"
        
        if self.data?.monitor == "o2" {
            
            typeName = "溶氧量"
            unit =  String(self.data?.condition_val ?? 0) + "mg/L"
            
        } else if self.data?.monitor == "ph" {
            
            typeName = "PH值"
            unit =  String(self.data?.condition_val ?? 0)
        } else {
            
            typeName = "水温"
            unit =  String(self.data?.condition_val ?? 0) + "摄氏度"
        }
        
        return typeName + conditionCHN + unit
    }
    
    
    private func buildOperactionForDisplay() -> String {
        
        var typeName = "-"
        let ioName = self.data?.io_name ?? "-"
        if self.data?.operaction == "open" {
            
            typeName = "开启"
        } else {
            typeName = "关闭"
        }
        
        return typeName + ioName
    }
    
    
}
