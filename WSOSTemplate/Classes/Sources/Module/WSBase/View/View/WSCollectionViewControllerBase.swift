//
//  WSCollectionViewControllerBase.swift
//  used-car
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MJRefresh

private let reuseIdentifier = "Cell"

class WSCollectionViewControllerBase: WSViewControllerBase, UICollectionViewDataSource, UICollectionViewDelegate /*UICollectionViewController*/ {
    
    public var collectionView: UICollectionView!
    public var collectionViewLayout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        setupBaseUI();
        setBaseNavigationItem();
        registerBaseCellClass();
        self.buildCacheData() { [weak self] in
            if (self?.entitySectionsArray.count)! > 0 {
                DispatchQueue.main.async {
                    self?.collectionView.reloadData() {
                    }
                }
            }
        }
        
        self.reloadEntityData(finished:{ [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData() {
                }
            }
        })
        
    }

    // MARK: Private method
    override func setupBaseUI() {
        self.setupTableView()
        self.setupRefreshHeader()
        self.setupRefreshFooter()
        baseViewControllerDelegate?.registerCellClass()
    }
    
    func setupTableView() {
        /////////////////////////////////////////////////////////////////////
        self.collectionViewLayout = UICollectionViewFlowLayout()// = self.collectionViewLayout as! UICollectionViewFlowLayout
        // Cell的大小
        // 建立 UICollectionViewFlowLayout
//        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
//        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//
//        // 設置每一行的間距
//        layout.minimumLineSpacing = 5
//
//        // 設置每個 cell 的尺寸
//        layout.itemSize = CGSizeMake(
//            CGFloat(fullScreenSize.width)/3 - 10.0,
//            CGFloat(fullScreenSize.width)/3 - 10.0)
//
//        // 設置 header 及 footer 的尺寸
//        layout.headerReferenceSize = CGSize(
//            width: fullScreenSize.width, height: 40)
//        layout.footerReferenceSize = CGSize(
//            width: fullScreenSize.width, height: 40)
        
        ////////////////////////////////////////////////////////////////////////////
        //layout.scrollDirection = .horizontal
        
        let height : CGFloat = self.tabBarHeight(tabController:self.navigationController?.tabBarController)
        self.collectionView = UICollectionView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: (self.view.frame.height - height)),
            collectionViewLayout: collectionViewLayout)
        self.collectionView.backgroundColor = WSColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //collectionView.separatorStyle = .singleLine
        //collectionView.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
        //self.collectionView.allowsSelection = true
        //self.collectionView.allowsMultipleSelection = false
        self.view.addSubview(self.collectionView)
        self.collectionView.addSubview(nodataInfoLabel)
        nodataInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView).offset(16)
            make.width.equalTo(self.collectionView)
            make.height.equalTo(21)
        }
    }
    
    //下拉刷新相关设置
    func setupRefreshHeader() {
        let header = MJRefreshNormalHeader()
        //隐藏时间
        header.lastUpdatedTimeLabel.isHidden = true
        //隐藏状态
        header.stateLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(WSTabelViewControllerBase.headerRefresh))
        collectionView.mj_header = header
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
        collectionView.mj_footer = footer
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
    func registerBaseCellClass() {
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // 註冊 section 的 header 跟 footer 以供後續重複使用
//        myCollectionView.registerClass(
//            UICollectionReusableView.self,
//            forSupplementaryViewOfKind:
//            UICollectionElementKindSectionHeader,
//            withReuseIdentifier: "Header")
//        myCollectionView.registerClass(
//            UICollectionReusableView.self,
//            forSupplementaryViewOfKind:
//            UICollectionElementKindSectionFooter,
//            withReuseIdentifier: "Footer")
        
    }
    
    // MARK: MJRefresh action
    //顶部下拉刷新
    @objc func headerRefresh(){
        let task = WSDispatchDelay().delay(5) {
            self.collectionView.mj_header.endRefreshing()
        }
        self.reloadEntityData { [weak self] in
            self?.collectionView.reloadData()
            DispatchQueue.main.async(execute: {
                self?.collectionView.mj_header.endRefreshing()
                WSDispatchDelay().cancel(task)
            })
        }
    }
    
    //底部上拉加载
    @objc func footerLoad(){
        let task = WSDispatchDelay().delay(5) {
            self.collectionView.mj_footer.endRefreshing()
        }
        self.fetchMoreData({ [weak self] entitiesApiData, entitiesData, error in
            if entitiesApiData.count > 0 {
                //先不要移除，這是舊的寫法，比較沒有效率
                self?.entitySectionsArray.removeAll()
                self?.entitySectionsArray = entitiesApiData
                self?.collectionView.reloadData()
                //                let apiDataModel:WSApiDataModel = WSApiDataModel()
                //                apiDataModel.section = ""
                //                apiDataModel.body = entitiesData
                //                self?.entitySectionsArray.append(apiDataModel)
                //                let set = IndexSet(integer: ((self?.entitySectionsArray.count ?? 1) - 1))
                //                self?.tableView.insertSections(set, with: .none)
            }
            DispatchQueue.main.async(execute: {
                self?.collectionView.mj_footer.endRefreshing()
                WSDispatchDelay().cancel(task)
            })
        })
    }
    
    // MARK: NotificationName action
    @objc override func refreshData(notification: Notification) {
        self.reloadEntityData { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc override func loginNotification(notification: Notification) {
        self.reloadEntityData { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if entitySectionsArray.count <= 0 {
            return 0
        }
        self.nodataInfoLabel.isHidden = true
        return entitySectionsArray.count
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellReuseIdentifier = WSBaseShareFunction.cellReuseIdentifier(entitySections: entitySectionsArray,indexPath: indexPath)
        //這里的寫法有問題，之後要修正的self.collectionView？
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }

    open func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        let cell = cell as? WSCollectionBaseCell
        let apiDataModel = entitySectionsArray[indexPath.section]
        print(apiDataModel)
        cell?.entity = (apiDataModel as! WSApiDataModel).body![indexPath.row] as? WSModelBase
    }
    
    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    // Uncomment this method to specify if the specified item should be selected
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
 
}

extension UICollectionView {
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
}
