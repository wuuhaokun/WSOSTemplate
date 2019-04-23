//
//  WSHttpRequestsModel.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

//import UIKit
import ObjectMapper

class WSSectionBaseModel: WSModelBase {
    
    var section: String?
    var data: Any?
    required init?(map: Map) {
        super.init(map: map)
        section = ""
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        section      <- map["section"]
    }
    
}

open class WSHttpRequestsModel: WSModelBase {

    open var status: Bool?
    open var httpStatus: Int?
    open var data:Any?
    open var error:String?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override open func mapping(map: Map) {
        super.mapping(map: map)
        status      <- map["status"]
        httpStatus  <- map["httpStatus"]
        data        <- map["data"]
        error       <- map["error"]
    }
    
}

open class WSFormDataModel: WSModelBase {
    
    open var name: String?
    open var image: UIImage?
    open var mimeType: String?
    open var fileExtension: String?
    
    public init?(image:UIImage, name:String, mimeType:String = "image/jpeg", fileExtension:String = ".jpeg") {
        super.init()
        self.image = image
        self.name = name
        self.mimeType = mimeType
        self.fileExtension =  fileExtension
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override open func mapping(map: Map) {
        super.mapping(map: map)
        image <- map["image"]
        name <- map["name"]
        mimeType <- map["fileType"]
        fileExtension <- map["fileExtension"]
    }
    
}

