//
//  WSModelBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/27.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit
import ObjectMapper

open class WSBaseSection<T>  {
    open var section: String? = ""
    open var data: T?
    open var dataArray: [T]?
    public init(_ section:String) {
        self.section = section
    }
}

open class WSModelBase: Mappable {
    
    open var prefixCell: String?
    open var prefixModel: String?
    
    public init() {
    }
    
    required public init?(map: Map) {
    }
    
    open func mapping(map: Map) {
        prefixCell      <- map["prefixCell"]
        prefixModel    <- map["prefixModel"]
    }
}

