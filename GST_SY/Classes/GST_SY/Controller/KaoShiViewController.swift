//
//  KaoShiViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/19.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
//import JLToast
import Toaster
let kaoshimessageCellID = "videocell"
class KaoShiViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [VideoModel]()
    var data:Array <VideoModel> = []
    
    var desctype :String?
    var categoryid :String?
    var page : Int?
    
    var ks_cate = [CK_Cate]()
    var attentionArr = Array<Int>()
    var collectTAG = 0  
    
    var error_codeMsg : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        categoryid = "0"
        desctype = "0"
        page = 1
        
        configMenuView()
        setupTableView()
  
        YMNetworkTool.shareNetworkTool.getKaoShi(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }
        
        YMNetworkTool.shareNetworkTool.ks_Cate_Result{ [weak self] (ck_cate) in
            self?.ks_cate = ck_cate
        }
        
     
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self!.page = 1
            self!.loadVideoData()
            self!.data = self!.videos
            debugPrint("data:",self!.data)
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
                debugPrint("page",self!.page)
                self!.loadmoreVideoData()
                self?.tableView.es_stopLoadingMore()
                debugPrint("self?.videos.count:",self?.videos.count)
            }
            
            self!.tableView!.reloadData()
            
        }
        
        
    }
    func loadVideoData() {
        
        YMNetworkTool.shareNetworkTool.getKaoShi(desctype!, categoryid: categoryid!, page: page!){ [weak self](videos) in
            self!.data.removeAll()
            
            self?.videos=videos
            self!.data = self!.videos
            debugPrint("data:",self!.data)
            
            self!.tableView.reloadData()
        }
        
        
        
        
    }
    func loadmoreVideoData() {
  
        YMNetworkTool.shareNetworkTool.getKaoShi(desctype!, categoryid: categoryid!, page: page!){ [weak self](items) in
            self?.videos=items
            self!.data.append(contentsOf: self!.videos)
            debugPrint("data.count:",self!.data.count)
            
        }
        
        
        
    }
    
    fileprivate func setupTableView() {
        //适配iPhone X下头部分类视图被遮挡问题1
        //        @available(iOS 11.0, *)
        let currentVersion = Double(UIDevice.current.systemVersion)
        //        currentVersion! >= 11.0 ：不能判断是否是iPhone X：通过分辨率判断
        if UIDevice.current.isX() {
            tableView = UITableView(frame:  CGRect(x: 0, y: kTitlesViewY+44+30, width: SCREENW, height: SCREENH-(kTitlesViewY+44)))
        }else {
            tableView = UITableView(frame:  CGRect(x: 0, y: kTitlesViewY+44, width: SCREENW, height: SCREENH-(kTitlesViewY+44)))
        }
        self.automaticallyAdjustsScrollViewInsets =  false
        self.view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        let nib = UINib(nibName: String(describing: VideoTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kaoshimessageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["考试分类","按最新"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","高考－物理","高考－化学","高考－生物","中考－物理","中考－化学","中考－生物"],
            ["不限","按访问记录","按最多评论"]
        ]
        
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.columnEqualWidth = true
        WOWDropMenuSetting.cellTextLabelSelectColoror = UIColor.red
        WOWDropMenuSetting.showDuration = 0.2
        //适配iPhone X下头部分类视图被遮挡问题2
        //        @available(iOS 11.0, *)
        let currentVersion = Double(UIDevice.current.systemVersion)
        //        currentVersion! >= 11.0 ：不能判断是否是iPhone X：通过分辨率判断
        if UIDevice.current.isX() {
            self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY + 30, width: SCREENW, height: 44))
        }else {
            self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: 44))
        }
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
extension KaoShiViewController: VideoTableViewCellDelegate,UITableViewDataSource, UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kaoshimessageCellID) as! VideoTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
        debugPrint("videoItem:",cell.videoItem)
     
        cell.btn_collect.tag = indexPath.row  
        
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
        
      
        cell.btn_share.tag = indexPath.row  
        cell.btn_share.addTarget(self, action: #selector(shareButton), for: UIControlEvents.touchUpInside)
        cell.delegate = self
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint(indexPath.row)
        
      
        //        let model = data![indexPath.row] as! VideoModel
        //        let url = model.videoUrl
        //
        //        let name = model.name
        
        let url = data[indexPath.row].videoUrl
        let name = data[indexPath.row].name
        debugPrint("url:",url)
        debugPrint("name:",name)
     
        let video = VideoPlayViewController()
        video.videoname=name as NSString!
        video.videourl=url as NSString!
        self.navigationController?.pushViewController(video, animated: true)
    }
    func collectButton(_ sender: UIButton){
        let collectbtn : UIButton! = sender
        //
       
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "accessToken") as? String
        debugPrint("accessToken:",accessToken)
        let model = "kaoshi"
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
                        debugPrint("收藏成功")
                        Toast(text: "收藏成功").show()
                        debugPrint("name:",self!.data[collectbtn.tag].name)
                        
                    }else if self!.error_codeMsg == 2 {
                        debugPrint("已经收藏过了")
                        Toast(text: "已经收藏过了").show()
                        debugPrint("name:",self!.data[collectbtn.tag].name)
                    }else{
                        debugPrint("请重新登录")
                        Toast(text: "请重新登录").show()
                    }
                }
            }else{
                debugPrint("请先进行登录")
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
                        debugPrint("取消收藏")
                        Toast(text: "取消收藏").show()
                        debugPrint("name:",self!.data[collectbtn.tag].name)
                    }else{
                        debugPrint("请重新登录")
                        Toast(text: "请重新登录").show()
                    }
                }
            }else{
                debugPrint("请先进行登录")
                Toast(text: "请先进行登录").show()
            }
        }
        
        
    }
    func shareButton(_ sender: UIButton){
        debugPrint(sender.tag)
        debugPrint("name:",data[sender.tag].name)
        YMActionSheet.show()
    }

}
extension KaoShiViewController:DropMenuViewDelegate{
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
                categoryid = "409"
                loadVideoData()
                break
            case 2:
                categoryid = "410"
                loadVideoData()
                break
            case 3:
                categoryid = "411"
                loadVideoData()
                break
            case 4:
                categoryid = "413"
                loadVideoData()
                break
            case 5:
                categoryid = "414"
                loadVideoData()
                break
            case 6:
                categoryid = "415"
                loadVideoData()
                break
            default:
                categoryid = ks_cate[row - 1].id
                debugPrint("categoryid:",categoryid)
                debugPrint("categoryname:",ks_cate[row - 1].name)
                loadVideoData()
                break
            }
        case 1:
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
