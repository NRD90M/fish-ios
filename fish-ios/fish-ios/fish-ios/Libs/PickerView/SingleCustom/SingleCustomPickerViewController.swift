//
//  SingleCustomPickerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/6.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class SingleCustomPickerViewController: UIViewController {

    //定义block
    typealias confirmBlock = (_ val :PickViewItem) ->()
    //创建block变量
    var confirmCallBack:confirmBlock?
    
    var dataList:[PickViewItem] = []
    
    var selectedVal:String?
    
    @IBOutlet weak var singleCustomPickerView:SingleCustomPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.singleCustomPickerView.resetSelected(selectedVal: self.selectedVal, list: self.dataList)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset(val :String?, list:[PickViewItem]) {
        //        self.singlePickerView.resetSelected(val: val, type: type)
        self.selectedVal = val
        self.dataList = list
    }
    
    // MARK: Actions
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
        
        if let callback = confirmCallBack{
            callback(self.singleCustomPickerView.getSelectedInfo())
        }
        self.dismiss(animated: true, completion: nil)
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
