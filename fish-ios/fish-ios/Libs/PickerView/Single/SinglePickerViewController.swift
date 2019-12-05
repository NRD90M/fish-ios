//
//  SinglePickerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/4.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class SinglePickerViewController: UIViewController {
    
    //定义block
    typealias confirmBlock = (_ val :Int, _ type:SinglePickerType) ->()
    //创建block变量
    var confirmCallBack:confirmBlock?
    
    
    @IBOutlet weak var singlePickerView:SinglePickerView!
    
    
    var pickerType:SinglePickerType = .monthDay
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset(val :Int, type:SinglePickerType) {
        self.pickerType = type
        self.singlePickerView.resetSelected(val: val, type: type)
    }
    
    // MARK: Actions
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
        
        if let callback = confirmCallBack{
            callback(self.singlePickerView.getSelectedVal(), self.pickerType)
        }
        self.dismiss(animated: true, completion: nil)
        //        print(self.datePickerView.date)
    }
    
    @IBAction func cancelButtonTouchUpInSide(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bgButtonTouchUpInSide(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
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
