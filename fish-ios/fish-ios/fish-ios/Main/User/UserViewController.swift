//
//  UserViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/15.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import MJRefresh

class UserViewController: FishPreViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var client: FishMainApi = FishMainApi()
    
    var userInfoModel:UserInfoModel?
    
    var tableItemData = [["icon" : "icon_report.png", "name" : "报表", "type" : "report"],
                         ["icon" : "icon_modify_phone.png", "name" : "修改手机号", "type" : "phone"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
//        self.tableView
        
//        self.edgesForExtendedLayout = UIRectEdgeNone
        self.tableView.register(UINib.init(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCellReuseID)
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void {
        
        
        self.client.userInfo(callBack:  { (data, error) in
            
            self.tableView?.mj_header?.endRefreshing()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            if let d = data?.data {
                self.userInfoModel = d
                self.tableView.reloadData()
//                self.alertList = d
//                self.tableView.reloadData()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
            
        })
        
//        self.client.getAllTrigger(params: ["device_mac":self.selectedSceneModel?.deviceMac ?? "-"], callBack: { (data, error) in
//
//            self.tableView?.mj_header?.endRefreshing()
//
//            if let err = Parse.parseResponse(data, error) {
//                self.view.makeHint(err.showMessage)
//                return
//            }
//            if let d = data?.data, !d.isEmpty {
//                self.alertList = d
//                self.tableView.reloadData()
//            } else {
//                self.view.makeHint("数据获取失败，请稍后再试")
//            }
//        })
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UserHeaderView.headerView()
        
        headerView.showData(model: self.userInfoModel)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 214
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: UserTableViewCellReuseID)
     
        
        guard let eCell = cell as? UserTableViewCell else {
            return cell
        }
        eCell.selectionStyle = .none
        eCell.showData(model: self.tableItemData[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if let type =  self.tableItemData[index]["type"] {
            
            if type == "report" {
              print("report")
                
                let report = UserReportViewController()
                self.navigationController?.pushViewController(report, animated: true)
                
            }
            if type == "phone" {
                print("phone")
            }
        }
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
