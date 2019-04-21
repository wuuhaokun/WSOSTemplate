//
//  WSTabelViewControllerBase.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/7/2.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import UIKit
//import FDTemplateLayoutCell
import AMScrollingNavbar
import MJRefresh

open class WSTabelViewControllerBase : WSViewControllerBase , UITableViewDelegate, UITableViewDataSource  {

    public var tableView: UITableView!
    
    override open func viewDidLoad() {
        setupBaseUI();
        setBaseNavigationItem();
        registerBaseCellClass();
        self.buildCacheData() { [weak self] in
            if (self?.entitySectionsArray.count)! > 0 {
                DispatchQueue.main.async {
                    self?.tableView.reloadData() {
                    }
                }
            }
        }
        
        self.reloadEntityData(finished:{ [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData() {
                }
            }
        })
        
    }
    
    // Enable the navbar scrolling
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        //有需要上移時隱藏狀態列要將以下註解打開，或由實作人實作也可以的
//        if let navigationController = self.navigationController as? ScrollingNavigationController {
//            if let navigationController = self.navigationController as? ScrollingNavigationController {
//                navigationController.followScrollView(tableView, delay: 1.0)
//            }
//            navigationController.scrollingNavbarDelegate = self as ScrollingNavigationControllerDelegate
//        }
    }

    // MARK: Private method
    override func setupBaseUI() {
        self.setupTableView()
        self.setupRefreshHeader()
        self.setupRefreshFooter()
        baseViewControllerDelegate?.registerCellClass()
    }

    func setupTableView() {
        let height : CGFloat = self.tabBarHeight(tabController:self.navigationController?.tabBarController)
        tableView = UITableView(frame: CGRect(
                                    x: 0,
                                    y: 0,
                                width: self.view.frame.width,
                               height: (self.view.frame.height - height)),
                                style: .plain)
        tableView.backgroundColor = WSColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        self.view.addSubview(tableView)
    }
    
    //下拉刷新相关设置
    func setupRefreshHeader() {
        let header = MJRefreshNormalHeader()
        //隐藏时间
        header.lastUpdatedTimeLabel.isHidden = true
        //隐藏状态
        header.stateLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(WSTabelViewControllerBase.headerRefresh))
        tableView.mj_header = header
    }
    
    // 底部加载
    func setupRefreshFooter() {

        let footer = MJRefreshAutoNormalFooter()
        //隐藏状态
        footer.stateLabel.isHidden = true
        //footer.setTitle("", for: MJRefreshState.idle)
        //footer.setTitle("Loading", for: MJRefreshState.refreshing)
        //footer.setTitle("", for: MJRefreshState.noMoreData)
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(WSTabelViewControllerBase.footerLoad))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        tableView.mj_footer = footer
        
    }
    
    override func setBaseNavigationItem() {
        // 導覽列標題
        navigationItem.title = ""
        // 導覽列底色
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
        //導覽列是否半透明
        //self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: WSViewControlBaseDelegate
    open func registerBaseCellClass() {
        tableView.register(WSEmptyCell.self, forCellReuseIdentifier: "WSEmptyCell")
        tableView.register(WSSectionCell.self, forCellReuseIdentifier: "WSSectionCell")
    }
    
    // MARK: MJRefresh action
    //顶部下拉刷新
    @objc func headerRefresh(){
        
        let task = WSDispatchDelay().delay(5) {
            self.tableView.mj_header.endRefreshing()
        }
        self.reloadEntityData { [weak self] in
            self?.tableView.reloadData()
            DispatchQueue.main.async(execute: {
                self?.tableView.mj_header.endRefreshing()
                WSDispatchDelay().cancel(task)
            })
        }
    }
    
    //底部上拉加载
    @objc func footerLoad(){
        let task = WSDispatchDelay().delay(5) {
            self.tableView.mj_footer.endRefreshing()
        }
        self.fetchMoreData({ [weak self] entitiesApiData, entitiesData, error in
            if entitiesApiData.count > 0 {
                //先不要移除，這是舊的寫法，比較沒有效率
                self?.entitySectionsArray.removeAll()
                self?.entitySectionsArray = entitiesApiData
                self?.tableView.reloadData()
//                let apiDataModel:WSApiDataModel = WSApiDataModel()
//                apiDataModel.section = ""
//                apiDataModel.body = entitiesData
//                self?.entitySectionsArray.append(apiDataModel)
//                let set = IndexSet(integer: ((self?.entitySectionsArray.count ?? 1) - 1))
//                self?.tableView.insertSections(set, with: .none)
            }
            DispatchQueue.main.async(execute: {
                self?.tableView.mj_footer.endRefreshing()
                WSDispatchDelay().cancel(task)
            })
        });
    }
    
    // MARK: NotificationName action
    @objc override func refreshData(notification: Notification) {
        self.reloadEntityData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc override func loginNotification(notification: Notification) {
        self.reloadEntityData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDelegate
    open func numberOfSections(in _: UITableView) -> Int {
        if entitySectionsArray.count <= 0 {
            return 0
        }
        return entitySectionsArray.count
    }
    
    open func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entitySectionsArray.count <= section {
            return 0
        }
        if let apiDataModel:WSApiDataModel = entitySectionsArray[section] as? WSApiDataModel {
            if apiDataModel.body?.count ?? 0 <= 0 {
                return 0
            }
            return (apiDataModel.body?.count)!
        }
        else {
            return 0
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = WSBaseShareFunction.cellReuseIdentifier(entitySections: entitySectionsArray,indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    open func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let cell = cell as? WSBaseCell
        //let guideHeight = (view.safeAreaLayoutGuide).layoutFrame.size.height
        if #available(iOS 11.0, *) {
            cell?.guideHeight = Int(self.tableView.frame.height)//Int((view.safeAreaLayoutGuide).layoutFrame.size.height)
        } else {
            // Fallback on earlier versions
        }
        cell?.fd_usingFrameLayout = true // Enable to use "-sizeThatFits:"
//        if indexPath.row % 2 == 0 {
//            cell?.accessoryType = .disclosureIndicator
//        } else {
//            cell?.accessoryType = .checkmark
//        }
        if indexPath.section >= entitySectionsArray.count {
            return
        }
        let apiDataModel = entitySectionsArray[indexPath.section]
        cell?.entity = (apiDataModel as! WSApiDataModel).body![indexPath.row] as? WSModelBase
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let cellReuseIdentifier = WSBaseShareFunction.cellReuseIdentifier(entitySections: entitySectionsArray,indexPath: indexPath)
        let selectedText:String = "No cache"
        switch selectedText {
        case "No cache":
            return tableView.fd_heightForCell(with: cellReuseIdentifier) { cell in
                self.configure(cell: cell, at: indexPath)
            }
        case "IndexPath cache":
            return tableView.fd_heightForCell(with: cellReuseIdentifier, cacheBy: indexPath) { cell in
                self.configure(cell: cell, at: indexPath)
            }
        case "Key cache":
            return tableView.fd_heightForCell(with: cellReuseIdentifier, cacheByKey: cellReuseIdentifier) { cell in
                self.configure(cell: cell, at: indexPath)
            }
        default:
            return tableView.rowHeight
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .zero
    }

    //section
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= entitySectionsArray.count {
            return 0
        }
        if let apiDataModel:WSApiDataModel = entitySectionsArray[section] as? WSApiDataModel {
            if apiDataModel.section == nil || apiDataModel.section == "" {
                return 0
            }
        }
        else {
            return 0
        }
        return 36
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= entitySectionsArray.count {
            return nil
        }

        if let apiDataModel:WSApiDataModel = entitySectionsArray[section] as? WSApiDataModel {
            if apiDataModel.section != nil && apiDataModel.section != "" {
                let view:WSTabelHeader = WSTabelHeader(frame: CGRect(x:-1000, y:0, width:tableView.frame.size.width, height:36))
                view.textLabel = UILabel(frame: CGRect(x:16, y:0, width:view.frame.width, height:view.frame.height))
                view.textLabel?.textColor = UIColor.black
                view.textLabel?.isHidden = false
                view.backgroundColor = UIColor.lightGray
                view.textLabel?.text = apiDataModel.section;//WSlocalizedString.localizedString(key: (apiDataModel.section)!)
                view.addSubview(view.textLabel!)
                return view
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    open func refreshEntityAndView() {
        self.reloadEntityData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

extension WSTabelViewControllerBase: ScrollingNavigationControllerDelegate {
    public func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
        view.needsUpdateConstraints()
    }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
