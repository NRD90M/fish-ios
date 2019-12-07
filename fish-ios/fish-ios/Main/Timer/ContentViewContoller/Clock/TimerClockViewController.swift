//
//  TimerClockViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/30.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import MJRefresh

class TimerClockViewController: FishPreViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var client: FishMainApi = FishMainApi()
    
    var planList:[PlanInfoModel] = []
    
    var selectedSceneModel:PondSceneModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib.init(nibName: "TimerClockTableViewCell", bundle: nil), forCellReuseIdentifier: TimerClockTableViewCellReuseID)
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        
//        self.tableView.mj_header.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func refreshSelectedSceneModel(model:PondSceneModel) {
        
        if self.selectedSceneModel?.deviceMac != model.deviceMac {
                self.selectedSceneModel = model
        }
    }
    
    func loadData() -> Void {
        
        self.makeActivity(nil)
        
        self.planList = []
        self.tableView.reloadData()
        
        self.client.getAllPlan(params: ["device_mac":self.selectedSceneModel?.deviceMac ?? "-"], callBack: { (data, error) in
            
            self.hiddenActivity()
            self.tableView?.mj_header?.endRefreshing()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            if let d = data?.data, !d.isEmpty {
                self.planList = d
                self.tableView.reloadData()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func createButtonTouchUpInside(_ sender: Any) {
        
        let addOrEditVC = AddOrEditTimerClockViewController()
        addOrEditVC.selectedSceneModel = self.selectedSceneModel
        self.navigationController?.pushViewController(addOrEditVC, animated: true)
        
    }
    
    
    
    // MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: TimerClockTableViewCellReuseID)
        
        guard let eCell = cell as? TimerClockTableViewCell else {
            return cell
        }
        eCell.delegate = self
        eCell.showData(model: self.planList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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

extension TimerClockViewController : TimerClockTableViewCellDelegate {
    func disableOrEnablePlan(enable: Bool, id: String) {
        
        
        let param = ["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                     "id":id]
        
        if enable {
            self.makeActivity(nil)
            
            self.client.disablePlan(params: param) { (data, error) in
                
                self.hiddenActivity()
                
                if let err = Parse.parseResponse(data, error) {
                    self.view.makeHint(err.showMessage)
                    return
                }
                
                if let code = data?.code {
                    if code == 1000 {
                         self.loadData()
                        return
                    }
                }
                
                self.view.makeHint("操作失败，请稍后再试")
                
            }
        } else {
            self.makeActivity(nil)
            
            self.client.enablePlan(params: param) { (data, error) in
                
                self.hiddenActivity()
                
                if let err = Parse.parseResponse(data, error) {
                    self.view.makeHint(err.showMessage)
                    return
                }
                
                if let code = data?.code {
                    if code == 1000 {
                        self.loadData()
                        return
                    }
                }
                
                self.view.makeHint("操作失败，请稍后再试")
                
            }
        }
    }
    
    
    func editPlan(data:PlanInfoModel) {
        let addOrEditVC = AddOrEditTimerClockViewController()
        addOrEditVC.selectedSceneModel = self.selectedSceneModel
        addOrEditVC.resetPlanInfoModel(data, .edit)
        self.navigationController?.pushViewController(addOrEditVC, animated: true)
    }
    
    
}
