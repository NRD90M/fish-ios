//
//  ReportIndexTrendTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let ReportIndexTrendTableViewCellReuseID = "ReportIndexTrendTableViewCellReuseID"

class ReportIndexTrendTableViewCell: UITableViewCell {

    
    @IBOutlet weak var reportTitleLabel:UILabel!
    @IBOutlet weak var reportValueLabel:UILabel!
    
    var itemData:ReportDetailItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(model:ReportDetailItem) -> Void {
        self.itemData = model
//
//
        self.reportTitleLabel.text = self.itemData?.item1
        self.reportValueLabel.text = self.itemData?.item2
//
//        if let icon = self.itemData?["icon"] {
//            self.reportImageView.image = UIImage(named: icon)
//        }
        
    }
    
}
