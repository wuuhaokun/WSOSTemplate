//
//  WSDataBaseModel.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/8/14.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import ObjectMapper

protocol WSDataBaseModelDelegate {
    
    func getModelDataArray() -> [Any]
    
}

open class WSDataBaseModel: WSModelBase , WSDataBaseModelDelegate {
    
    open var modelDataArray:[Any] = []
    
    open func getModelDataArray() -> [Any] {
        return modelDataArray
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override open func mapping(map: Map) {
        super.mapping(map: map)
    }
    
    open func createApiDataModel(section:String, data:[Any]) {
        let apiDataModel:WSApiDataModel  = WSApiDataModel()
        apiDataModel.section = section
        apiDataModel.body = data
        modelDataArray.append(apiDataModel)
    }
    
}
