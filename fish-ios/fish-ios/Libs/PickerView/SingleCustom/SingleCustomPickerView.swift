//
//  SingleCustomPickerView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/6.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import UIKit


class SingleCustomPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedVal:Int = 0
    
    var dataList:[PickViewItem] = []
    
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
    
    func resetSelected(selectedVal:String?, list:[PickViewItem]) {
        
        self.dataList = list
        
        let index = self.dataList.index(where: { (info) -> Bool in
            return info.code == selectedVal
        })
        
        self.selectRow(index ?? 0, inComponent: 0, animated: true)
    }
    
    func getSelectedInfo() -> PickViewItem {
        return self.dataList[self.selectedVal]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedVal = row
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int)
        -> CGFloat {
            return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let val = self.dataList[row].name ?? "-"
        return val
    }
    
}
