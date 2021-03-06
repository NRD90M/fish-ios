//
//  LoginViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/14.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class LoginViewController: FishPreViewController {

    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var verifyButton:UIButton!
    
    @IBOutlet weak var mobileTextInput:UITextField!
    @IBOutlet weak var verifyTextInput:UITextField!
    
     @IBOutlet weak var gradientView:UIView!
    
    var client: FishMainApi = FishMainApi()
    
    var timer: VerifyCodeTimer = VerifyCodeTimer.init(uuid: "ST_LOGIN_VERIFYCODE")
    
    init() {
        super.init(nibName: "LoginViewController", bundle: Bundle.main)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createGradientLayer()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.mobileTextInput.text  = "18616514687"
        self.verifyTextInput.text  = "805225"
        
        self.timer.delegate = self
        // Do any additional setup after loading the view.
        
        //设置路径后立即播放,默认true
//        videoView.isAutoPlay = false
        //设置路径
//        videoView.url = "http://baobab.wandoujia.com/api/v1/playUrl?vid=2616&editionType=normal"
        //以下选配
        //设置封面
//        videoView.coverImageView()?.image = UIImage(named: "launchNew.png")
//        videoView.playerTitle = "leefeng.me"
        //协议
//        videoView.playerProtocol = self

//        videoView.startLoadData()
        
//        self.makeActivity(nil)
//        self.client.getCamsConfig(params: ["deviceMac":"b827eb170977"]) { (data, error) in
//
//            self.hiddenActivity()
////            self.tableView?.mj_header?.endRefreshing()
//
//            if let err = Parse.parseResponse(data, error) {
//                self.view.makeHint(err.showMessage)
//                return
//            }
//            if let d = data?.data {
//
//                let usableCams:[CameraInfoModel] = d.usable_cams!
//
//
//            } else {
//                self.view.makeHint("数据获取失败，请稍后再试")
//            }
//
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - action
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        
        if self.mobileTextInput.isFirstResponder {
            self.mobileTextInput.resignFirstResponder()
        }
        
        if self.verifyTextInput.isFirstResponder {
            self.verifyTextInput.resignFirstResponder()
        }
        
        
//        let pickerVC = DevicePickerViewController()
//        pickerVC.modalTransitionStyle = .coverVertical
//        pickerVC.modalPresentationStyle = .overFullScreen
//
//        pickerVC.reset(code: "feeder1")
//
//        pickerVC.confirmCallBack = { (val :PondIOInfoModel) in
//            //确定按钮回调
//            print(val.name)
//        }
//
//        self.view.makeActivity()
//
//        pickerVC.startLoadingData(deviceMac:"b827eb170977") { (success, error) in
//
//            self.view.hiddenActivity()
//
//            if success {
//                self.present(pickerVC, animated: true, completion: nil)
//            } else {
//                self.view.makeHint(error)
//            }
//        }
        
//
//        let share = MoviePlayDemoViewController()
////        share.modalTransitionStyle = .coverVertical
////        share.modalPresentationStyle = .overFullScreen
//        self.present(share, animated: true, completion: nil)
//
        loginRequest()
    }
    
    
    
    @IBAction func verifyButtonTouchUpInside(_ sender: Any) {
        
        if self.mobileTextInput.isFirstResponder {
            self.mobileTextInput.resignFirstResponder()
        }
        
        if self.verifyTextInput.isFirstResponder {
            self.verifyTextInput.resignFirstResponder()
        }
        verifyCodeRequest()
    }
    
    
    func loginRequest() {
        
        let phoneNum = self.mobileTextInput.text
        let verifyCode = self.verifyTextInput.text
        
        guard FishCheckUtils.checkEmpty(phoneNum) else {
            self.view.makeHint("请输入手机号")
            return
        }
        
        guard FishCheckUtils.checkEmpty(verifyCode) else {
            self.view.makeHint("请输入验证码")
            return
        }
        
        guard FishCheckUtils.checkOnlyNumerFormat(verifyCode) else {
            self.view.makeHint("验证码格式不正确")
            return
        }

        self.makeActivity(nil)
        
        self.client.login(params: ["mobile": phoneNum!, "vali_code": verifyCode!]) { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            
            
            if let d = data?.data, !d.isEmpty {
                FishUserInfo.setToken(d)
                self.hiddenActivity()

                NotificationCenter.default.post(name: NSNotification.Name.AlterTabBarToRootViewController, object: nil)
            } else {
                self.view.makeHint("登录失败，请稍后再试")
            }
        }
    }
    
    func verifyCodeRequest() {
        
        
        let phoneNum = self.mobileTextInput.text
        
        guard FishCheckUtils.checkEmpty(phoneNum) else {
            self.view.makeHint("请输入手机号")
            return
        }
        
        self.makeActivity(nil)
        
        self.client.sendVerifyCode(params: ["mobile": phoneNum!]) { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            self.hiddenActivity()
            // 开始倒计时
            self.timer.beginVerifyCodeTimer()
        }
    }
    
    
    
    var gradientLayer: CAGradientLayer!
    
    //初始化gradientLayer并设置相关属性
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.colorWithHexString("#65ABEB")!.cgColor, UIColor.colorWithHexString("#3F97E8")!.cgColor]
        //将gradientLayer作为子layer添加到主layer上
        self.gradientView.layer.addSublayer(gradientLayer)
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


extension LoginViewController: VerifyCodeTimerDelegate {
    
    func verifyCodeTimerFinsh() {
        self.verifyButton.isEnabled = true
        self.verifyButton.setTitle("获取验证码", for: UIControlState.normal)
    }
    
    func verifyCodeTimerUpdate(leftTime: Int) {
        self.verifyButton.setTitle(String(leftTime).appending("s后重试"), for: UIControlState.normal)
        self.verifyButton.isEnabled = false
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        SMMainAsync { self.viewModel.login(vf: self.code()) }
        loginRequest()
        
        return true
    }
}



//extension LoginViewController: PlayerProtocol {
//
//    func playerStartComplete() {
//        print("playerStartComplete")
//        videoView.url = "http://baobab.wandoujia.com/api/v1/playUrl?vid=2614&editionType=normal"
//    }
//
//    func playerStartPause() {
//        print("playerStartPause")
//    }
//
//    func playerStartPlay() {
//        print("playerStartPlay")
//    }
//
//}
