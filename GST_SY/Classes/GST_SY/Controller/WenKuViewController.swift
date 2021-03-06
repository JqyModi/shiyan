//
//  WenKuViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
let wenkumessageCellID = "videocell"
class WenKuViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [WenKu]()
    var data:Array <WenKu> = []
    
    var desctype :String?
    var categoryid :String?
    var page : Int?
    var wk_cate = [CK_Cate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        categoryid = "0"
        desctype = "0"
        page = 1

        configMenuView()
        setupTableView()
        
       
        
        YMNetworkTool.shareNetworkTool.getWenKu(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
      
        YMNetworkTool.shareNetworkTool.wk_Cate_Result{ [weak self] (ck_cate) in
            self?.wk_cate = ck_cate
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
       
        YMNetworkTool.shareNetworkTool.getWenKu(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self!.videos.removeAll()
            self?.videos=videos
            self!.data = self!.videos
            print("data:",self!.data)
            self!.tableView.reloadData()
            
        }
        
        
        
    }
    func loadmoreVideoData() {
   
        YMNetworkTool.shareNetworkTool.getWenKu(desctype!, categoryid: categoryid!, page: page!){ [weak self](items) in
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
        tableView.rowHeight = 60
        
        let nib = UINib(nibName: String(describing: WenkuTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: wenkumessageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["文库分类"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","高中物理实验文库","高中化学实验文库","高中生物实验文库","高中通用技术实验文库","初中物理实验文库","初中化学实验文库","初中生物实验文库","初中通用技术实验文库","小学数学实验文库","小学科学实验文库","小学信息技术实验文库","名师讲堂实验报告"]
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
extension WenKuViewController: WenkuTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wenkumessageCellID) as! WenkuTableViewCell
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
        
        
        let fileurl = data[indexPath.row].fileUrl
        let name = data[indexPath.row].title
        print("url:",fileurl)
        print("name:",name)
      
        let video = WenKuDetailViewController()
        video.filename=name as NSString!
        video.fileurl=fileurl as NSString!
        video.title="文库详情"
        self.navigationController?.pushViewController(video, animated: true)
        //        self.presentViewController(video, animated: true, completion: nil)
    }
    
}
extension WenKuViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                categoryid = "0"
                loadVideoData()
                break
            case 1:
                categoryid = "154"
                loadVideoData()
                break
            case 2:
                categoryid = "155"
                loadVideoData()
                break
            case 3:
                categoryid = "156"
                loadVideoData()
                break
            case 4:
                categoryid = "186"
                loadVideoData()
                break
            case 5:
                categoryid = "158"
                loadVideoData()
                break
            case 6:
                categoryid = "159"
                loadVideoData()
                break
            case 7:
                categoryid = "160"
                loadVideoData()
                break
            case 8:
                categoryid = "152"
                loadVideoData()
                break
            case 9:
                categoryid = "167"
                loadVideoData()
                break
            case 10:
                categoryid = "187"
                loadVideoData()
                break
            default:
                categoryid = wk_cate[row - 1].id
                print("categoryid:",categoryid)
                loadVideoData()
                break
            }
        default:
            break
        }
    }
}
