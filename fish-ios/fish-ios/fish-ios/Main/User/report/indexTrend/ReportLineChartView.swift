//
//  ReportLineChartView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Charts

class ReportLineChartView: UIView, ChartViewDelegate {

    @IBOutlet weak var chartView:LineChartView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func chartView() -> ReportLineChartView {
        
        let view = Bundle.main.loadNibNamed("ReportLineChartView", owner: nil, options: nil)?.first as! ReportLineChartView
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 238)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.chartView.delegate = self
        self.chartView.setViewPortOffsets(left: 40.0, top: 40.0, right: 40.0, bottom: 40.0)
        self.chartView.backgroundColor = UIColor.white
        self.chartView.chartDescription?.enabled = false
        self.chartView.dragEnabled = false
        self.chartView.setScaleEnabled(false)
        self.chartView.pinchZoomEnabled = false
        self.chartView.drawGridBackgroundEnabled = false
        self.chartView.maxHighlightDistance = 300.0
        
        let yAxis:YAxis = self.chartView.leftAxis
        yAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor.blue
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.axisLineColor = UIColor.red
        
        
        let xAxis:XAxis = self.chartView.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = UIColor.blue
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineColor = UIColor.red
        xAxis.centerAxisLabelsEnabled = true
        
        self.chartView.rightAxis.enabled = false
        self.chartView.legend.enabled = true
        
        self.chartView.animate(xAxisDuration: 1.0)
//        xAxis.valueFormatter =
        
        
        setDataCount()
    }
    
    func setDataCount(){
        
//        let colors = [ChartColorTemplates.vordiplom()[0],
//                      ChartColorTemplates.vordiplom()[1],
//                      ChartColorTemplates.vordiplom()[2]]
        
        var dataSets:[IChartDataSet] = []
        
        for i in 0...2 {
            
            var values:[ChartDataEntry] = []
            
            for j in 0..<30 {
                
                let val = arc4random_uniform(100) + 3
                values.append(ChartDataEntry.init(x: Double(j), y: Double(val)))
            }
            
            let label = "DataSet"
            let d:LineChartDataSet = LineChartDataSet.init(values: values, label: label)
            
            d.cubicIntensity = 0.2
            d.drawCirclesEnabled = true
            d.lineWidth = 1.8
            d.circleRadius = 4.0
            d.circleHoleRadius = 2.0
            
            d.setCircleColor(UIColor.red)
            d.highlightColor = UIColor.init(red: 244/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)
            d.setColor(UIColor.init(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0))
            d.fillColor =  UIColor.init(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
            d.fillAlpha = 1.0
            d.drawHorizontalHighlightIndicatorEnabled = false
            
            d.highlightColor = UIColor.purple
            d.highlightLineWidth = 1.0
            d.setColor(ChartColorTemplates.vordiplom()[i])
            
            dataSets.append(d)
        }
        
        let data:LineChartData = LineChartData.init(dataSets:dataSets)
        data.setDrawValues(false)
        
        self.chartView.data = data
        
    }
    
    
    
    
    //MARK: ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
    }
    
    
}
