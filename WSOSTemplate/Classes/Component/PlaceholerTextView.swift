//
//  PlaceholerTextView.swift
//  PlaceholderTextView
//
//  Created by 张宇 on 2018/2/7.
//  Copyright © 2018年 张宇. All rights reserved.
//

import UIKit

//plaleLabel 的位置
struct PlaceholderLabelOrigin {
    let x = 8.0
    let y = 8.0
}

//内边距，可根据个人手动调整
struct TextContainerInset{
    let top:CGFloat = 8.0
    let left:CGFloat = 4.0
    let bottom:CGFloat = 8.0
    let right:CGFloat = 4.0
}

open class PlaceholerTextView: UITextView {
    
    //MARK: - 懒加载属性
    lazy public var plaleLabel = UILabel()
    lazy public var countLabel = UILabel()
    
    //储存属性
    @objc public var placeholderGlobal:String?{      //提示文字
        didSet{
            plaleLabel.text = placeholderGlobal
            plaleLabel.sizeToFit()
        }
    }
    @objc public var placeholderColorGlobal:UIColor?{
        didSet{
            plaleLabel.textColor = placeholderColorGlobal
        }
    }
    @objc public var isReturnHidden:Bool = false     //是否点击返回失去响应
    @objc public var isShowCountLabel:Bool = false { //是否显示计算个数的Label
        didSet{
            countLabel.isHidden = !isShowCountLabel
        }
    }
    @objc public var limitWords:UInt = 999999             //限制输入个数   默认为999999，不限制输入
    
    
    //MARK: - 系统方法
    /// PlaceholerTextView 唯一初始化方法
    convenience public init(placeholder:String?,placeholderColor:UIColor?,frame: CGRect, placeholderFont:UIFont?) {
        self.init(frame: frame)
        self.font = placeholderFont
        setup(placeholder: placeholder, placeholderColor: placeholderColor)
        placeholderGlobal = placeholder
        placeholderColorGlobal = placeholderColor
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    //XIB 调用
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(placeholder: nil, placeholderColor: nil)
    }
    
    public func showHiddenPlaceholder() {
        self.checkShowHiddenPlaceholder()
    }
}

//MARK: - 自定义UI
extension PlaceholerTextView{
    
    /// placeholder Label Setup
    public func setup(placeholder:String?,placeholderColor:UIColor?){
        
        delegate = self
        if font == nil {
            font = UIFont.systemFont(ofSize: 14)
        }
        
        plaleLabel.textColor = placeholderColor
        plaleLabel.textAlignment = .left
        plaleLabel.font = font
        plaleLabel.text = placeholder
        plaleLabel.sizeToFit()
        addSubview(plaleLabel)
        plaleLabel.frame.origin = CGPoint(x: PlaceholderLabelOrigin().x, y: PlaceholderLabelOrigin().y)
        textContainerInset = UIEdgeInsets.init(top: TextContainerInset().top, left: TextContainerInset().left, bottom: TextContainerInset().bottom, right: TextContainerInset().right)
        print(plaleLabel)
        countLabel.font = font
        addSubview(countLabel)
    }
    
}


//MARK: - UITextViewDelegate代理方法
extension PlaceholerTextView : UITextViewDelegate{
    
    public func textViewDidChange(_ textView: UITextView) {
        checkShowHiddenPlaceholder()
        countLabel.text = "\(textView.text.count)/\(limitWords)"
        countLabel.sizeToFit()
        countLabel.frame.origin = CGPoint(x: frame.width-countLabel.frame.width-10, y: frame.height-countLabel.frame.height-5)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text=="\n"&&isReturnHidden==true {
            textView.resignFirstResponder()
        }
        
        //大于等于限制字数，而且不是删除键的时候不可以输入。
        if range.location+range.length >= limitWords && !(text as NSString).isEqual(to: ""){
            return false
        }
        
        return true
    }
    
    
}

//MARK : - 工具方法

extension PlaceholerTextView {
    
    ///根据textView是否有内容显示placeholder
    public func checkShowHiddenPlaceholder(){
        if self.hasText {
            plaleLabel.text = nil
            countLabel.isHidden = false
        }else{
            plaleLabel.text = placeholderGlobal
            countLabel.isHidden = true
        }
    }
    
}
