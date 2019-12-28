//
//  ReportPieChartView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Charts

class ReportPieChartView: UIView, ChartViewDelegate {
    
    @IBOutlet weak var chartView:PieChartView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    class func chartView() -> ReportPieChartView {
        
        let view = Bundle.main.loadNibNamed("ReportPieChartView", owner: nil, options: nil)?.first as! ReportPieChartView
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 238)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.chartView.delegate = self
        self.chartView.setExtraOffsets(left: 40.0, top: 40.0, right: 40.0, bottom: 40.0)
        self.chartView.legend.enabled = false
        
        self.chartView.backgroundColor = UIColor.white
     
        self.chartView.animate(yAxisDuration: 1.4, easingOption: .easeInOutBack)
        
    }
    
    func setDataCount(dataEntrys:[PieChartDataEntry]) {
        
        let dataSet:PieChartDataSet = PieChartDataSet.init(values: dataEntrys, label: "Results")
        
        dataSet.setColors(ChartColorTemplates.vordiplom(), alpha: 1.0)
        
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        dataSet.yValuePosition = .outsideSlice
        
        
        let data:PieChartData = PieChartData.init(dataSet:dataSet)
       
        let formatter:NumberFormatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        
        data.setValueFormatter(DefaultValueFormatter.init(formatter: formatter))
        data.setValueFont(UIFont.systemFont(ofSize: 11.0))
        data.setValueTextColor(UIColor.black)

        self.chartView.data = data
        self.chartView.highlightValues(nil)
 
    }
    
    
    //MARK: ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
    }
}

