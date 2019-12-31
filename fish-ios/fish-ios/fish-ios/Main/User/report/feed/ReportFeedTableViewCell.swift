//
//  ReportFeedTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/31.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let ReportFeedTableViewCellReuseID = "ReportFeedTableViewCellReuseID"

class ReportFeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reportTitleLabel:UILabel!
    @IBOutlet weak var reportValueLabel:UILabel!
    
    var itemData:ReportDateValueDetailItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showData(model:ReportDateValueDetailItem) -> Void {
        self.itemData = model
        //
        //
        self.reportTitleLabel.text = self.itemData?.date
        self.reportValueLabel.text = self.itemData?.value
        //
        //        if let icon = self.itemData?["icon"] {
        //            self.reportImageView.image = UIImage(named: icon)
        //        }
        
    }
    
}
