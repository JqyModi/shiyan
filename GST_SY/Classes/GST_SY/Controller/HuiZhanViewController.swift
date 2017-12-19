//
//  HuiZhanViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
let hzmessageCellID = "videocell"
class HuiZhanViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [ZiXun]()
    var data:Array <ZiXun> = []
    
    var desctype :String?
    var categoryid :String?
    var page : Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        categoryid = "134"
        desctype = "0"
        page = 1
//        configMenuView()

        setupTableView()
      
        
        YMNetworkTool.shareNetworkTool.getHuiZhan(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
        
     
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self!.page = 1
            self!.loadVideoData()
            self!.data = self!.videos
            print("data:",self!.data)
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            self!.tableView!.reloadData()
        }
        
      
        self.tableView.es_addInfiniteScrolling {
            [weak self] in
            if self!.videos.count <= 20{
              
                self?.tableView.es_stopLoadingMore()
                /// If no more data
                self?.tableView.es_noticeNoMoreData()
                
            }else{
                self?.page = self!.page!+1
                print("page",self!.page)
                self!.loadmoreVideoData()
                self?.tableView.es_stopLoadingMore()
                print("self?.videos.count:",self?.videos.count)
            }
            
            self!.tableView!.reloadData()
            
        }

    }
    
    func loadVideoData() {

        YMNetworkTool.shareNetworkTool.getHuiZhan(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self!.videos.removeAll()
            self?.videos=videos
            
        }
        self.tableView.reloadData()
        
        self.data = self.videos
        print("data:",self.data)
        
    }
    func loadmoreVideoData() {
   
        YMNetworkTool.shareNetworkTool.getHuiZhan(desctype!, categoryid: categoryid!, page: page!){ [weak self](items) in
            self?.videos=items
            self!.data.append(contentsOf: self!.videos)
            print("data.count:",self!.data.count)
            
        }
        
        
        
    }
    
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame:  CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: SCREENH-kTitlesViewY))
        //        tableView.frame = view.bounds
        self.automaticallyAdjustsScrollViewInsets =  false
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        let nib = UINib(nibName: String(describing: ZiXunTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: hzmessageCellID)
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
  
        tableView.separatorColor = UIColor.red
   
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        configTableStyle()
        
    }
    
    func configTableStyle(){
        tableView.backgroundColor = GSTGlobalBgColor()
        tableView.separatorStyle = .none
    }
    
    fileprivate func configMenuView(){
        WOWDropMenuSetting.columnTitles = ["创客分类","按最新"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","创新教具","创客活动","教师专区","学生专区"],
            ["不限","按访问记录","按最多评论"]
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
extension HuiZhanViewController: ZiXunTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: hzmessageCellID) as! ZiXunTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
        cell.delegate = self
        //        cell.textLabel?.text = "同步视频" + String(indexPath.row)
        //        cell.imageView?.image=resizeImageWithAspect(UIImage(named: babyImage[indexPath.row])!,scaledToMaxWidth: 140.0, maxHeight: 20.0)
        //        cell?.imageView?.image=UIImage(named: babyImage[indexPath.row])
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        
        let content = data[indexPath.row].content
        
        
       
        let video = ZiXunDetailVIewController()
        video.title="会展详情"
        video.content=content as NSString!
        self.navigationController?.pushViewController(video, animated: true)
        
    }
}
extension HuiZhanViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
    }
}
