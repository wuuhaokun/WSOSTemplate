//
//  WSSectionCell.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/24.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit
import SnapKit

class WSSectionCell: WSBaseCell {

    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = WSFont.createMediumFont(fontSize: WSFontSizeType.WSFontSize17)
        contentLabel.textColor = WSColor.black
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        return contentLabel
    }()
    
    override var entity: Any? {
        didSet {
            let modelEntity:WSSectionModel = entity as! WSSectionModel
            let noinformation:String = NSLocalizedString(modelEntity.content!, comment: "")
            contentLabel.text = noinformation
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setupAutolayout()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(contentLabel)
    }
    
    func setupAutolayout() {
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.size.equalTo(CGSize(width: 150, height: 26))
            make.centerY.equalTo(contentView)
        }
    }
    
    //If you are not using auto layout, override this method, enable it by setting "fd_enforceFrameLayout" to YES.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let totalHeight: CGFloat = 40
        return CGSize(width: size.width, height: totalHeight)
    }

}
