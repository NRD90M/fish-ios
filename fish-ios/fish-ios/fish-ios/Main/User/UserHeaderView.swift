//
//  UserHeaderView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/19.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import SDWebImage

class UserHeaderView: UIView {

    
    @IBOutlet weak var nameLabel:UILabel!
    
    @IBOutlet weak var headerImageView:UIImageView!
    
    var itemData:UserInfoModel?
    
    class func headerView() -> UserHeaderView {
        
        let view = Bundle.main.loadNibNamed("UserHeaderView", owner: nil, options: nil)?.first as! UserHeaderView
        
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 214)
        return view
    }
    
    
    func showData(model:UserInfoModel?) -> Void {
        
        self.itemData = model
        
        self.nameLabel.text = self.itemData?.user?.display_name
        
        if let iconUrl = self.itemData?.user?.icon {
            
           self.headerImageView.sd_setImage(with: URL(string: iconUrl), placeholderImage: UIImage(named: "icon_header_placeholder"))
            
        }
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
