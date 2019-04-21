//
//  WSFont.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/26.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit

public enum WSFontSizeType: Int {
    case WSFontSize10 = 10
    case WSFontSize11 = 11
    case WSFontSize13 = 13
    case WSFontSize14 = 14
    case WSFontSize15 = 15
    case WSFontSize16 = 16
    case WSFontSize17 = 17
    case WSFontSize18 = 18
    case WSFontSize20 = 20
    case WSFontSize21 = 21
    case WSFontSize24 = 24
    case WSFontSize26 = 26
    case WSFontSize28 = 28
    case WSFontSize36 = 36
}

open class WSFont {

    private static func getRegularFont() ->String {
        return "PingFangTC-Regular";
    }
    
    private static func getMediumFont() ->String {
        return "PingFangTC-Medium";
    }
    
    public static func createRegularFont(fontSize:WSFontSizeType) ->UIFont {
        return (UIFont(name: getRegularFont(), size: CGFloat(fontSize.rawValue)))!
    }
    
    public static func createMediumFont(fontSize:WSFontSizeType) ->UIFont {
        return (UIFont(name: getMediumFont(), size: CGFloat(fontSize.rawValue)))!
    }
    
}
