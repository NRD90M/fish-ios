//
//  HorizontalTitleItemView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

protocol HorizontalTitleItemViewDelegate : class {
    // 展示更多
    func showMore()
}

class HorizontalTitleItemView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var titleLabel:UILabel!
    
    weak var delegate: HorizontalTitleItemViewDelegate?
    
    class func titleItemView() -> HorizontalTitleItemView {
        
        let view = Bundle.main.loadNibNamed("HorizontalTitleItemView", owner: nil, options: nil)?.first as! HorizontalTitleItemView
        
        view.frame = CGRect(x: 0, y: 0, width: 88, height: 30)
        return view
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadSelectedPond(model:PondSceneModel) {
        self.titleLabel.text = model.sceneName
    }
    
    @IBAction func moreButtonTouchupInside(_ sender:Any) {
        delegate?.showMore()
    }
    
}
