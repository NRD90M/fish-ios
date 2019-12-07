//
//  FishHourMinPickerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/3.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class FishHourMinPickerViewController: UIViewController {
    
    //定义block
    typealias confirmBlock = (_ hour :Int, _ minute:Int) ->()
    //创建block变量
    var confirmCallBack:confirmBlock?
    
    @IBOutlet weak var pickerView:TimePickerView!
    
    var selectedHour:Int = 0
    var selectedMinute:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.resetSelected(hour: self.selectedHour,minute: self.selectedMinute)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset(hour :Int, minute:Int) {
        self.selectedHour = hour
        self.selectedMinute = minute
    }
    
    // MARK: Actions
    
    @IBAction func confirmButtonTouchUpInSide(_ sender: Any)  {
        //        print(self.datePickerView.date)
        
        if let callback = confirmCallBack{
            callback(self.pickerView.getSelectedHour(), self.pickerView.getSelectedMinute())
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
