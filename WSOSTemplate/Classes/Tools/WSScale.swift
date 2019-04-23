//
//  WSScale.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/12.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit

let rateWidth = (UIScreen.main.bounds.width/375)
let rateHeigh = (UIScreen.main.bounds.height/667)

//375X667
public struct WSScale {
    
    public static func scaleWidth(width:CGFloat) ->CGFloat {
        return (width * rateWidth)
    }
    
    public static func scaleHeigh(heigh:CGFloat) ->CGFloat {
        return (heigh * rateHeigh)
    }
    
}
