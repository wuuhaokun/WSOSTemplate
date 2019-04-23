//
//  LCPicker.swift
//  CustomUIPicker
//
//  Created by Carlos Mejia on 9/11/17.
//  Copyright © 2017 LCMG. All rights reserved.
//

import Foundation
import UIKit

open class LCPicker : UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    
    public var bottom : CGFloat = 0
    public var view : UIView = UIView()
    public var selectedIndex : Int = 4
    var backgroundView : CustomContainer = CustomContainer()
    
    public let pickerView : UIPickerView = UIPickerView()
    public var pickerData : [String] = ["五金行","百貨","電器","航空"]
    
    public var title : String = "Pick an option"
    public var doneButtonLabel: String = "Done"
    public var cancelButtonLabel: String = "Cancel"
    
    public var doneCallback : (Int) -> Void = {result in }
    public var changeCallback : (Int) -> Void = {result in }
    
    public func show(bottom: CGFloat ,view : UIView, title : String?, doneText : String?, cancelText : String?, data: [String]?, selectedIndex: Int?, doneHandler : @escaping (Int) -> (), changeHandler: @escaping (Int) -> ()){
        
        self.bottom = bottom
        self.view = view
        
        if let title = title{
            self.title = title
        }
        
        if let doneText = doneText{
            self.doneButtonLabel = doneText
        }
        
        if let cancelText = cancelText{
            self.cancelButtonLabel = cancelText
        }
        
        if let title = title{
            self.title = title
        }
        
        if let selectedIndex = selectedIndex{
            self.selectedIndex = selectedIndex
        }
        
        if let data = data{
            self.pickerData = data
        }

        self.changeCallback = changeHandler
        
        self.doneCallback = doneHandler
        
        self.performShow(doneHandler : doneHandler)
    }
    
    public func performShow(doneHandler : @escaping (Int) -> ()) {
        
        // Initialize the toolbar with Cancel and Done buttons and title
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barStyle = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? .default : .blackTranslucent
        toolbar.backgroundColor = .white
        
        var buttons : [UIBarButtonItem] = []
        
        // Create Cancel button
        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: cancelButtonLabel, style: .plain, target: self, action: #selector(self.didDismissWithCanelButton(_:)))
        
        buttons.append(cancelButton)
        
        // Create title label aligned to center and appropriate spacers
        let flexSpace : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        buttons.append(flexSpace)
        
        let label : UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 180.0, height: 30.0))
        label.textAlignment = .center
        label.textColor = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? UIColor.black : UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.backgroundColor = UIColor.clear
        label.text = title
        
        let labelButton : UIBarButtonItem = UIBarButtonItem(customView: label)
        
        buttons.append(labelButton)
        buttons.append(flexSpace)
        
        // Create Done button
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: doneButtonLabel, style: .done, target: self, action: #selector(self.didDismissWithDoneButton(_:)))
        
        buttons.append(doneButton)
        
        toolbar.setItems(buttons, animated: true)
        
        // Create background view
        backgroundView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.60)
        
        // Create picker view
        pickerView.frame = CGRect(x: 0.0, y: 44.0, width: view.frame.width, height: 216.0)
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        pickerView.selectRow(self.selectedIndex, inComponent: 0, animated: true)
        
        //make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        
        // Create container
        let pickerContainerView : UIView = UIView()
        //let bottom:CGFloat = superview?.safeAreaInsets.bottom ?? 0
        
        pickerContainerView.frame = CGRect(x: 0.0, y: (view.frame.height - 260 - self.bottom), width: view.frame.width, height: 260.0)
        //let yyy = view.safeAreaLayoutGuide
        
        
//        pickerContainerView.snp.makeConstraints { (make) in
//            make.left.equalTo(view)
//            make.top.equalTo((superview?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
//            make.size.equalTo(CGSize(width: WSScale.scaleWidth(width: view.frame.width), height: 260.0))
//        }
        
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            pickerContainerView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        }
        
        pickerContainerView.addSubview(toolbar)
        pickerContainerView.addSubview(pickerView)
        
        
        //ios7 picker draws a darkened alpha-only region on the first and last 8 pixels horizontally, but blurs the rest of its background.  To make the whole popup appear to be edge-to-edge, we have to add blurring to the remaining left and right edges.
        if ( NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 )
        {
            var f : CGRect = CGRect(x: 0, y: toolbar.frame.origin.y, width: 8, height: pickerContainerView.frame.size.height - toolbar.frame.origin.y);
            let leftEdge : UIToolbar = UIToolbar(frame: f)
            f.origin.x = view.frame.size.width - 8;
            
            let rightEdge : UIToolbar = UIToolbar(frame: f)
            pickerContainerView.insertSubview(leftEdge, at: 0)
            pickerContainerView.insertSubview(rightEdge, at: 0)
        }
        
        backgroundView.addSubview(pickerContainerView)
        
        view.addSubview(backgroundView)
        view.bringSubviewToFront(backgroundView)
    }
    
    @objc public func didDismissWithDoneButton(_ button:UIBarButtonItem!){
        
        doneCallback(pickerView.selectedRow(inComponent: 0))
        
        for view in view.subviews {
            if view is CustomContainer{
                view.removeFromSuperview()
                self.backgroundView = CustomContainer()
            }
        }
    }
    
    
    @objc public func didDismissWithCanelButton(_ button:UIBarButtonItem!){
        for view in view.subviews {
            if view is CustomContainer{
                view.removeFromSuperview()
                self.backgroundView = CustomContainer()
            }
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        changeCallback(pickerView.selectedRow(inComponent: 0))
    }

    open class CustomContainer : UIView{}
}
