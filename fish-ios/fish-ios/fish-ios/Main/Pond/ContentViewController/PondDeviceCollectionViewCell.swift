//
//  PondDeviceCollectionViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/29.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let PondDeviceCollectionViewCellReuseID = "PondDeviceCollectionViewCellReuseID"

///
enum DeviceType: String {
    
    case lamp = "lamp"
    
    case pump = "pump"
    
    case aerator = "aerator"
    
    case feeder = "feeder"
}

class PondDeviceCollectionViewCell: UICollectionViewCell {
    
    var data:PondIOInfoModel?
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var descLabel:UILabel!
    @IBOutlet weak var statusSwitch:UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(model:PondIOInfoModel, deviceMac:String) -> Void {
        self.data = model
        
        self.nameLabel.text = model.name
        self.descLabel.text = " "
        self.statusSwitch.isOn = false
        if model.type == DeviceType.lamp.rawValue {
            self.imgView.image = UIImage(named: "icon_lamp")
        } else if model.type == DeviceType.pump.rawValue {
            self.imgView.image = UIImage(named: "icon_pump")
        } else if model.type == DeviceType.aerator.rawValue {
            self.imgView.image = UIImage(named: "icon_aerator")
        } else {
            self.imgView.image = UIImage(named: "icon_feeder")
        }
        
        
        guard let realTimeDeviceData = FishWebSocketDataHelper.shared.getDeviceData(mac: deviceMac) as? Dictionary<String,Any> ,
            let devicedata = realTimeDeviceData["data"]  as? Dictionary<String,Any>,
            let deviceStatus:Array = devicedata["status"]  as? Array<Dictionary<String, Any>> else {
            return
        }
        
        for item in deviceStatus {
            
            guard let code = item["code"] as? String , let opened = item["opened"] as? NSNumber else {
                return
            }
            if (code == model.code) {
                if (opened == 1) {
                     self.statusSwitch.isOn = true
                } else {
                    self.statusSwitch.isOn = false
                }
            }
        }
        
        
        
        
    }
    

}
