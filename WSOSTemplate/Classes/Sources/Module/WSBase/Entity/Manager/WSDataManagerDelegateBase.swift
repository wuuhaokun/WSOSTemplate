//
//  WSDataManagerDelegateBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/6/29.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

public enum SBErrorType {
    case ConnectError
    case ConnectSuccess
}

public protocol WSDataManagerDelegateBase /*: AnyObject*/{
    
    func loadApiCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!);
    func loadApiRequestsData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any?);
    func loadApiRequestsMoreData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any?);
    func handleEmptyData(_ entitiesData: (([Any],SBErrorType) -> Void)!)
    
}



