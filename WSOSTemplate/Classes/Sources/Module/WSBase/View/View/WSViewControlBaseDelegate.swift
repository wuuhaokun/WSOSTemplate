//
//  WSViewControlBaseDelegate.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/1.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

public protocol WSViewControlBaseDelegate {
    
    func registerCellClass();
    func fetchDataFinished();
    func resizeTableView(frame:CGRect)
    func viewFinishedRefreshData(notification: Notification)
}
