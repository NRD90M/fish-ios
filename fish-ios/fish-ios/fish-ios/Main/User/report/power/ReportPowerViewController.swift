//
//  ReportPowerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/21.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Charts

public struct ReportPowerDetailItem {
    public var date: String?
    public var value: String?
    
    public init(date:String, value: String) {
        self.date = date
        self.value = value
    }
}

class ReportPowerViewController: FishPreViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var monthLabelView:UILabel!
    
    
    var titleItemView:HorizontalTitleItemView = HorizontalTitleItemView.titleItemView()
    var popMenu:SwiftPopMenu!
    var sceneList:[PondSceneModel] = [];
    
    var client: FishMainApi = FishMainApi()
    
    
    var responseData:MonthPowerDataModel?
    var responseListData:[MonthPowerListDataModel] = []
    
    //    var userInfoModel:UserInfoModel?
    
    var selectedMonthCode:String = ""
    
    var monthInitList:[PickViewItem] = []
    
    var detailItems:[ReportPowerDetailItem] = []
    
    var selectedSceneModel:PondSceneModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "指标趋势"
        
        titleItemView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleItemView)
        
        titleItemView.isHidden = true
        
        
        self.tableView.register(UINib.init(nibName: "ReportPowerTableViewCell", bundle: nil), forCellReuseIdentifier: ReportPowerTableViewCellReuseID)
        
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
        
        // 获取鱼塘列表
        self.loadAllScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void {
        
        self.makeActivity(nil)
        
        self.client.getMonthPowerData(params:["device_mac":self.selectedSceneModel?.deviceMac ?? "-",
                                               "month_of_year":self.selectedMonthCode], callBack: { (data, error) in
                                                
                                                self.hiddenActivity()
                                                
                                                if let err = Parse.parseResponse(data, error) {
                                                    self.view.makeHint(err.showMessage)
                                                    self.responseData = nil
                                                    self.responseListData = []
                                                    self.buildNetDataToTableData()
                                                    self.tableView.reloadData()
                                                    return
                                                }
                                                
                                                if let d = data?.data {
                                                    self.responseData = d
                                                    if let responseList = d.list {
                                                        self.responseListData = responseList
                                                    }
                                                    
                                                    self.buildNetDataToTableData()
                                                    
                                                    self.tableView.reloadData()
                                                } else {
                                                    
                                                    self.responseData = nil
                                                    self.responseListData = []
                                                    
                                                    self.buildNetDataToTableData()
                                                    
                                                    self.tableView.reloadData()
                                                    
                                                    self.view.makeHint("数据获取失败，请稍后再试")
                                                }
        })
        
    }
    
    
    @IBAction func monthButtonTouchUpInSide(_ sender: Any)  {
        
        self.showSingleCustomPickerView(selectVal: self.selectedMonthCode, list: self.monthInitList, callback: { (item) in
            
            self.selectedMonthCode = item.code!
            self.monthLabelView.text = item.name
            
            self.loadData()
            
        })
    }
    
//    @IBAction func segmentValueChange(_ sender: AnyObject) {
//
//
////        self.selectedSegmentIndex = sender.selectedSegmentIndex
//
//        self.buildNetDataToTableData()
//
//        self.tableView.reloadData()
//    }
//
    
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
        
        let headerView = ReportPowerHeaderView.headerView()
        
        //        headerView.showData(model: self.userInfoModel)
        
        self.buildNetDataToLineChartData(chartView: headerView.lineChartView)
        self.buildNetDataToPieChartData(chartView: headerView.pieChartView)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 476
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: ReportPowerTableViewCellReuseID)
        
        
        guard let eCell = cell as? ReportPowerTableViewCell else {
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

//        let model = self.detailItems[index]
//
//        let detail = ReportIndexTrendDetailViewController()
//        detail.selectedModel = model
//        detail.selectedSceneModel = self.selectedSceneModel
//        self.navigationController?.pushViewController(detail, animated: true)
        
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
        
        var tableList:[ReportPowerDetailItem] = []
        tableList.append(ReportPowerDetailItem.init(date: "日期",value: "瓦时"))
        
        for item in self.responseListData {
            tableList.append(ReportPowerDetailItem.init(date: item.date ?? "-",
                                                   value: String(item.sum_wh ?? 0)))
        }
        
        self.detailItems = tableList
    }
    
    func buildNetDataToLineChartData(chartView: ReportLineChartView) {
        
        var labels:[String] = []
        
        var values:[ChartDataEntry] = []
        let title:[String] = ["电量"]
        
        for (index, element) in self.responseListData.enumerated() {
            labels.append(element.date ?? "-")
            values.append(ChartDataEntry.init(x: Double(index), y: element.sum_wh ?? 0))
        }
        
        chartView.setDataCount(dataEntrys: [values], label: labels, title: title)
        
    }
    
    
    func buildNetDataToPieChartData(chartView: ReportPieChartView) {
        
        var values:[PieChartDataEntry] = []
//        let title:[String] = ["电量"]
        
        var totalSum = 0.0
        
        if let list = self.responseData?.data_by_device {
            
            for (_, element) in list.enumerated() {
                totalSum += element.sum_wh ?? 0
            }
            
            
        }
        
        if let devicesSum = self.responseData?.data_by_device {
            
            for (_, element) in devicesSum.enumerated() {
                
                let val = ((element.sum_wh ?? 0) / totalSum ) * 100.0
                let formatVal = val.roundTo(places: 1)
                if formatVal > 0.0 {
                    values.append(PieChartDataEntry.init(value: formatVal , label: element.io_name))
                }
                
            }
            
            chartView.setDataCount(dataEntrys: values)
            
        }
        
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


extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
