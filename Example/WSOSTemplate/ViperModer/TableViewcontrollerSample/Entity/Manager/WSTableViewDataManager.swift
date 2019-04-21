//
//  WSTableViewManagerBase.swift
//  CPMVPTemplate
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Pods_WSOSTemplate_Example
import SwiftyJSON
import Pods_WSOSTemplate_Example

class WSTableViewDataManager: WSDataManagerBase , WSTableViewDataManagerDelegate {
    
    func test() -> Int {
        print("dddd")
        return 1
    }
    
    override func loadApiRequestsData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any?) {
        print("")
        let responseConfigure:WSResponseConfigure =  WSResponseConfigure<WSTableViewModel>()
        
        guard let dataFilePath = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: dataFilePath))
            let jsonString = JSON(data).description
            let dataBaseModel = WSRequestsDataHandler.ObjectMapperArraySerializer(responseConfigure, json:jsonString)
            
            let apiDataModel:WSApiDataModel  = WSApiDataModel()
            apiDataModel.section = ""
            apiDataModel.body = dataBaseModel
            var modelDataArray:[WSApiDataModel] = []
            modelDataArray.append(apiDataModel)
            entitiesData(modelDataArray , SBErrorType.ConnectSuccess)
        } catch let error {
            print(error)
        }
    }
    
}
