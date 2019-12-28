//
//  ReportIndexTrendDetailViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/28.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import MJRefresh

//详情
class ReportIndexTrendDetailViewController: FishPreViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var selectedSceneModel:PondSceneModel?
    var selectedModel:ReportDetailItem?
    
    var client: FishMainApi = FishMainApi()
    
    var responseData:[SensorDataDetailModel] = []
    
    var detailItems:[ReportDetailItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = self.selectedModel {
            self.title = model.date
        }
        
        self.tableView.register(UINib.init(nibName: "ReportIndexTrendTableViewCell", bundle: nil), forCellReuseIdentifier: ReportIndexTrendTableViewCellReuseID)
        
        self.tableView.tableFooterView = UIView.init()
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))

        self.tableView.mj_header.beginRefreshing()
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadData() -> Void {
        
        //        self.client.userInfo(callBack:  { (data, error) in
        //
        //            self.tableView?.mj_header?.endRefreshing()
        //
        //            if let err = Parse.parseResponse(data, error) {
        //                self.view.makeHint(err.showMessage)
        //                return
        //            }
        //            if let d = data?.data {
        //                self.userInfoModel = d
        //                self.tableView.reloadData()
        //                //                self.alertList = d
        //                //                self.tableView.reloadData()
        //            } else {
        //                self.view.makeHint("数据获取失败，请稍后再试")
        //            }
        //
        //        })
        
//        self.makeActivity(nil)
        
        self.client.getSensorDataDetail(params:["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                                "date":(self.selectedModel?.date)!], callBack: { (data, error) in
                                                
//                                                self.hiddenActivity()
                                                
                                                     self.tableView?.mj_header?.endRefreshing()
                                                    
                                                if let err = Parse.parseResponse(data, error) {
                                                    self.view.makeHint(err.showMessage)
                                                    self.responseData = []
                                                    self.buildNetDataToTableData()
                                                    self.tableView.reloadData()
                                                    return
                                                }
                                                
                                                if let d = data?.data, !d.isEmpty {
                                                    self.responseData = d
                                                    
                                                    self.buildNetDataToTableData()
                                                    
                                                    self.tableView.reloadData()
                                                } else {
                                                    
                                                    self.responseData = []
                                                    
                                                    self.buildNetDataToTableData()
                                                    
                                                    self.tableView.reloadData()
                                                    
                                                    self.view.makeHint("数据获取失败，请稍后再试")
                                                }
        })
        
    }
    
    
    func buildNetDataToTableData() {
        
        var tableList:[ReportDetailItem] = []
        tableList.append(ReportDetailItem.init(date: "日期", min: "水温", max: "溶氧量", avg: "酸碱度"))
        
        
        for item in self.responseData {
            tableList.append(ReportDetailItem.init(date: item.create_time ?? "-",
                                                   min: String(item.water_temperature ?? 0),
                                                   max: String(item.o2 ?? 0),
                                                   avg: String(item.ph ?? 0)))
            
        }
        
        self.detailItems = tableList
        
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = ReportLineChartView.chartView()
//
//        //        headerView.showData(model: self.userInfoModel)
//
//        self.buildNetDataToChartData(chartView: headerView)
//
//        return headerView
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 238
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: ReportIndexTrendTableViewCellReuseID)
        
        
        guard let eCell = cell as? ReportIndexTrendTableViewCell else {
            return cell
        }
        eCell.selectionStyle = .none
        eCell.showData(model: self.detailItems[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
        //        if let type =  self.tableItemData[index]["type"] {
        //
        //            if type == "report" {
        //                print("report")
        //
        //                let report = UserReportViewController()
        //                self.navigationController?.pushViewController(report, animated: true)
        //
        //            }
        //            if type == "phone" {
        //                print("phone")
        //            }
        //        }
        
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
