//
//  WSDataManagerBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation
import ObjectMapper

open class WSDataManagerBase : NSObject , WSDataManagerDelegateBase {

    open var page:Int = 1
    open var apiDataModelSections: [WSApiDataModel] = []
    open var baseDataManagerDelegate: WSDataManagerDelegateBase?
    
    override required public init() {
    }
    
    open func loadApiRequestsData(_ entitiesData: (([Any], SBErrorType) -> Void)!, _ parameter: Any?) {
        entitiesData([],SBErrorType.ConnectError)
    }
    
    open func loadApiCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
        entitiesData([],SBErrorType.ConnectError)
    }
    
    open func loadApiRequestsMoreData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        //entitiesData([],SBErrorType.ConnectError)
    }

    public func handleEmptyData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
        let emptyDict = [["prefixCell":"WSEmpty","prefixModel":"WSEmpty","content":"no_information"]]
        let moreDataArray:[WSEmptyModel] = Mapper<WSEmptyModel>().mapArray(JSONArray: (emptyDict) as Array)
        var entitySections: [[Any]] = []
        entitySections.append(moreDataArray);
        self.convertToApiDataModel(entitiesApiData:entitySections)
        if (self.apiDataModelSections.count) > 0 {
            entitiesData((self.apiDataModelSections),SBErrorType.ConnectError)
        }
    }
    
    open func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
        self.baseDataManagerDelegate?.loadApiCacheData({  [weak self] entitiesApiData,error in
            print("")
            if (entitiesApiData is [WSApiDataModel]) == false {
                self?.convertToApiDataModel(entitiesApiData:entitiesApiData)
                if (self?.apiDataModelSections.count)! > 0 {entitiesData((self?.apiDataModelSections)!,SBErrorType.ConnectError)
                }
                else {
                    self?.baseDataManagerDelegate?.handleEmptyData(entitiesData)
                }
                return
            }
            if entitiesApiData.count > 0 {
                entitiesData((entitiesApiData),SBErrorType.ConnectError)
            }
            else {
                self?.baseDataManagerDelegate?.handleEmptyData(entitiesData)
            }
        });
    }
    
    open func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        self.page = 1
        self.baseDataManagerDelegate?.loadApiRequestsData({  [weak self] entitiesApiData,error in
            print("")
            self?.apiDataModelSections.removeAll()
            if (entitiesApiData is [WSApiDataModel]) == false {
                self?.convertToApiDataModel(entitiesApiData:entitiesApiData)
                if (self?.apiDataModelSections.count)! > 0 {
                    entitiesData((self?.apiDataModelSections)!,SBErrorType.ConnectError)
                }
                else {
                    self?.baseDataManagerDelegate?.handleEmptyData(entitiesData)
                }
                return
            }
            if (entitiesApiData.count > 0) && ((entitiesApiData[0] as! WSApiDataModel).body?.count ?? 0) > 0 {
                for apiDataModel in entitiesApiData {
                    self?.apiDataModelSections.append(apiDataModel as! WSApiDataModel)
                }
                entitiesData(((self?.apiDataModelSections)!),SBErrorType.ConnectError)
                
//                let apiDataModel:WSApiDataModel = entitiesApiData[0] as! WSApiDataModel
//                self?.apiDataModelSections.append(apiDataModel)
//                entitiesData(((self?.apiDataModelSections)!),SBErrorType.ConnectError)
            }
            else {
                self?.baseDataManagerDelegate?.handleEmptyData(entitiesData)
            }
        }, parameter);
    }
    
    open func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        self.baseDataManagerDelegate?.loadApiRequestsMoreData({ [weak self] entitiesApiData,error in
            var body:[Any]? = []
            if (entitiesApiData.count > 0) && ((entitiesApiData[0] as! WSApiDataModel).body?.count ?? 0) > 0 {
                let apiDataModel:WSApiDataModel = entitiesApiData[0] as! WSApiDataModel
                body = apiDataModel.body!
                self?.apiDataModelSections.append(apiDataModel)
                self?.page += 1
            }
            entitiesData((self?.apiDataModelSections)!, body!,SBErrorType.ConnectError)
        }, parameter);
    }
    
    // MARK: Private method
    private func convertToApiDataModel(entitiesApiData:[Any]) {
        self.apiDataModelSections.removeAll()
        for rootData in entitiesApiData {
            let apiDataModel = WSApiDataModel()
            apiDataModel.section = ""
            apiDataModel.body = rootData as? Array<Any>
            self.apiDataModelSections.append(apiDataModel)
        }
    }
    
    private func addEmptyDefaultCell() {
        
    }
    
}
