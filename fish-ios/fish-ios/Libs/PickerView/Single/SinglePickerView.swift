//
//  SinglePickerView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/4.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import UIKit

enum SinglePickerType: Int {
    
    case monthDay
    
    case weekDay
    
}

class SinglePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedVal:Int = 0
    
    var pickerType:SinglePickerType = .monthDay
    
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
    
    func resetSelected(val:Int, type:SinglePickerType) {
        self.pickerType = type
        var select = val
        if select > 0 {
            select = val - 1
        }
        self.selectRow(select, inComponent: 0, animated: true)
    }
    
    func getSelectedVal() -> Int {
        return self.selectedVal
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedVal = (row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerType == .monthDay {
            return 28
        }
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int)
        -> CGFloat {
            return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var val = "-"
        if self.pickerType == .monthDay {
            val = String(format: "%d号", (row + 1))
        } else if self.pickerType == .weekDay {
            val = FishDefine.weekDayToCHN(day: (row + 1))
        }
        
        return val
    }
    
    
//    private func weekDayToCHN(day:Int) -> String {
//        
//        switch day {
//        case 1:
//            return "周一"
//        case 2:
//            return "周二"
//        case 3:
//            return "周三"
//        case 4:
//            return "周四"
//        case 5:
//            return "周五"
//        case 6:
//            return "周六"
//        default:
//            return "周日"
//        }
//        
//    }
}
