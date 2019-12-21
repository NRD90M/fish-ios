//
//  UserReportCollectionViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/19.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit


let UserReportCollectionViewCellReuseID = "UserReportCollectionViewCellReuseID"

class UserReportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var reportImageView:UIImageView!
    @IBOutlet weak var reportTitleLabel:UILabel!
    
    var itemData:[String:String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func showData(model:[String:String]) -> Void {
        self.itemData = model
        
        
        self.reportTitleLabel.text = self.itemData?["name"]
        
        if let icon = self.itemData?["icon"] {
            self.reportImageView.image = UIImage(named: icon)
        }
        
    }
    
}
