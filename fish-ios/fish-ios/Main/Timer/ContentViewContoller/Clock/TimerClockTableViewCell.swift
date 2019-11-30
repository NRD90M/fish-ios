//
//  TimerClockTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit


protocol TimerClockTableViewCellDelegate : class {
    func disableOrEnablePlan(enable:Bool, id:String)
}

let TimerClockTableViewCellReuseID = "TimerClockTableViewCellReuseID"

class TimerClockTableViewCell: UITableViewCell {

    
    @IBOutlet weak var openCloseButton:UIButton!
    @IBOutlet weak var editButton:UIButton!
    
    @IBOutlet weak var preTypeImageView:UIImageView!
    @IBOutlet weak var preTypeLabel:UILabel!
    
    @IBOutlet weak var timeLabel:UILabel!
    
    @IBOutlet weak var ioNameImageView:UIImageView!
    @IBOutlet weak var ioNameLabel:UILabel!
    
    @IBOutlet weak var ioDescImageView:UIImageView!
    @IBOutlet weak var ioDescLabel:UILabel!
    
    
    var data:PlanInfoModel?
    
    weak var delegate: TimerClockTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // #EA7676
        self.openCloseButton.layer.borderColor = UIColor.colorWithHexString("#69CDFF")?.cgColor
        self.editButton.layer.borderColor = UIColor.colorWithHexString("#161717")?.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showData(model:PlanInfoModel) -> Void {
        
        self.data = model
        
        if model.per == "day" {
            self.preTypeImageView.image = UIImage(named: "icon_clock_per_day")
            self.preTypeLabel.text = "每天"
        } else if model.per == "week" {
            self.preTypeImageView.image = UIImage(named: "icon_clock_per_week")
            self.preTypeLabel.text = "每" + self.parseNumberToWeekString(week: model.day_of_week)
        } else {
            // 每月
            self.preTypeImageView.image = UIImage(named: "icon_clock_per_month")
            self.preTypeLabel.text = "每月" + String(model.day_of_month ?? 0) + "号"
        }
        self.timeLabel.text = parseDatesToString(model.hour ?? 0, model.minute ?? 0)
        
        
        if model.io_type == DeviceType.lamp.rawValue {
            self.ioNameImageView.image = UIImage(named: "icon_lamp")
            self.ioDescImageView.image = UIImage(named: "icon_clock_duration")
            self.ioDescLabel.text = parseDurationToDisplay(model.duration ?? 0)
            
        } else if model.io_type == DeviceType.pump.rawValue {
            self.ioNameImageView.image = UIImage(named: "icon_pump")
            self.ioDescImageView.image = UIImage(named: "icon_clock_duration")
            self.ioDescLabel.text = parseDurationToDisplay(model.duration ?? 0)
            
        } else if model.io_type == DeviceType.aerator.rawValue {
            self.ioNameImageView.image = UIImage(named: "icon_aerator")
            self.ioDescImageView.image = UIImage(named: "icon_clock_duration")
            self.ioDescLabel.text = parseDurationToDisplay(model.duration ?? 0)
            
        } else {
            self.ioNameImageView.image = UIImage(named: "icon_feeder")
            self.ioDescImageView.image = UIImage(named: "icon_clock_feeder_weight")
            self.ioDescLabel.text = "投喂" + String (model.weight ?? 0) + "克"
        }
        self.ioNameLabel.text = "开启" + (model.io_name ?? "-")
        
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
    
    
    // MARK: Actions
    @IBAction func openOrCloseButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        let enabled:Bool = unpackedData.enabled ?? false
        self.delegate?.disableOrEnablePlan(enable: enabled, id: unpackedData.id ?? "-")
        
    }
    
    @IBAction func editButtonTouchUpInside(_ sender: Any) {
        
    }
    
    func parseDurationToDisplay(_ duration:Int) -> String {
        
        let beiginStr = "时长"
        var endStr = "秒"
        if duration < 1000 {
            return beiginStr + "0" + endStr
        }
    
        // 秒
        var val:Double = Double(duration) / 1000.0
        if duration < 60 * 1000 {
            return beiginStr + String(val) + endStr
        }
        
        // 分钟
        val = val / 60
        endStr = "分钟"
        if duration < 60 * 60 * 1000 {
            return beiginStr + String(val) + endStr
        }
        
        // 小时
        val = val / 60
        endStr = "小时"
        return beiginStr + String(val) + endStr
    }
    
    //
    
    func parseDatesToString(_ hour:Int, _ minute:Int) -> String {
        
        var preString = "上午"
        
        if hour > 12 {
            preString = "下午"
        }
        
        return preString + conventIntToString(hour) + ":" + conventIntToString(minute)
    }
    
    func conventIntToString(_ val:Int) -> String {
        if (val < 10) {
            return "0" + String(val)
        }
        return String(val)
    }
    
    
    func parseNumberToWeekString(week:Int?) -> String {
        if (week == 1) {
            return "周一"
        } else if week  == 2 {
            return "周二"
        } else if week  == 3 {
            return "周三"
        } else if week  == 4 {
            return "周四"
        } else if week  == 5 {
            return "周五"
        } else if week  == 6 {
            return "周六"
        } else {
            return "周日"
        }
    }
}
