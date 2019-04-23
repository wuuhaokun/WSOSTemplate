//
//  WSEmptyModel.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/3.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//


import ObjectMapper
public class WSEmptyModel: WSModelBase {

    public var content: String?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override public func mapping(map: Map) {
        super.mapping(map: map)
        content    <- map["content"]
    }

}
