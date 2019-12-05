//
//  TimePickerView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/4.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import UIKit

class TimePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var hour:Int = 0
    var minute:Int = 0
    
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
        
        let height = CGFloat(40)
        let offsetX = SCREEN_WIDTH / 5
        let offsetY = self.frame.size.height/2 - height/2
        let marginX = CGFloat(15)
        
        let hourLabel = UILabel(frame: CGRect(x: offsetX * 2  - marginX, y: offsetY, width: offsetX, height: height))
        hourLabel.text = "小时"
        //        hourLabel.backgroundColor = UIColor.yellow
        self.addSubview(hourLabel)
        
        let minsLabel = UILabel(frame: CGRect(x: offsetX * 4 + marginX, y: offsetY, width: offsetX, height: height))
        minsLabel.text = "分钟"
        //        minsLabel.backgroundColor = UIColor.yellow
        self.addSubview(minsLabel)
        
    }
    
    func resetSelected(hour:Int, minute:Int) {
        self.selectRow(hour, inComponent: 0, animated: true)
        self.selectRow(minute, inComponent: 1, animated: true)
    }
    
    func getSelectedHour() -> Int {
        return self.hour
    }
    
    func getSelectedMinute() -> Int {
        return self.minute
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.hour = row
        case 1:
            self.minute = row
        default:
            print("No component with number \(component)")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        }
        
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int)
        -> CGFloat {
            return 40
    }
    
    
    //    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    //        let offsetX = SCREEN_WIDTH / 2
    //
    //        return offsetX
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if (view != nil) {
            // %02lu
            (view as! UILabel).text = String(format:"%d", row)
            return view!
        }
        
        let offsetX = SCREEN_WIDTH / 5
        
        var frame = CGRect(x: offsetX, y: 0.0, width: offsetX, height: 40)
        if component == 1 {
            frame = CGRect(x: offsetX * 3, y: 0.0, width: offsetX, height: 40)
        }
        let columnView = UILabel(frame: frame)
        
        //        columnView.backgroundColor = UIColor.red
        columnView.text = String(format:"%d", row)
        columnView.textAlignment = .center
        
        return columnView
    }
}
