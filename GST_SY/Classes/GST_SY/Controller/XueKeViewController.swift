//
//  XueKeViewController.swift
//  GST_SY
//
//  Created by Don on 16/9/21.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
import BMPlayer
//import JLToast
import Toaster


class XueKeViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [VideoModel]()
    var data:Array <VideoModel> = []
    
    var desctype :String?
    var categoryid :String?
    var gradeid :String?
    var page : Int?
    var vd_gdcate = [CK_Cate]()
    var vd_cate = [CK_Cate]()
    
    var attentionArr = Array<Int>()
    var collectTAG = 0 
    
    var error_codeMsg : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
//        categoryid = "0"
        desctype = "0"
        gradeid = "0"
        page = 1
//        configMenuView()
        setupTableView()
        
   
        YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in
            
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
    
        YMNetworkTool.shareNetworkTool.vd_GdCate_Result{ [weak self] (ck_cate) in
            self?.vd_gdcate = ck_cate
        }
       
        YMNetworkTool.shareNetworkTool.vd_Cate_Result{ [weak self] (ck_cate) in
            self?.vd_cate = ck_cate
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
       
        YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in
            self!.videos.removeAll()
            self?.videos=videos
            self!.data = self!.videos
            print("data:",self!.data)
            self!.tableView.reloadData()
        }
    }
    func loadmoreVideoData() {
    
        YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](items) in
            self?.videos=items
            self!.data.append(contentsOf: self!.videos)
            print("data.count:",self!.data.count)
        }
        
    }
    
  
    fileprivate func setupTableView() {
        tableView = UITableView(frame:  CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: SCREENH-(kTitlesViewY+44)))
        //        tableView.frame = view.bounds
        self.automaticallyAdjustsScrollViewInsets =  false
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        let nib = UINib(nibName: String(describing: VideoTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: messageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["全部年级","全部分类","按最新"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","选修6","选修5","选修4","选修3","选修2","选修1","必修三","必修二","必修一","初三","初二","初一","小六","小五","小四","小三"],
            ["不限","高中物理","高中化学","高中生物","通用技术","……","初中物理","初中化学","初中生物","……","小学科学","……"],
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
    }
}
extension XueKeViewController: VideoTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID) as! VideoTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
      
        cell.btn_collect.tag = indexPath.row   //设置button的tag 为tableview对应的行
        
        if attentionArr.contains(indexPath.row){
            if collectTAG == 1{
                cell.btn_collect.isSelected = true
                cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), for: .selected)
            }else{
                cell.btn_collect.isSelected = false
                cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite"), for: UIControlState())
            }
            
        }else{
            cell.btn_collect.isSelected = false
            cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite"), for: UIControlState())
        }
        cell.btn_collect.addTarget(self, action: #selector(collectButton), for: .touchUpInside)
        
        
   
        cell.btn_share.tag = indexPath.row   //设置button的tag 为tableview对应的行
        cell.btn_share.addTarget(self, action: #selector(shareButton), for: UIControlEvents.touchUpInside)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
      
        let url = data[indexPath.row].videoUrl
        let name = data[indexPath.row].name
        print("url:",url)
        print("name:",name)
       
        let video = VideoPlayViewController()
        video.videoname=name as NSString!
        video.videourl=url as NSString!
        self.navigationController?.pushViewController(video, animated: true)
        //        self.presentViewController(video, animated: true, completion: nil)
    }
    func collectButton(_ sender: UIButton){
        let collectbtn : UIButton! = sender
        //
        
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "accessToken") as? String
        print("accessToken:",accessToken)
        let model = "play"
        if collectTAG == 0{
            let id = data[collectbtn.tag].id
            if accessToken != nil {
                YMNetworkTool.shareNetworkTool.collectResult(accessToken!,model: model,id: id!){[weak self](error_codeMsg) in
                    self!.error_codeMsg=error_codeMsg
                    if self!.error_codeMsg == 0 {
                        self!.attentionArr.append(collectbtn.tag)
                        self!.collectTAG = 1
                        collectbtn.isSelected = true
                        collectbtn.setImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), for: .selected)
                        print("收藏成功")
                        Toast(text: "收藏成功").show()
                        print("name:",self!.data[collectbtn.tag].name)
                        
                    }else if self!.error_codeMsg == 2 {
                        print("已经收藏过了")
                        Toast(text: "已经收藏过了").show()
                        print("name:",self!.data[collectbtn.tag].name)
                    }else{
                        print("请重新登录")
                        Toast(text: "请重新登录").show()
                    }
                }
            }else{
                print("请先进行登录")
                Toast(text: "请先进行登录").show()
            }
            
            
        }else{
            
            let id = data[collectbtn.tag].id
            if accessToken != nil {
                YMNetworkTool.shareNetworkTool.decollectResult(accessToken!,model: model,id: id!){[weak self](error_codeMsg) in
                    self!.error_codeMsg=error_codeMsg
                    if self!.error_codeMsg == 0 {
                        self!.attentionArr.append(collectbtn.tag)
                        self!.collectTAG = 0
                        collectbtn.isSelected = false
                        collectbtn.setImage(UIImage(named: "detail_interaction_bar_favorite"), for: UIControlState())
                        print("取消收藏")
                        Toast(text: "取消收藏").show()
                        print("name:",self!.data[collectbtn.tag].name)
                    }else{
                        print("请重新登录")
                        Toast(text: "请重新登录").show()
                    }
                }
            }else{
                print("请先进行登录")
                Toast(text: "请先进行登录").show()
            }
        }
        
        
    }
    func shareButton(_ sender: UIButton){
        print(sender.tag)
        print("name:",data[sender.tag].name)
        YMActionSheet.show()
    }
}
extension XueKeViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:// 第0个栏目
            switch row {
            case 0:
                gradeid = "0"
                loadVideoData()
                break
            default:
                gradeid = vd_gdcate[row - 1].id
                print("gradeid:",gradeid)
                print("gradeidname:",vd_gdcate[row - 1].name)
                loadVideoData()
                break
            }
            break
        case 1:
            switch row {
            case 0:
                categoryid = "0"
                loadVideoData()
                break
            default:
                categoryid = vd_cate[row - 1].id
                print("categoryid:",categoryid)
                print("categoryidname:",vd_cate[row - 1].name)
                loadVideoData()
                break
            }
            
            break
        case 2:// 第1个栏目
            switch row {
            case 0:
                desctype = "0"
                loadVideoData()
                break
            case 1:
                desctype = "2"
                loadVideoData()
                break
            case 2:
                desctype = "3"
                loadVideoData()
                break
            default:
                
                break
            }
            break
        default:
            break
        }
        
    }
}



