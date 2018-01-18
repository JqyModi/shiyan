//
//  VoteListTableViewController.swift
//  Vote
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

private let reuseIdentifier = "Cell"
class VoteRankTableViewController: UITableViewController {

    var voteList: [VoteListModel]?
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        debugPrint("VoteListModel.description() -----> \(VoteListModel(dict: nil).description)")
        
        loadData()
        setupUI()
        
    }
    
    @objc private func loadData() {
        //获取数据
        let url = "http://shiyan360.cn/api/result_desc"
        
        NetworkTools.sharedSingleton.requestVoteRankList(urlStr: url, page: 1) { [weak self](votes) in
            self?.voteList?.removeAll()
            self?.voteList = votes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if (self?.refresh.isRefreshing)! {
                    self?.refresh.endRefreshing()
                }
            }
        }
    }
    
    @objc private func loadMoreData() {
        //获取数据
        let url = "http://shiyan360.cn/api/result_desc"
        currentPage = currentPage + 1
        NetworkTools.sharedSingleton.requestVoteRankList(urlStr: url, page: currentPage) { [weak self](votes) in
            
            if votes != nil && votes?.count != 0 {
                self?.voteList = (self?.voteList!)! + votes!
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }else{
                debugPrint("没有更多数据啦 ~ ")
            }
            DispatchQueue.main.async {
                if (self?.indicatorView.isAnimating)! {
                    self?.indicatorView.stopAnimating()
                }
            }
        }
    }
    
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        tableView.register(VoteRankTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //下拉刷新
        tableView.addSubview(refresh)
        //设置上拉加载
        tableView.tableFooterView = indicatorView
        
        //添加约束
        
        //下拉刷新监听
        refresh.addTarget(self, action: "loadData", for: .valueChanged)
        
        // Initialize tableView
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
//        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//            // Add your logic here
//            // Do not forget to call dg_stopLoading() at the end
//            self?.tableView.dg_stopLoading()
//            }, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return voteList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VoteRankTableViewCell

        // Configure the cell...
        cell.vote = voteList?[indexPath.row]
        cell.item = indexPath.row
        //设置上拉加载数据操作：当Cell是上拉加载布局Cell时且菊花没有滚动状态下开始上拉加载数据
        if indexPath.row == (voteList?.count)! - 1 && !indicatorView.isAnimating {
            //开始上拉加载
            indicatorView.startAnimating()
            loadMoreData()
            debugPrint("开始加载更多数据")
        }
        return cell
    }

    //下拉刷新
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.randomColor
        //        refresh.backgroundColor = UIColor.randomColor
        return refresh
    }()
    //上拉加载
    private lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = UIColor.randomColor
        //        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = .gray
        return aiv
    }()
    
    
}
