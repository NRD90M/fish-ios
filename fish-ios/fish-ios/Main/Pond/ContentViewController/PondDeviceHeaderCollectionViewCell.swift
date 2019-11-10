//
//  PondDeviceHeaderCollectionViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit



class PondDeviceHeaderCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var waterTemperatureView:UIView! // 水温
    @IBOutlet weak var o2View:UIView! //溶氧量
    @IBOutlet weak var phView:UIView! //ph
    
    @IBOutlet weak var waterTemperatureLabel:UILabel!
    @IBOutlet weak var o2Label:UILabel!
    @IBOutlet weak var phLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // shadowCode
//        o2View.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//        o2View.layer.shadowOffset = CGSize(width: 0, height: 0)
//        o2View.layer.shadowOpacity = 1
//        o2View.layer.shadowRadius = 10
        
    }
    
    func reloadData(deviceMac:String) -> Void {
        
        guard let realTimeDeviceData = FishWebSocketDataHelper.shared.getDeviceData(mac: deviceMac) as? Dictionary<String,Any> ,let data = realTimeDeviceData["data"]  as? Dictionary<String,Any>  else {
            return
        }
        
        if let water_temperature = (data["water_temperature"] as? NSNumber)?.doubleValue {
             waterTemperatureLabel.text = String(format: "%.0f°C", water_temperature)
        } else {
            waterTemperatureLabel.text = "- °C"
        }
        
        if let ph = (data["ph"] as? NSNumber)?.doubleValue {
           phLabel.text = String(format: "%.2fmol·", ph)
        } else {
            phLabel.text = "- mol·"
        }
        
        if let o2 = (data["o2"] as? NSNumber)?.doubleValue {
           o2Label.text = String(format: "%.2fml/L", o2)
        } else {
            o2Label.text = "- ml/L"
        }
        
    }

}
