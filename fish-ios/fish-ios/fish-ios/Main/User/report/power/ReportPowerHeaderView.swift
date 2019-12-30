//
//  ReportPowerHeaderView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/28.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import SnapKit

class ReportPowerHeaderView: UIView {

    
    var lineChartView:ReportLineChartView!
    var pieChartView:ReportPieChartView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func headerView() -> ReportPowerHeaderView {
        
        let view = Bundle.main.loadNibNamed("ReportPowerHeaderView", owner: nil, options: nil)?.first as! ReportPowerHeaderView
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 476)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lineChartView = ReportLineChartView.chartView()
        
        self.pieChartView = ReportPieChartView.chartView()
        
        self.addSubview(self.lineChartView)
        
        self.addSubview(self.pieChartView)
        
        self.lineChartView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(238)
        }
        
        self.pieChartView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.lineChartView.snp.bottom)
            maker.height.equalTo(238)
        }
        
    }
    
    
    
    
    
}
