//
//  WSHomeModel.swift
//  CPMVPTemplate
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Pods_WSOSTemplate_Example
import ObjectMapper

class WSTableViewModel: WSModelBase {

    var title: String?
    var content: String?
    var username: String?
    var time: String?
    var imageName: String?
    
    required public init?(map: Map) {
        super.init()
        //fatalError("init(map:) has not been implemented")
        prefixCell = "WSTableView"
        prefixModel = "WSTableView"
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        
        title    <- map["title"]
        content    <- map["content"]
        username    <- map["username"]
        imageName    <- map["imageName"]
        time    <- map["time"]
   
    }
    
}

