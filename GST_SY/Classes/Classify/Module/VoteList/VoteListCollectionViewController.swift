//
//  VoteListCollectionViewController.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import MJRefresh

private let reuseIdentifier = "Cell"
//FooterView
private let headerViewIdentifier = "HeaderView"
private let footerViewIdentifier = "FooterView"

private struct Config {
    static let count = 2
    static let itemWidth = (UIScreen.main.bounds.width-CGFloat((count-1)*10)) / CGFloat(count)
    static let itemHeight = (UIScreen.main.bounds.height) / CGFloat((count + 1))
}

class VoteListCollectionViewController: UICollectionViewController {
    
    @objc private func headerBtnDidClick() {
        debugPrint(#function)
        
        let detail = VoteRankTableViewController()
        detail.title = "排名"
//        detail.voteList = voteList
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    var voteList: [VoteListModel]?
    
    var currentPage = 1
    
    var layout: UICollectionViewFlowLayout?
    
    var footer: MJRefreshAutoNormalFooter?
    
    init() {
        layout = UICollectionViewFlowLayout()
        layout?.minimumLineSpacing = 10
        layout?.minimumInteritemSpacing = 10
        layout?.itemSize = CGSize(width: Config.itemWidth, height: Config.itemHeight)
        layout?.scrollDirection = .vertical
        super.init(collectionViewLayout: layout!)
        
        //添加头部布局
        layout?.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
        //添加尾部布局
//        layout?.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        
        setupUI()
        
        //加载测试数据
        loadData()
        footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        //自动显示和隐藏footer
        footer?.isHidden = true
        collectionView?.mj_footer = footer
        
    }
    
    private func setupUI() {
        collectionView?.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        //加入上拉加载视图：删除不行？
        collectionView?.addSubview(indicatorView)
        
        //加入下拉刷新
        collectionView?.addSubview(refresh)
        
        collectionView?.addSubview(headerBtn)
        collectionView?.addSubview(searchBar)
        //
        searchBar.delegate = self
        //
        headerBtn.addTarget(self, action: "headerBtnDidClick", for: .touchUpInside)
        //下拉刷新监听
        refresh.addTarget(self, action: "loadData", for: .valueChanged)
    }
    
    //懒加载
    
    //上拉加载
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = UIColor.randomColor
        //        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = .gray
        return aiv
    }()
    
    //下拉刷新
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.randomColor
//        refresh.backgroundColor = UIColor.randomColor
        return refresh
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.contentMode = .redraw
        search.translatesAutoresizingMaskIntoConstraints = false
        search.keyboardAppearance = UIKeyboardAppearance.light
        search.searchBarStyle = .minimal
        search.placeholder = "输入关键字搜索"
//        search.backgroundColor = UIColor.green
//        search.text = "测试"
        search.showsCancelButton = true
        search.sizeToFit()
        return search
    }()
    
    lazy var headerBtn: UIButton = {
        let header = UIButton()
        header.setTitleColor(UIColor.white, for: .normal)
        header.backgroundColor = UIColor.orange
        header.sizeToFit()
        header.titleLabel?.textAlignment = .center
        header.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        header.setTitle("查看排名", for: .normal)
        return header
    }()
    
    @objc private func loadData() {
        debugPrint(#function)
        
        //联网获取数据源
        let url = "http://shiyan360.cn/api/vote_video"
        //内部引用self：会造成循环引用 加上weak
        NetworkTools.sharedSingleton.requestVoteList(urlStr: url) { [weak self] (votes) in
            self?.voteList?.removeAll()
            
            if votes?.count == 0 {
                
                //菊花停止转动
                if (self?.refresh.isRefreshing)! {
                    self?.refresh.endRefreshing()
                }
                
                debugPrint("活动正在筹备中 ~ ")
                let alert = UIAlertController(title: "温馨提示", message: "活动正在筹备中 ~  ，返回活动页 ", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (ok) in
                    self?.dismiss(animated: true, completion: nil)
                })
                alert.addAction(cancel)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            self?.voteList = votes
            //模拟多条数据
//            for i in (0..<10) {
//                self?.voteList = (self?.voteList)! + votes!
//            }
            
            debugPrint("currentThread 1 ----> \(Thread.current)")
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                //更新页码
                self?.currentPage = 1
                //菊花停止转动
                if (self?.refresh.isRefreshing)! {
                    self?.refresh.endRefreshing()
                }
            }
            
        }
        
    }
    
    @objc func loadMoreData() {
        debugPrint(#function)
        
        //联网获取数据源
        let url = "http://shiyan360.cn/api/vote_video"
        currentPage = currentPage + 1
        debugPrint("currentPage ----> \(currentPage)")
        //内部引用self：会造成循环引用 加上weak
        NetworkTools.sharedSingleton.requestVoteList(urlStr: url, page: currentPage) { [weak self] (votes) in
            //菊花停止转动
            DispatchQueue.main.async {
                if (self?.footer?.isRefreshing)! {
                    self?.collectionView?.mj_footer.endRefreshing()
                }
            }
            
            if self?.voteList != nil && votes?.count != 0 {
                self?.voteList = (self?.voteList)! + votes!
                debugPrint("currentThread 1 ----> \(Thread.current)")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                    self?.collectionView?.mj_footer.endRefreshing()
                }
            }else {
                debugPrint("没有更多数据啦 ~ ")
                self?.currentPage = (self?.currentPage)! - 2
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //刷新数据
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        debugPrint("状态栏8：----> \(UIApplication.shared.isStatusBarHidden)")
        //判断当前状态栏状态
        if UIApplication.shared.isStatusBarHidden {
            UIApplication.shared.isStatusBarHidden = false
        }
        super.viewWillLayoutSubviews()
        debugPrint("状态栏9：----> \(UIApplication.shared.isStatusBarHidden)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(VoteListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //注册头部视图
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
        
        //注册尾部视图
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        
        //子线程获取活动是否过期
        NetworkTools.sharedSingleton.isOverdue { (isOver) in
            let standard = UserDefaults.standard
            standard.set(isOver, forKey: "isOverdue")
            standard.synchronize()
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return voteList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VoteListCollectionViewCell
    
        // Configure the cell
        cell.vote = voteList?[indexPath.item]
        cell.voteBtnDelegate = self

        debugPrint("indexPath 1 ------> \(indexPath)")
        
//        if indexPath.item == (voteList?.count)! - 1 && !indicatorView.isAnimating{
//            //显示尾部视图
//            layout?.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
//        }else {
//            layout?.footerReferenceSize = CGSize.zero
//        }
        
        if collectionView.contentSize.height > UIScreen.main.bounds.height {
            footer?.isHidden = false
        }
        
        return cell
    }
}

extension VoteListCollectionViewController: VoteBtnDelegate {
    func vote(cell: VoteListCollectionViewCell) {
        debugPrint(#function)
        //弹出一个提示框
        let alert = UIAlertController(title: "温馨提示", message: "为她投票前需要观看完该视频 ~ 是否继续？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            debugPrint(#function)
        }
        let ok = UIAlertAction(title: "确定", style: .destructive) { (action) in
            debugPrint(#function)
            let detail = VoteDetailViewController()
            detail.vote = cell.vote
            detail.title = "投票详情页"
            //将活动过期情况传递过去
            let standard = UserDefaults.standard
            if let isOver = standard.value(forKey: "isOverdue") as? Bool {
                detail.isOverdue = isOver
            }
            //显示投票详情页
            let vc = self.navigationController?.childViewControllers.first
            vc?.present(detail, animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension VoteListCollectionViewController: UISearchBarDelegate {
    
    /**
     *  Desc: 按下键盘上搜索Search
     *  Param:
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //获取到关键字
        if let keyword = searchBar.text {
            //发送搜索请求数据
            //联网获取数据源
            let url = "http://shiyan360.cn/api/vote_search"
            //内部引用self：会造成循环引用 加上weak
            NetworkTools.sharedSingleton.requestSearchData(urlStr: url, keyword: keyword, completionHandler: { [weak self] (votes) in
                self?.voteList?.removeAll()
                self?.voteList = votes
                
                debugPrint("currentThread 2 ----> \(Thread.current)")
                //需要在主线程更新UI
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            })
        }
        
    }
    
    /**
     *  Desc: 用户点击取消Cancel
     *  Param:
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //隐藏键盘
        searchBar.resignFirstResponder()
        //将数据源替换成正常状态
        //联网获取数据源
        let url = "http://shiyan360.cn/api/vote_video"
        //内部引用self：会造成循环引用 加上weak
        NetworkTools.sharedSingleton.requestVoteList(urlStr: url) { [weak self] (votes) in
            self?.voteList?.removeAll()
            self?.voteList = votes
            
            debugPrint("currentThread 3 ----> \(Thread.current)")
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
}

extension VoteListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        debugPrint("indexPath 2 ------> \(indexPath)")
        
        var reusableView: UICollectionReusableView?
        if kind == UICollectionElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath)
            reusableView?.backgroundColor = UIColor.clear
            //添加头部视图约束
            headerBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo((reusableView!.snp.centerX))
                make.top.equalTo(reusableView!).offset(80)
                make.height.equalTo(30)
                make.width.equalTo(200)
            }
            searchBar.snp.makeConstraints { (make) in
                make.centerX.equalTo(reusableView!)
                make.bottom.equalTo(headerBtn).offset(-46)
                make.height.equalTo(56)
                //设置宽度：否则无法显示
                make.width.equalTo(UIScreen.main.bounds.width)
            }
        }else {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier, for: indexPath)
            reusableView?.backgroundColor = UIColor.randomColor
            //添加上拉加载视图约束
            if layout?.footerReferenceSize != CGSize.zero {
                indicatorView.snp.makeConstraints { (make) in
                    make.edges.equalTo(reusableView!)
                }
            }
        }
        
        return reusableView!
    }
    
}
