//
//  WSDispatchDelay.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/3.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

class WSDispatchDelay {
    
    typealias Task = (_ cancel: Bool) ->()
    
    func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->())? = task
        var result: Task?
        let delayedClosure: Task = { cancel in
            if let internalClosure = closure {
                if cancel == false {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }
    
}
