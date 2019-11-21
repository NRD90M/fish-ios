//
//  TimerViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/15.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Pageboy
//import Tabman

class TimerViewController:  TabmanViewController, PageboyViewControllerDataSource {

    lazy var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        
        viewControllers.append(TimerClockViewController())
        viewControllers.append(TimerTriggerViewController())
        
        return viewControllers
    }()
    
    var popMenu:SwiftPopMenu!
    
    var titleItemView:HorizontalTitleItemView = HorizontalTitleItemView.titleItemView()
    
    var client: FishMainApi = FishMainApi()
    
    var sceneList:[PondSceneModel] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.dataSource = self
        self.automaticallyAdjustsChildScrollViewInsets = true
        // configure the bar
        self.bar.items = [Item(title: "定时"),
                          Item(title: "触发")]
        
        self.bar.style = .buttonBar
        self.bar.location = .top
        
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in

            appearance.style.background = .solid(color: UIColor.white)
        })
        
       titleItemView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleItemView)
        
        titleItemView.isHidden = true
        // 获取鱼塘列表
        self.loadAllScene()
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
                
                if self?.currentViewController is TimerClockViewController {
                    let timerClock = self?.currentViewController as! TimerClockViewController
                    timerClock.refreshSelectedSceneModel(model: model)
                }
                
                if self?.currentViewController is TimerTriggerViewController {
                    let timerTrigger = self?.currentViewController as! TimerTriggerViewController
                    timerTrigger.refreshSelectedSceneModel(model: model)
                }
                
            }

            
        }
        
        //show
        popMenu.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Net Request
    
    func loadAllScene() {
        
        self.client.getAllScene() { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let d = data?.data, !d.isEmpty {
                self.sceneList = d
                if (self.sceneList.count > 0) {
                    self.titleItemView.isHidden = false
                    self.titleItemView.reloadSelectedPond(model: self.sceneList[0])
                    
                    if self.currentViewController is TimerClockViewController {
                        let timerClock = self.currentViewController as! TimerClockViewController
                        timerClock.refreshSelectedSceneModel(model: self.sceneList[0])
                    }
                    
                    if self.currentViewController is TimerTriggerViewController {
                        let timerTrigger = self.currentViewController as! TimerTriggerViewController
                        timerTrigger.refreshSelectedSceneModel(model: self.sceneList[0])
                    }
                    
                }
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        }
    }
    
    // MARK : PageboyViewController
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
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

//开启右滑返回手势:
extension TimerViewController:HorizontalTitleItemViewDelegate {
   
    func showMore() {
        self.showMenuBtnClick(view: self.titleItemView)
    }
    
}

