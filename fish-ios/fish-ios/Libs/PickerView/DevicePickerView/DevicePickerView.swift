//
//  DevicePickerView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/5.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import UIKit


class DevicePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedVal:Int = 0
    
    var ioDevicesList:[PondIOInfoModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.delegate = self
        self.dataSource = self
    }
    
    func resetSelected(selectedModel:PondIOInfoModel?, list:[PondIOInfoModel]) {
        
        self.ioDevicesList = list
        
        let index = self.ioDevicesList.index(where: { (info) -> Bool in
            return info.code == selectedModel?.code
        })
        
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
    }
    
    func getSelectedInfoModel() -> PondIOInfoModel {
        return self.ioDevicesList[self.selectedVal]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedVal = row
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return self.ioDevicesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int)
        -> CGFloat {
            return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let val = self.ioDevicesList[row].name ?? "-"
        return val
    }
    
}
