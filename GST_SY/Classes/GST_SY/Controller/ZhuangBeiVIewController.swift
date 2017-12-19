//
//  ZhuangBeiVIewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
let zbmessageCellID = "videocell"
class ZhuangBeiVIewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [PeiXun]()
    var data:Array <PeiXun> = []
    
    var desctype :String?
    var categoryid :String?
    var page : Int?
    
    var zb_cate = [CK_Cate]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        categoryid = "135"
        desctype = "0"
        page = 1

          configMenuView()
        setupTableView()
        
        YMNetworkTool.shareNetworkTool.getZhuangBei(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in

            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
       
        YMNetworkTool.shareNetworkTool.zb_Cate_Result{ [weak self] (ck_cate) in
            self?.zb_cate = ck_cate
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
//        实验装备：http://www.shiyan360.cn/index.php/api/article_list?desc_type=0 2 3
//        &category_id= 135 所有分类
//        &page=
//        获得分类：http://www.shiyan360.cn/index.php/api/article_category_sub?id=135
        YMNetworkTool.shareNetworkTool.getZhuangBei(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self!.videos.removeAll()
            self?.videos=videos
            
            self!.data = self!.videos
            print("data:",self!.data)
            self!.tableView.reloadData()
        }
        
        
        
        
    }
    
    func loadmoreVideoData() {
 
        YMNetworkTool.shareNetworkTool.getZhuangBei(desctype!, categoryid: categoryid!, page: page!){ [weak self](items) in
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
        tableView.register(nib, forCellReuseIdentifier: zbmessageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["装备分类"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","物理实验设备","化学实验设备","生物实验设备","通用技术实验设备"]
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
extension ZhuangBeiVIewController: PeiXunTableViewCellDelegate,UITableViewDataSource, UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: zbmessageCellID) as! PeiXunTableViewCell
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
        
   
        let url = data[indexPath.row].videoUrl
        let name = data[indexPath.row].title
        print("url:",url)
        print("name:",name)
    
        let video = VideoPlayViewController()
        video.videoname=name as NSString!
        video.videourl=url as NSString!
        self.navigationController?.pushViewController(video, animated: true)
        //        self.presentViewController(video, animated: true, completion: nil)
    }
    
}
extension ZhuangBeiVIewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                categoryid = "135"
                loadVideoData()
                break
            case 1:
                categoryid = "137"
                loadVideoData()
                break
            case 2:
                categoryid = "136"
                loadVideoData()
                break
            case 3:
                categoryid = "140"
                loadVideoData()
                break
            case 4:
                categoryid = "141"
                loadVideoData()
                break
            case 5:
                categoryid = "157"
                loadVideoData()
                break
            case 6:
                categoryid = "159"
                loadVideoData()
                break
            case 7:
                categoryid = "142"
                loadVideoData()
                break
            case 8:
                categoryid = "169"
                loadVideoData()
                break
            default:
                categoryid = zb_cate[row - 1].id
                print("categoryid:",categoryid)
                loadVideoData()
                break
            }
        default:
            break
        }

    }
}
