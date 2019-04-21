//
//  WSInteractorBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation

open class WSInteractorBase : NSObject, WSInteractorInputBase {
    
    public var output : WSInteractorOutputBase?
    open var dataManager : WSDataManagerBase?//=  WSDataManagerBase()
    
    override required public init() {
    }
    
    // MARK: InteractorInput
    public func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!) {
        return (self.dataManager?.fetchCacheData(entitiesData))!
    }
    
    public func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        self.dataManager?.fetchData(entitiesData, parameter)
    }
    
    public func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any? = nil) {
        self.dataManager?.fetchMoreData(entitiesData, parameter)
    }
    
}
