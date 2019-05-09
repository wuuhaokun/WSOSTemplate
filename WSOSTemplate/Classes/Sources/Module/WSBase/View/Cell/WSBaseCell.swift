//
//  WSBaseCell.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit

open class WSBaseCell: UITableViewCell {
    
    open var guideHeight:Int = 0
    open var entity: Any?
 
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.selectionStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


