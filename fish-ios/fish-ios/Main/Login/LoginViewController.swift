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
    
    var client: FishMainApi = FishMainApi()
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - action
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func verifyButtonTouchUpInside(_ sender: Any) {
        
        let phoneNum = self.mobileTextInput.text
        
        self.client.sendVerifyCode(params: ["mobile": phoneNum]) { (data, error) in
            
            self.makeActivity(data?.message)
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
