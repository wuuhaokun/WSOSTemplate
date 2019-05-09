//
//  WSInteractorBaseIO.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import Foundation

public protocol WSInteractorInputBase {
    
    func fetchCacheData(_ entitiesData: (([Any],SBErrorType) -> Void)!)
    func fetchData(_ entitiesData: (([Any],SBErrorType) -> Void)!, _ parameter:Any?)
    func fetchMoreData(_ entitiesData: (([Any],[Any],SBErrorType) -> Void)!, _ parameter:Any?)
    
}

public protocol WSInteractorOutputBase {
    
}
