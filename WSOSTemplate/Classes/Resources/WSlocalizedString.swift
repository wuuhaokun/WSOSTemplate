//
//  WSlocalizedString.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/25.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

//extension String {
//    public static func localizedString(key: String, comment: String) -> String {
//        return NSLocalizedString(key, comment: comment)
//    }
//}

public class WSlocalizedString: NSObject {

    public static func localizedString(key: String,comment: String="") -> String {
        return NSLocalizedString(key, comment: comment)
    }

    public static func string(key: String,comment: String="") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
}

extension String {
    
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: UIFont, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize.zero
        
    }
    //    /**获取字符串高度H*/
    public func getNormalStrH(str: String, font: UIFont, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: font, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    //    /**获取字符串宽度W*/
    public func getNormalStrW(str: String, font: UIFont, h: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: font, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    //    /**获取富文本字符串高度H*/
    public func getAttributedStrH(attriStr: NSMutableAttributedString, font: UIFont, w: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: font, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    /**获取富文本字符串宽度W*/
    public func getAttributedStrW(attriStr: NSMutableAttributedString, font: UIFont, h: CGFloat) -> CGFloat {
        return getNormalStrSize(attriStr: attriStr, font: font, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    public func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    public func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    public func localizedString(key: String,comment: String="") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    public func string(key: String,comment: String="") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
