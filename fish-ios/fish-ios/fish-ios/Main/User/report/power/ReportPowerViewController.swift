//
//  ReportPowerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Charts

class ReportPowerViewController: FishPreViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var monthLabelView:UILabel!
    
    
    var titleItemView:HorizontalTitleItemView = HorizontalTitleItemView.titleItemView()
    var popMenu:SwiftPopMenu!
    var sceneList:[PondSceneModel] = [];
    
    var client: FishMainApi = FishMainApi()
    
    var responseData:[MonthSensorDataModel] = []
    
    //    var userInfoModel:UserInfoModel?
    
    var selectedMonthCode:String = ""
    
    var monthInitList:[PickViewItem] = []
    
    var detailItems:[ReportDetailItem] = []
    
    var selectedSceneModel:PondSceneModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "指标趋势"
        
        titleItemView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleItemView)
        
        titleItemView.isHidden = true
        
        
        self.tableView.register(UINib.init(nibName: "ReportIndexTrendTableViewCell", bundle: nil), forCellReuseIdentifier: ReportIndexTrendTableViewCellReuseID)
        
        self.tableView.tableFooterView = UIView.init()
        
        // Do any additional setup after loading the view.
        
        var formatterDates:[PickViewItem] = []
        for i in 0..<12 {
            
            let preMonth = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let dateStr = dateFormatter.string(from: preMonth!)
            
            dateFormatter.dateFormat = "yyyy年MM月"
            let chinaDateStr = dateFormatter.string(from: preMonth!)
            
            formatterDates.append(PickViewItem.init(code: dateStr, name: chinaDateStr))
            
            if i == 0 {
                self.selectedMonthCode = dateStr
                self.monthLabelView.text = chinaDateStr
            }
            
        }
        
        //近一年
        self.monthInitList = formatterDates.reversed()
        
        
        //        self.detailItems = [ReportDetailItem.init(item1: "日期", item2: "时长"),
        //                            ReportDetailItem.init(item1: "2019-08-10", item2: "2013"),
        //                            ReportDetailItem.init(item1: "2019-08-10", item2: "2014")]
        
        
        // 获取鱼塘列表
        self.loadAllScene()
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
        
        self.makeActivity(nil)
        
        self.client.getMonthSensorData(params:["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                               "month_of_year":self.selectedMonthCode], callBack: { (data, error) in
                                                
                                                self.hiddenActivity()
                                                
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
    
    
    @IBAction func monthButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSingleCustomPickerView(selectVal: self.selectedMonthCode, list: self.monthInitList, callback: { (item) in
            
            self.selectedMonthCode = item.code!
            self.monthLabelView.text = item.name
            
            self.loadData()
            
        })
    }
    
    @IBAction func segmentValueChange(_ sender: AnyObject) {
        
        
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        
        self.buildNetDataToTableData()
        
        self.tableView.reloadData()
    }
    
    
    func showSingleCustomPickerView(selectVal:String?, list:[PickViewItem], callback:@escaping (PickViewItem) ->()) {
        
        let pickerVC = SingleCustomPickerViewController()
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.modalPresentationStyle = .overFullScreen
        
        pickerVC.reset(val: selectVal, list: list)
        
        pickerVC.confirmCallBack = { (val :PickViewItem) in
            //确定按钮回调
            callback(val)
            //            print(val.name)
        }
        
        self.present(pickerVC, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = ReportLineChartView.chartView()
        
        //        headerView.showData(model: self.userInfoModel)
        
        self.buildNetDataToChartData(chartView: headerView)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 238
    }
    
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
        let index = indexPath.row
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
        
        let model = self.detailItems[index]
        
        let detail = ReportIndexTrendDetailViewController()
        detail.selectedModel = model
        detail.selectedSceneModel = self.selectedSceneModel
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func buildNetDataToTableData() {
        
        var tableList:[ReportDetailItem] = []
        tableList.append(ReportDetailItem.init(date: "日期", min: "最低", max: "最高", avg: "平均"))
        
        switch(self.selectedSegmentIndex){
        case 0:
            // 水温
            
            for item in self.responseData {
                tableList.append(ReportDetailItem.init(date: item.date ?? "-",
                                                       min: String(item.min_water_temperature ?? 0),
                                                       max: String(item.max_water_temperature ?? 0),
                                                       avg: String(item.avg_water_temperature ?? 0)))
            }
            
            self.detailItems = tableList
            break;
        case 1:
            // 溶氧量
            for item in self.responseData {
                tableList.append(ReportDetailItem.init(date: item.date ?? "-",
                                                       min: String(item.min_o2 ?? 0),
                                                       max: String(item.max_o2 ?? 0),
                                                       avg: String(item.avg_o2 ?? 0)))
            }
            
            self.detailItems = tableList
            
            break;
        case 2:
            // 酸碱度
            for item in self.responseData {
                tableList.append(ReportDetailItem.init(date: item.date ?? "-",
                                                       min: String(item.min_ph ?? 0),
                                                       max: String(item.max_ph ?? 0),
                                                       avg: String(item.avg_ph ?? 0)))
            }
            
            self.detailItems = tableList
            
            break;
        default:
            break;
            
        }
        s
    }
    
    func buildNetDataToChartData(chartView: ReportLineChartView) {
        
        var tableList:[ReportDetailItem] = []
        tableList.append(ReportDetailItem.init(date: "日期", min: "最低", max: "最高", avg: "平均"))
        
        var labels:[String] = []
        
        var valuesOfMin:[ChartDataEntry] = []
        var valuesOfMax:[ChartDataEntry] = []
        var valuesOfAvg:[ChartDataEntry] = []
        let title:[String] = ["最低","最高","平均"]
        switch(self.selectedSegmentIndex){
        case 0:
            // 水温
            for (index, element) in responseData.enumerated() {
                labels.append(element.date ?? "-")
                valuesOfMin.append(ChartDataEntry.init(x: Double(index), y: element.min_water_temperature ?? 0))
                valuesOfMax.append(ChartDataEntry.init(x: Double(index), y: element.max_water_temperature ?? 0))
                valuesOfAvg.append(ChartDataEntry.init(x: Double(index), y: element.avg_water_temperature ?? 0))
            }
            break;
        case 1:
            // 溶氧量
            for (index, element) in responseData.enumerated() {
                labels.append(element.date ?? "-")
                valuesOfMin.append(ChartDataEntry.init(x: Double(index), y: element.min_o2 ?? 0))
                valuesOfMax.append(ChartDataEntry.init(x: Double(index), y: element.max_o2 ?? 0))
                valuesOfAvg.append(ChartDataEntry.init(x: Double(index), y: element.avg_o2 ?? 0))
            }
            
            break;
        case 2:
            // 酸碱度
            for (index, element) in responseData.enumerated() {
                labels.append(element.date ?? "-")
                valuesOfMin.append(ChartDataEntry.init(x: Double(index), y: element.min_ph ?? 0))
                valuesOfMax.append(ChartDataEntry.init(x: Double(index), y: element.max_ph ?? 0))
                valuesOfAvg.append(ChartDataEntry.init(x: Double(index), y: element.avg_ph ?? 0))
            }
            break;
        default:
            break;
            
        }
        
        chartView.setDataCount(dataEntrys: [valuesOfMin, valuesOfMax, valuesOfAvg], label: labels, title: title)
        
    }
    
    // MARK: Net Request
    
    func loadAllScene() {
        
        self.makeActivity(nil)
        
        self.client.getAllScene() { (data, error) in
            
            self.hiddenActivity()
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let d = data?.data, !d.isEmpty {
                self.sceneList = d
                if (self.sceneList.count > 0) {
                    self.titleItemView.isHidden = false
                    self.titleItemView.reloadSelectedPond(model: self.sceneList[0])
                    //TODO: 触发数据刷新
                    self.selectedSceneModel = self.sceneList[0]
                    self.loadData()
                }
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        }
    }
    
    
    func showMenuBtnClick(view:UIView) {
        
        let point = view.convert(CGPoint(x: 0, y: 0), to: FishKeyWindow())
        //数据源（icon可不填）
        
        var popData:[String]  = []
        for scene in self.sceneList {
            popData.append(scene.sceneName ?? "-")
        }
        
        //设置Parameter（可不写）
        popMenu = SwiftPopMenu(frame:  CGRect(x: SCREEN_WIDTH - 105, y: point.y + 40, width: 100, height: 126))
        popMenu.popTextColor = UIColor.colorWithHexString("#FFFFFF")!
        popMenu.popMenuBgColor = UIColor.colorWithHexString("#1F1F1F")!
        popMenu.popData = popData
        
        //click
        
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            print("block select \(index)")
            self?.popMenu.dismiss()
            self?.popMenu = nil
            
            if let model = self?.sceneList[index] {
                self?.titleItemView.isHidden = false
                self?.titleItemView.reloadSelectedPond(model: model)
                
                self?.selectedSceneModel = model
                //TODO: 触发数据刷新
                self?.loadData()
            }
            
            
        }
        
        //show
        popMenu.show()
    }
    
    
}



//开启右滑返回手势:
extension ReportPowerViewController:HorizontalTitleItemViewDelegate {
    
    func showMore() {
        self.showMenuBtnClick(view: self.titleItemView)
    }
    
}
