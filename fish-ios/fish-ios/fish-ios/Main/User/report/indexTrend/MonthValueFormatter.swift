//
//  MonthValueFormatter.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/28.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import Foundation
import Charts

open class MonthValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter
{
    fileprivate static let MAX_LENGTH = 5
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    open var suffix = ["", "k", "m", "b", "t"]
    
    /// An appendix text to be added at the end of the formatted value.
    open var monthList: [String]?
    
    public override init()
    {
        
    }
    
    public init(monthList: [String]?)
    {
        self.monthList = monthList
    }
    
    fileprivate func format(value: Double) -> String
    {
//        print(value)
        if let list = self.monthList {
            if list.count > Int(value) && Int(value) > 0 {
                return list[Int(value)]
            }
        }
        
        return self.monthList?[0] ?? "-"
    }
    
    open func stringForValue(
        _ value: Double, axis: AxisBase?) -> String
    {
        return format(value: value)
    }
    
    open func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String
    {
        return format(value: value)
    }
}
