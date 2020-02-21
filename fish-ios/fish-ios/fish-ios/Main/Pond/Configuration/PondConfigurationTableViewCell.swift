//
//  PondConfigurationTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2020/2/20.
//  Copyright © 2020 caiwenshu. All rights reserved.
//

import UIKit

let PondConfigurationTableViewCellReuseID = "PondConfigurationTableViewCellReuseID"

protocol PondConfigurationTableViewCellDelegate : class {
    func wattCostCallBack(data:PondIOInfoModel)
    func reNameCallBack(data:PondIOInfoModel)
    func adjustCallBack(data:PondIOInfoModel)
    func controlEnabledValueChanged(data:PondIOInfoModel, enable:Bool)
}

class PondConfigurationTableViewCell: UITableViewCell {
    
    // 电量消耗
    @IBOutlet weak var wattCostButton:UIButton!
    // 校准投喂量
    @IBOutlet weak var adjustButton:UIButton!
    // 重命名
    @IBOutlet weak var reNameButton:UIButton!
    
    @IBOutlet weak var controlSwitch:UISwitch!
    
    @IBOutlet weak var typeImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel! // 名称
    @IBOutlet weak var statusLabel:UILabel! // 状态

    var data:PondIOInfoModel?
    
    weak var delegate: PondConfigurationTableViewCellDelegate?
    
    //    weak var delegate: TimerClockTableViewCellDelegate?
    
//    {
//        code = lamp1;
//        enabled = 1;
//        name = "\U671d\U5357\U7684\U706f";
//        pin = 19;
//        "power_w" = 100;
//        type = lamp;
//    },

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.reNameButton.layer.borderColor = UIColor.colorWithHexString("#CACBCC")?.cgColor
        
        self.wattCostButton.layer.borderColor = UIColor.colorWithHexString("#69CDFF")?.cgColor
        
        self.adjustButton.layer.borderColor = UIColor.colorWithHexString("#69CDFF")?.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func reNameButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        self.delegate?.reNameCallBack(data: unpackedData)
        
//        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
//        alertController.addTextField { (textField) in
//
//        }
//        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
    
    @IBAction func wattCostButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        self.delegate?.wattCostCallBack(data: unpackedData)
        
//        self.delegate?.editTrigger(data:unpackedData)
        
    }
    
    @IBAction func adjustButtonTouchUpInside(_ sender: Any) {
        
        guard let unpackedData = self.data else {
            return
        }
        
        self.delegate?.adjustCallBack(data: unpackedData)
        
        //        self.delegate?.editTrigger(data:unpackedData)
        
    }
    
    @IBAction func controlSwitchValueChanged(_ sender: Any) {
//        print(self.controlSwitch.isOn)
        guard let unpackedData = self.data else {
            return
        }
        
        self.delegate?.controlEnabledValueChanged(data: unpackedData, enable: self.controlSwitch.isOn)
    }
    
    func showData(model:PondIOInfoModel) -> Void {
        self.data = model
        
        self.nameLabel.text = model.name
        self.controlSwitch.isOn = false
        if model.type == DeviceType.lamp.rawValue {
            self.typeImageView.image = UIImage(named: "icon_lamp")
        } else if model.type == DeviceType.pump.rawValue {
            self.typeImageView.image = UIImage(named: "icon_pump")
        } else if model.type == DeviceType.aerator.rawValue {
            self.typeImageView.image = UIImage(named: "icon_aerator")
        } else {
            self.typeImageView.image = UIImage(named: "icon_feeder")
        }
        
        guard let code = model.enabled as NSNumber? else {
            return
        }
        if (code == 1) {
            self.controlSwitch.isOn = true
            self.statusLabel.text = "启用"
        } else {
            self.controlSwitch.isOn = false
            self.statusLabel.text = "禁用"
        }
    }
    
   
    
}
