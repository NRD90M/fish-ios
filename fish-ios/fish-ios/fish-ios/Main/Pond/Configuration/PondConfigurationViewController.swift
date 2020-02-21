//
//  PondConfigurationViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2020/2/20.
//  Copyright © 2020 caiwenshu. All rights reserved.
//
import UIKit
import MJRefresh

class PondConfigurationViewController: FishPreViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var client: FishMainApi = FishMainApi()
    
    var infoList:[PondIOInfoModel] = []
    
    var selectedSceneModel:PondSceneModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "鱼塘配置"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_arrow_back"), style: .plain, target: self, action: #selector(dismissViewController(animated:)))
        
        self.tableView.register(UINib.init(nibName: "PondConfigurationTableViewCell", bundle: nil), forCellReuseIdentifier: PondConfigurationTableViewCellReuseID)
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissViewController(animated:Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshSelectedSceneModel(model:PondSceneModel) {
        
        if self.selectedSceneModel?.deviceMac != model.deviceMac {
            self.selectedSceneModel = model
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func loadData() -> Void {
        
        self.makeActivity(nil)
        
        self.client.getIOInfo(params: ["device_mac":self.selectedSceneModel?.deviceMac ?? "-"], callBack: { (data, error) in
            
            self.hiddenActivity()
            
            self.tableView?.mj_header?.endRefreshing()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            if let d = data?.data, !d.isEmpty {
                self.infoList = d
                self.tableView.reloadData()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        })
        
    }
    
    func renameRequest(data: PondIOInfoModel, text:String) -> Void {
        
        let param:[String : Any] = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                     "code":data.code ?? "-",
                                     "name":text]
        
        self.makeActivity(nil)
        
        self.client.editDeviceIORename(params: param) { (data, error) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                     self.view.makeHint("修改成功")
                    self.loadData()
                } else {
                    self.view.makeHint("修改失败,请稍后再试")
                }
            } else {
                self.view.makeHint("修改失败,请稍后再试")
            }
        }
    }

    
    
    func isEnableRequest(data: PondIOInfoModel, enable:Bool) -> Void {
        
        let param:[String : Any] = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                    "code":data.code ?? "-"]
        
        self.makeActivity(nil)
        
        let callback = { (data:FishCodeMsgResponseAnyModel<String>?, error:NSError?) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                    self.view.makeHint("修改成功")
                } else {
                    self.view.makeHint("修改失败,请稍后再试")
                }
            } else {
                self.view.makeHint("修改失败,请稍后再试")
            }
            
            // 刷新数据
            self.loadData()
        }
        
        if enable {
            self.client.editDeviceIOEnable(params: param, callBack: callback)
        } else {
            self.client.editDeviceIODisable(params: param, callBack: callback)
            
        }
        
    }
    
    
    func isWattCostRequest(data: PondIOInfoModel, power:Int) -> Void {
        
        let param:[String : Any] = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                    "code":data.code ?? "-",
                                    "power_w":power]
        
        self.makeActivity(nil)
        
        let callback = { (data:FishCodeMsgResponseAnyModel<String>?, error:NSError?) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let code = data?.code {
                if code == 1000 {
                    self.view.makeHint("设置成功")
                } else {
                    self.view.makeHint("设置失败,请稍后再试")
                }
            } else {
                self.view.makeHint("设置失败,请稍后再试")
            }
            
            // 刷新数据
            self.loadData()
        }
        
       self.client.editDeviceIOPower(params: param, callBack: callback)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: PondConfigurationTableViewCellReuseID)
        
        guard let eCell = cell as? PondConfigurationTableViewCell else {
            return cell
        }
        eCell.delegate = self
        eCell.showData(model: self.infoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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


extension PondConfigurationViewController : PondConfigurationTableViewCellDelegate {
    
    func wattCostCallBack(data: PondIOInfoModel) {
        
        let alertController = UIAlertController(title: "设置功耗", message: data.name, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入功耗"
            if let powerW = data.powerW {
                textField.text = String(powerW)
            }
            textField.keyboardType = .numberPad
        }
        alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (alertAction) in
            let text = alertController.textFields?.first?.text ?? "0"
            self.isWattCostRequest(data: data, power: Int(text)!)
            
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func reNameCallBack(data: PondIOInfoModel) {
        
        let alertController = UIAlertController(title: "重命名", message: data.name, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = data.name
        }
        alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (alertAction) in
            let renameText = alertController.textFields?.first?.text ?? "-"
            self.renameRequest(data: data, text: renameText)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func adjustCallBack(data: PondIOInfoModel) {
        
    }
    
    func controlEnabledValueChanged(data:PondIOInfoModel, enable:Bool) {
        
        self.isEnableRequest(data: data, enable: enable)
        
    }
    

    

}
