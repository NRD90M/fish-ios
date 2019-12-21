//
//  UIExtension.swift
//  KKSwiftFactory
//
//  Created by KING on 2016/12/6.
//  Copyright © 2016年 KING. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    public class func colorWithHexString (_ hexString:String?)-> UIColor? {
        
        return UIColor.init(hexString: hexString)
    }
    
    /**
     支持0x、#开头的6位或8位(alpha)的字符串转换为颜色
     如果不为6位或8位，小于6位，前面补0至6位。小于8位，前面补0至8位
     
     - parameter hexString: 十六进制字符串
     
     - returns: UIColor
     */
    public convenience init?(hexString: String?) {
        
        guard var hex = hexString else {
            return nil
        }
        
        func hex2dec(_ num:String) -> Float {
            let str = num.uppercased()
            var sum:Float = 0
            for i in str.utf8 {
                sum = sum * 16 + Float(i) - 48 // 0-9 从48开始
                if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                    sum -= 7
                }
            }
            return sum
        }
        hex = hex.replacingOccurrences(of: "0x", with: "")
        hex = hex.replacingOccurrences(of: "#", with: "")
        if hex.characters.count > 8 {
            hex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: hex.characters.count - 8))
        }
        
        let count = hex.characters.count
        
        let count0 = ((count == 6 || count == 8) ? 0 : (count < 6 ? 6 - count : (count < 8 ? 8 - count : 0)))
        
        hex = String.init(repeating: "0", count: count0) + hex
        
        let containAlpha = hex.characters.count == 8
        
        let alpha = hex.characters.index(hex.startIndex, offsetBy: 0)
        let red = hex.characters.index(hex.startIndex, offsetBy: containAlpha ? 2 : 0)
        let green = hex.characters.index(red, offsetBy: 2)
        let blue = hex.characters.index(green, offsetBy: 2)
        
        let alphaStr: String = hex.substring(with: alpha..<(hex.characters.index(alpha, offsetBy: 2)))
        let redStr = hex.substring(with: red..<(hex.characters.index(red, offsetBy: 2)))
        let greenStr = hex.substring(with: green..<(hex.characters.index(green, offsetBy: 2)))
        let blueStr = hex.substring(with: blue..<(hex.characters.index(blue, offsetBy: 2)))
        
        self.init(red:CGFloat(hex2dec(redStr))/255.0,
                  green:CGFloat(hex2dec(greenStr)) / 255.0,
                  blue:CGFloat(hex2dec(blueStr)) / 255.0,
                  alpha: containAlpha ? CGFloat(hex2dec(alphaStr)) / 255.0 : 1)
        
    }
    
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public class func color4A() -> UIColor {
        return UIColor.init(hexString: "#4a4a4a")!
    }
    
    public class func color9B() -> UIColor {
        return UIColor.init(hexString: "#9b9b9b")!
    }
    
    public class func eee() -> UIColor {
        return UIColor.init(hexString: "#eeeeee")!
    }
    
    public class func color333() -> UIColor {
        return UIColor.init(hexString: "#333333")!
    }
    
    public class func colorf8() -> UIColor {
        return UIColor.init(hexString: "#f8f8f8")!
    }
    
    public class func color79() -> UIColor {
        return UIColor.init(hexString: "#797979")!
    }
}

