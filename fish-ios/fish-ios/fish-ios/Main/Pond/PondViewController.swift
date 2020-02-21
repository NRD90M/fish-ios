//
//  PondViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/15.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import Pageboy
//import Tabman
//import SwiftPopMenu

class PondViewController:TabmanViewController,PageboyViewControllerDataSource {
    
     var client: FishMainApi = FishMainApi()
    
    var sceneList:[PondSceneModel] = [];
    
    var viewControllers: [PondContentViewController] = []
    
    var popMenu:SwiftPopMenu!
    
    // modify TabmanScrollingButtonBar
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.dataSource = self
        self.automaticallyAdjustsChildScrollViewInsets = true
        // configure the bar
       
        
        self.bar.style = .scrollingButtonBar
        self.bar.location = .top
        
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in

            // customise appearance here
//            appearance.text.
//            appearance.text.color = UIColor.red
            appearance.style.background = .solid(color: UIColor.white)
//            appearance.indicator.isProgressive = true
        })
        
        self.embedBar(in: (self.navigationController?.navigationBar)!)
        
        
        if let bar =  self.tabmanBar as? TabmanScrollingButtonBar {
            
            let button = UIButton(type: UIButtonType.custom)
            bar.rightView.addSubview(button)
            button.autoPinEdgesToSuperviewEdges()
            button.setImage( UIImage(named: "icon_more"), for: UIControlState.normal)
            
            button.addTarget(self, action: #selector(showMenuBtnClick(btn:)), for: UIControlEvents.touchUpInside)
            
        }
        
        self.client.getAllScene() { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            if let d = data?.data, !d.isEmpty {
              self.sceneList = d
                
                self.viewControllers.removeAll()
                var barItems:[TabmanBar.Item] = []
                for model in self.sceneList {
//                    print(model)
                    let vc = PondContentViewController()
                    vc.pondSceneModel = model

                    self.viewControllers.append(vc)
                    
                   let sceneName = model.sceneName ?? "-"
                     barItems.append(Item(title: sceneName))
                }
                
                self.bar.items = barItems
                self.reloadPages()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        }
        
        websocketSetup()
    }
    
    func showMenuBtnClick(btn:UIButton) {
        
        let point = btn.convert(CGPoint(x: 0, y: 0), to: FishKeyWindow())
        //数据源（icon可不填）
        let popData = [("添加鱼塘"),
                       ("鱼塘配置"),
                       ("鱼塘重命名")]
        
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
            
            
            switch index {
            case 0:
                // 添加鱼塘
                break
            case 1:
             // 鱼塘配置
                let configuration = PondConfigurationViewController()
                
                if let val = self?.currentIndex {
                    configuration.selectedSceneModel = self?.sceneList[val]
                }
                
                let navi:FishNavigationController = FishNavigationController.init(rootViewController:configuration)
                self?.present(navi, animated: true, completion: nil)
                
//                self?.navigationController?.pushViewController(configuration, animated: true)
                break
            case 2:
                break
            default:
                let share = TestViewController()
                share.modalTransitionStyle = .crossDissolve
                share.modalPresentationStyle = .overFullScreen
                self?.present(share, animated: true, completion: nil)
            }
          
           
        }
        
        //show
        popMenu.show()
    }
    
    func websocketSetup() {
        /// 注: 端口后面必须要带/
        FishWebSocket.socketConnect(urlStr: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
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
