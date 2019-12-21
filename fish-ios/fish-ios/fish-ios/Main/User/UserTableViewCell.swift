//
//  UserTableViewCell.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/19.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

let UserTableViewCellReuseID = "UserTableViewCellReuseID"

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var icon:UIImageView!
    
    var itemData:[String:String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(model:[String:String]) -> Void {
        
        self.itemData = model
        
        self.titleLabel.text = self.itemData?["name"]
        
        if let icon = self.itemData?["icon"] {
           self.icon.image = UIImage(named: icon)
        }
        
        
    }
    
}
