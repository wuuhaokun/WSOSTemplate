//
//  WSColor.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/5.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

public struct WSColor {
    
    public static let organize = UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
    public static let white = UIColor(white: 255.0 / 255.0, alpha: 1.0)
    public static let black = UIColor(white: 0.0, alpha: 1.0)
    public static let gray = UIColor(white: 239.0 / 255.0, alpha: 1.0)
    public static let blueyGrey = UIColor(red: 157.0 / 255.0, green: 172.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0)
    public static let coolGrey = UIColor(red: 144.0 / 255.0, green: 150.0 / 255.0, blue: 159.0 / 255.0, alpha: 1.0)
    public static let black87 = UIColor(white: 0.0, alpha: 0.87)
    public static let blackTwo = UIColor(white: 41.0 / 255.0, alpha: 1.0)
    public static let warmGrey = UIColor(white: 157.0 / 255.0, alpha: 1.0)
    public static let pinkishGrey = UIColor(white: 209.0 / 255.0, alpha: 1.0)
    public static let silver = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
    public static let greyish = UIColor(white: 173.0 / 255.0, alpha: 1.0)
    public static let brownishGrey87 = UIColor(white: 106.0 / 255.0, alpha: 0.87)
    public static let brownishGrey = UIColor(white: 106.0 / 255.0, alpha: 1.0)
    public static let warmGrey87 = UIColor(white: 131.0 / 255.0, alpha: 0.87)
    public static let greyish87 = UIColor(white: 182.0 / 255.0, alpha: 0.87)
    public static let white50 = UIColor(white: 255.0 / 255.0, alpha: 0.5)
    public static let darkGrey2 = UIColor(red: 191.0 / 255.0, green: 196.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    public static let lightSalmon = UIColor(red: 1.0, green: 158.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    public static let palePeach = UIColor(red: 1.0, green: 222.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    public static let lightRose = UIColor(red: 1.0, green: 192.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    public static let palePeblack54ach = UIColor(white: 0.0, alpha: 0.54)

}

extension WSColor {
    static func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension UIColor {
    convenience public init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
