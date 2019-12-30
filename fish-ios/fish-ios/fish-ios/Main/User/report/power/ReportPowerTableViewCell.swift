//
//  ReportPowerTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let ReportPowerTableViewCellReuseID = "ReportPowerTableViewCellReuseID"

class ReportPowerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reportTitleLabel:UILabel!
    @IBOutlet weak var reportMinLabel:UILabel!
    
    var itemData:ReportPowerDetailItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showData(model:ReportPowerDetailItem) -> Void {
        self.itemData = model
        //
        //
        self.reportTitleLabel.text = self.itemData?.date
        self.reportMinLabel.text = self.itemData?.value
        //
        //        if let icon = self.itemData?["icon"] {
        //            self.reportImageView.image = UIImage(named: icon)
        //        }
        
    }
    
}
