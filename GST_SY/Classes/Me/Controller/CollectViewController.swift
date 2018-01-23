//
//  CollectViewController.swift
//  GST_SY
//
//  Created by Don on 16/9/21.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import BMPlayer
import ESPullToRefresh
//import JLToast
import Toaster

class CollectViewController: YMBaseViewController {
    var mmessageCellID = "videocell"
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    
    var videos = [VideoModel]()
    var data:Array <VideoModel> = []
    var model :String?
    var accessToken :String?
    var page : Int?
    
    var ck_cate = [CK_Cate]()
    var attentionArr = Array<Int>()
    var collectTAG = 0  
    
    var error_codeMsg : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        
        model = "play"
        page = 1
        
        
        configMenuView()
        
        
        setupTableView()
        
        
       
        let userDefault = UserDefaults.standard
        accessToken = userDefault.object(forKey: "accessToken") as? String
        debugPrint("accessToken:",accessToken)
        if accessToken != nil{
      
            YMNetworkTool.shareNetworkTool.collectList(accessToken!, model: model!, page: page!){ [weak self](results) in
                
                self?.videos=results
                self!.data = self!.videos
                self!.tableView!.reloadData()
            }
        }else{
            debugPrint("请先进行登录")
            Toast(text: "请先进行登录").show()
        }
        
    
        tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self!.page = 1
            self!.loadVideoData()
            self!.data = self!.videos
            //            debugPrint("data:",self!.data)
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            self!.tableView!.reloadData()
        }
        

        if self.data.count>20 {
            tableView.es_addInfiniteScrolling {
                [weak self] in
                if self!.videos.count < 20{
                    self?.tableView!.es_stopLoadingMore()
                    /// If no more data
                    self?.tableView!.es_noticeNoMoreData()
                    
                }else{
                    self?.page = self!.page!+1
                    debugPrint("page",self!.page)
                    self!.loadmoreVideoData()
                    self?.tableView!.es_stopLoadingMore()
                    debugPrint("self?.videos.count:",self?.videos.count)
                }
                self!.tableView!.reloadData()
            }
        }
        
    }
    func loadVideoData() {
        
        if accessToken != nil{
    
            YMNetworkTool.shareNetworkTool.collectList(accessToken!, model: model!, page: page!){ [weak self](results) in
                self!.videos.removeAll()
                self?.videos=results
                
                self!.data = self!.videos
                self!.tableView.reloadData()
            }
        }else{
            debugPrint("请先进行登录")
            Toast(text: "请先进行登录").show()
        }
        
        
    }
    func loadmoreVideoData() {
      
        if accessToken != nil{
         
            YMNetworkTool.shareNetworkTool.collectList(accessToken!, model: model!, page: page!){ [weak self](items) in
                //刷新时数据重复显示
                self?.videos.removeAll()
                self?.data.removeAll()
                self?.videos=items
                self!.data.append(contentsOf: self!.videos)
                debugPrint("data.count:",self!.data.count)
            }
        }else{
            debugPrint("请先进行登录")
            Toast(text: "请先进行登录").show()
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
        
        let nib = UINib(nibName: String(describing: VideoTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: mmessageCellID)
        
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
        WOWDropMenuSetting.columnTitles = ["收藏分类"]
        WOWDropMenuSetting.rowTitles =  [
            ["同步视频","名师视频","考试视频","仿真实验","创客活动"]
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
extension CollectViewController: VideoTableViewCellDelegate,UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mmessageCellID) as! VideoTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
        debugPrint("videoItem:",cell.videoItem)
 
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
        let model = "chuangke"
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
extension CollectViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                model  = "play"
                loadVideoData()
                break
            case 1:
                model  = "mingshi"
                loadVideoData()
                break
            case 2:
                model  = "kaoshi"
                loadVideoData()
                break
            case 3:
                model  = "shiyan"
                loadVideoData()
                break
            case 4:
                model  = "chuangke"
                loadVideoData()
                break
            default:
                break
            }
                default:
            break
        }
    }
}
