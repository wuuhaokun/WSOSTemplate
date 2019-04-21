//
//  WSHomeViewController.swift
//  CPMVPTemplate
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Pods_WSOSTemplate_Example

class WSTableViewViewController: WSTabelViewControllerBase , WSTableViewViewInterfaceBase {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dd = (self.eventHandler as! WSTableViewPresenterInterface).test()
        print(dd)
    }
    
    override func registerBaseCellClass() {
        super.registerBaseCellClass()
        tableView.register(WSTableViewCell.self, forCellReuseIdentifier: "WSTableViewCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setBaseNavigationItem() {
        // 導覽列標題
        navigationItem.title = "收藏列"
        // 導覽列底色
        //self.navigationController?.navigationBar.barTintColor = UIColor.gray
        //導覽列是否半透明
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}
