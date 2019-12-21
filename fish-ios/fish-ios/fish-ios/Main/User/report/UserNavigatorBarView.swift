//
//  UserNavigatorBarView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class UserNavigatorBarView: UIView {

    static let height: CGFloat = 75

    // 背景视图
    open var bgView: UIView = UIView()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commitInitView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commitInitView() {
        
        self.bgView.backgroundColor = UIColor.red
        self.bgView.frame = self.bounds
        self.bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.bgView)
    }
}
