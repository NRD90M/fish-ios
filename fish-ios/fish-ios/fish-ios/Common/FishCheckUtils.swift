//
//  FishCheckUtils.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/11/20.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

// 检查工具类
import Foundation

open class FishCheckUtils {
    
    /// 检查空
    public class func checkEmpty(_ checkString: String?) -> Bool {
        
        guard let check = checkString, !check.isEmpty else { return false }
        return true
    }
    
    /// 纯数字校验
    public class func checkOnlyNumerFormat(_ num: String?) -> Bool {
        
        guard let cont = num, !cont.isEmpty else { return false }
        
        let mobileRegex = "^\\d+$"
        
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobileRegex)
        
        return regexMobile.evaluate(with: cont)
    }
    
}
