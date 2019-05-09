//
//  WSEmptyCell.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/3.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import UIKit
import SnapKit

class WSEmptyCell: WSBaseCell {

    public lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = WSFont.createMediumFont(fontSize: .WSFontSize18)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    
    override var entity: Any? {
        didSet {
            //let modelEntity:WSEmptyModel = entity as! WSEmptyModel
            let noinformation:String = NSLocalizedString("no_information", comment: "")
            if noinformation == "no_information" {
                contentLabel.text = "There is currently no information"
            }
            else {
                contentLabel.text = noinformation
            }
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
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 26))
            make.center.equalTo(contentView)
        }
    }
    
    //If you are not using auto layout, override this method, enable it by setting "fd_enforceFrameLayout" to YES.
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let totalHeight: CGFloat = CGFloat(56)
        return CGSize(width: size.width, height: totalHeight)
    }
    
    var withSeparator: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !withSeparator {
            self.removeBottomSeparator()
        }
    }
    
}

extension UITableViewCell {
    func removeBottomSeparator() {
        // Remove it if it's found.
        for view in self.subviews where String(describing: type(of: view)).hasSuffix("SeparatorView") {
            view.removeFromSuperview()
        }
    }
}
