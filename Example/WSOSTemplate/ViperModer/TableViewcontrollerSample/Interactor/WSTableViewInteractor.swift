//
//  WSHomeInteractor.swift
//  CPMVPTemplate
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Pods_WSOSTemplate_Example

class WSTableViewInteractor: WSInteractorBase, WSTableViewInteractorInput {
    
    public var selfDataManager : WSTableViewDataManager?
        
    override var dataManager: WSDataManagerBase? {
        didSet {
            self.selfDataManager = (self.dataManager as? WSTableViewDataManager)
            
        }
    }
    
    required public init() {
        super.init()
    }
    
    func test() -> Int {
        return self.selfDataManager?.test() ?? 0
    }
    
}
