//
//  KaoPingViewController.swift
//  GST_SY
//
//  Created by mac on 17/7/17.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
let kaopingmessageCellID = "kaopingcell"
class KaoPingViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var papers = [KaoPing]()
    var data:Array <KaoPing> = []
    
    var desctype :String?
    
    //接口参数
    var school: String?
    var banji: String?
    var nj: String?
    var xueke: String?
    var page : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        desctype = "0"
        page = 1
        
        //初始化接口参数
        school = ""
        banji = ""
        nj = ""
        xueke = ""
        
        configMenuView()
        setupTableView()
        
        
//        获取试卷列表：http://shiyan360.cn/index.php/api/examinPaperList
//        参数：page
//        school 学校名称，登录返回来的
//        banji  班级名称，登录返回来的
//        nj  年级名称，登录返回的
//        id 试卷ID
        
        YMNetworkTool.shareNetworkTool.getKaoPing(school!, banji: banji!,nj: nj!,xueke: xueke!, page: page!){ [weak self](items) in
            self?.papers=items
            self!.data = self!.papers
            self!.tableView!.reloadData()
        }
        
//        YMNetworkTool.shareNetworkTool.wk_Cate_Result{ [weak self] (ck_cate) in
//            self?.wk_cate = ck_cate
//        }
        
        
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self!.page = 1
            self!.loadVideoData()
//            self!.data = self!.papers
            print("data:",self!.data)
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            self!.tableView!.reloadData()
        }
        
        if self.data.count > 20 {
            self.tableView.es_addInfiniteScrolling {
                [weak self] in
                if self!.papers.count < 20{
                    self?.tableView.es_stopLoadingMore()
                    /// If no more data
                    self?.tableView.es_noticeNoMoreData()
                    
                }else{
                    self?.page = self!.page!+1
                    print("page",self!.page)
                    self!.loadmoreVideoData()
                    self?.tableView.es_stopLoadingMore()
                    print("self?.papers.count:",self?.papers.count)
                }
                
                self!.tableView!.reloadData()
                
            }
        }
        
    }
    
    func loadVideoData() {
        
        YMNetworkTool.shareNetworkTool.getKaoPing(school!, banji: banji!,nj: nj!,xueke: xueke!, page: page!){ [weak self](items) in
            self!.papers.removeAll()
            self?.papers=items
            self!.data = self!.papers
            print("data:",self!.data)
            self!.tableView.reloadData()
        }
        
        
        
    }
    func loadmoreVideoData() {
        
        YMNetworkTool.shareNetworkTool.getKaoPing(school!, banji: banji!,nj: nj!,xueke: xueke!, page: page!){ [weak self](items) in
            self?.papers=items
            self!.data.append(contentsOf: self!.papers)
            print("data.count:",self!.data.count)
        }
        
    }
    
    
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame:  CGRect(x: 0, y: kTitlesViewY+44, width: SCREENW, height: SCREENH-(kTitlesViewY+44)))
        //        tableView.frame = view.bounds
        self.automaticallyAdjustsScrollViewInsets =  false
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        let nib = UINib(nibName: String(describing: KaoPingTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kaopingmessageCellID)
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        tableView.separatorColor = UIColor.red
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        configTableStyle()
        
    }
    
    func configTableStyle(){
        tableView.backgroundColor = GSTGlobalBgColor()
        tableView.separatorStyle = .none
        
        tableView.contentMode = .center
        
    }
    
    fileprivate func configMenuView(){
        WOWDropMenuSetting.columnTitles = ["试卷分类"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","初中物理","初中化学","初中生物","高中物理","高中化学","高中生物"]
        ]
        
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.columnEqualWidth = true
        WOWDropMenuSetting.cellTextLabelSelectColoror = UIColor.red
        WOWDropMenuSetting.showDuration = 0.2
        self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: 44))
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //        refreshControl!.removeObserver(self, forKeyPath: "frame")
        
    }
}
extension KaoPingViewController: KaoPingTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kaopingmessageCellID) as! KaoPingTableViewCell
        cell.selectionStyle = .none
        //下标越界异常 已解决
        cell.kp = data[indexPath.row] 
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        //将考卷ID传递过去
        let paperId = data[row].id
        let paperName = data[row].paper
        //跳转到详情页
//        let kpVC = KaoPingDetailViewController()
//        kpVC.paperId = paperId
//        kpVC.paperName = paperName
//        kpVC.title="开始答题"
        
        let kpVC = KPViewController()
        kpVC.paperId = paperId
        kpVC.title="开始答题"
        //清空答案缓存
        PaperAnswers.removeAllObjects()
        //将试题ID及Name封装到答案(PaperAnswers)中：方便提交
        PaperAnswers["paperId"] = paperId
        PaperAnswers["paperName"] = paperName
        self.navigationController?.pushViewController(kpVC, animated: true)
    }
    
}
extension KaoPingViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                nj = ""
                xueke = ""
                loadVideoData()
                break
            case 1:
                nj = "初中"
                xueke = "物理"
                loadVideoData()
                break
            case 2:
                nj = "初中"
                xueke = "化学"
                loadVideoData()
                break
            case 3:
                nj = "初中"
                xueke = "生物"
                loadVideoData()
                break
            case 4:
                nj = "高中"
                xueke = "物理"
                loadVideoData()
                break
            case 5:
                nj = "高中"
                xueke = "化学"
                loadVideoData()
                break
            case 6:
                nj = "高中"
                xueke = "生物"
                loadVideoData()
                break
            default:
                nj = ""
                xueke = ""
                loadVideoData()
                break            }
        default:
            break
        }
    }
}

