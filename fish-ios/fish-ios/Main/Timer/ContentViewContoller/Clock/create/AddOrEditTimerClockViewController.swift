//
//  AddOrEditTimerClockViewController.swift
//  fish-ios
//  创建或编辑定时任务
//  Created by caiwenshu on 2019/11/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class AddOrEditTimerClockViewController: UIViewController {

    
    @IBOutlet weak var feederWeightTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加定时"
        // Do any additional
        self.feederWeightTextField.layer.borderColor = UIColor.colorWithHexString("#F1F3F4")?.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
