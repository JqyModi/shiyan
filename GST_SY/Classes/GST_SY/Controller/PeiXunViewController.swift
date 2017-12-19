//
//  PeiXunViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
let pxmessageCellID = "videocell"
class PeiXunViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [PeiXun]()
    var data:Array <PeiXun> = []
    
    var desctype :String?
    var categoryid :String?
    var page : Int?
    var px_cate = [CK_Cate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        categoryid = "139"
        desctype = "0"
        page = 1
        
        configMenuView()
        setupTableView()
        
      
        YMNetworkTool.shareNetworkTool.getPeiXun(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
      
        YMNetworkTool.shareNetworkTool.px_Cate_Result{ [weak self] (ck_cate) in
            self?.px_cate = ck_cate
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
            if self!.videos.count < 20{
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
     
        YMNetworkTool.shareNetworkTool.getPeiXun(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self!.videos.removeAll()
            self?.videos=videos
            self!.data = self!.videos
            print("data:",self!.data)
            self!.tableView.reloadData()
            
        }
        
        
        
        
    }
    func loadmoreVideoData() {
       
        YMNetworkTool.shareNetworkTool.getPeiXun(desctype!, categoryid: categoryid!, page: page!){ [weak self](items) in
            self?.videos=items
            self!.data.append(contentsOf: self!.videos)
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
        tableView.rowHeight = 130
        
        let nib = UINib(nibName: String(describing: PeiXunTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: pxmessageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["培训分类"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","教师培训","师范生培训","装备培训"]
        
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
extension PeiXunViewController: PeiXunTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pxmessageCellID) as! PeiXunTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = videos[indexPath.row]
        cell.delegate = self
        //        cell.textLabel?.text = "同步视频" + String(indexPath.row)
        //        cell.imageView?.image=resizeImageWithAspect(UIImage(named: babyImage[indexPath.row])!,scaledToMaxWidth: 140.0, maxHeight: 20.0)
        //        cell?.imageView?.image=UIImage(named: babyImage[indexPath.row])
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        let url = videos[indexPath.row].videoUrl
        let name = videos[indexPath.row].title
        print("url:",url)
        print("name:",name)
      
        let video = VideoPlayViewController()
        video.videoname=name as NSString!
        video.videourl=url as NSString!
        self.navigationController?.pushViewController(video, animated: true)
        //        self.presentViewController(video, animated: true, completion: nil)
    }
    
}
extension PeiXunViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                categoryid = "0"
                loadVideoData()
                break
            default:
                categoryid = px_cate[row - 1].id
                print("categoryid:",categoryid)
                loadVideoData()
                break
            }
        default:
            break
        }
    }
}
