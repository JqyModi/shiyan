//
//  YMProductViewController.swift
//  GST_SY
//
//

import UIKit
import BMPlayer
//import JLToast
import Toaster
import SVProgressHUD

//单元格重用标识
let messageCellID = "videocell"
var player: BMPlayer!
var refreshControl: UIRefreshControl?
class YMProductViewController: YMBaseViewController {
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
    
    var collectList = [String]()
    
    var error_codeMsg : Int?

    var count = 0;
    var count1 = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()

        categoryid = "0"
        desctype = "0"
        gradeid = "0"
        page = 1
        configMenuView()
        setupTableView()
      
        YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in

            self?.videos=videos
            self!.data = self!.videos
            print("data--videos  ---->  \(self!.data.description)")
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
     
//        hignlightCollectButton(1)
        
        print("desctype = \(desctype)  :  categoryid = \(categoryid)  :  gradeid = \(gradeid)")
       YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in
        
            if videos.count > 0 {
                self!.videos.removeAll()
                self?.videos=videos
                self?.data.removeAll()
                self!.data = self!.videos
                print("data:",self!.data[0].name)
                //刷新数据
                self!.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: "数据加载失败请检测网络是否正常")
            }
        }
    }
    func loadmoreVideoData() {
     
        YMNetworkTool.shareNetworkTool.testPost2(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](items) in
            self?.videos=items
            self!.data.append(contentsOf: self!.videos)
            print("data.count:",self!.data.count)
        }
        //当收藏条目大于20条时需要计算page：data.count / 20 : 默认每页放20条
        var page1 = data.count / 20
        hignlightCollectButton(page1)
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
//        print("该方法调用了\(count++)次")
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
        
        //更改字体颜色
        WOWDropMenuSetting.cellTextLabelColor = GSTGlobalFontColor()
        WOWDropMenuSetting.cellSelectionColor = UIColor.red
        WOWDropMenuSetting.columnTitleFont = UIFont.systemFont(ofSize: GSTGlobalFontMiddleSize())
        
//        if prefersStatusBarHidden {
//            self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY - statusH, width: SCREENW, height: 44))
//        }else{
//            self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: 44))
//        }
        self.menuView = WOWDropMenuView(frame:CGRect(x: 0, y: kTitlesViewY, width: SCREENW, height: 44))
        
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension YMProductViewController: VideoTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取重用的cell
        print("row ======== \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID) as! VideoTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
        print("cell ======== \(cell)")
        
        //检查并显示是否收藏
        //通过视频在数据库中的id来查询校验改item是否被收藏过：有返回2:无返回0:收藏成功
        if self.collectList.count > 0 {
//            print("开始高亮显示收藏item")
            if self.collectList.contains(data[indexPath.row].id) {
                print("高亮显示按钮图片 id == \(data[indexPath.row].id)")
                print("count1 ======= \(count1)")
                //由于cell重用导致没有收藏的item也高亮显示了 : 加个else解决
                cell.btn_collect.setBackgroundImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), for: UIControlState())
            }else{
                cell.btn_collect.setBackgroundImage(UIImage(named: "detail_interaction_bar_favorite"), for: UIControlState())
            }
        }else{
            print("还没有收藏任何数据")
//            JLToast.makeText("还没有收藏任何数据", delay: 0.5, duration: JLToastDelay.ShortDelay).show()
        }
        
        //将item下标当作收藏按钮的tag设置给收藏按钮
        cell.btn_collect.tag = indexPath.row
        //modi  设置收藏按钮点击事件时图片的高亮显示
//        if attentionArr.contains(indexPath.row){
//            if collectTAG == 1{
//            cell.btn_collect.selected = true
//            cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), forState: .Selected)
//            }else{
//                cell.btn_collect.selected = false
//                cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite"), forState: .Normal)
//            }
//            
//        }else{
//            cell.btn_collect.selected = false
//            cell.btn_collect.setImage(UIImage(named: "detail_interaction_bar_favorite"), forState: .Normal)
//        }
        cell.btn_collect.addTarget(self, action: #selector(collectButton), for: .touchUpInside)
        
        
 
        cell.btn_share.tag = indexPath.row   
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
//        self.present(video, animated: true, completion: nil)
    }
    
    //隐藏状态栏
//    override var prefersStatusBarHidden: Bool{
//        return false
//    }
    
    func collectButton(_ sender: UIButton){
        let collectbtn : UIButton! = sender
        //
     
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "accessToken") as? String
        print("accessToken:",accessToken)
        let model = "play"
        if collectTAG == 0{
            //通过上面设置的tag来获取到当前item中视频信息对应数据库中的视频id
            let id = data[collectbtn.tag].id
            print("collectButton id ----> ===== \(id)")
            print("collectButton attentionArr ----> ===== \(attentionArr.description)")
            //通过视频在数据库中的id来查询校验改item是否被收藏过：有返回2:无返回0:收藏成功
            if accessToken != nil {
        YMNetworkTool.shareNetworkTool.collectResult(accessToken!,model: model,id: id!){[weak self](error_codeMsg) in
                self!.error_codeMsg=error_codeMsg
            if self!.error_codeMsg == 0 {
                self!.attentionArr.append(collectbtn.tag)
                self!.collectTAG = 1
//                collectbtn.selected = true
//                collectbtn.setImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), forState: .Selected)
                collectbtn.setBackgroundImage(UIImage(named: "detail_interaction_bar_favorite_pressed"), for: UIControlState())
                print("收藏成功")
                Toast(text: "收藏成功").show()
                print("name:",self!.data[collectbtn.tag].name)
                
            }else if self!.error_codeMsg == 2 {
                print("已经收藏过了")
//                JLToast.makeText("已经收藏过了", delay: 0.5, duration: JLToastDelay.ShortDelay).show()
                print("name:",self!.data[collectbtn.tag].name)
                //取消收藏
                self!.cancelCollect(id!, accessToken: accessToken!, model: model,collectbtn: collectbtn)
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
            //取消收藏
            cancelCollect(id!, accessToken: accessToken!, model: model,collectbtn: collectbtn)
        }
        
        
    }
    
    func cancelCollect(_ id: String, accessToken:String, model: String, collectbtn: UIButton){
        YMNetworkTool.shareNetworkTool.decollectResult(accessToken,model: model,id: id){[weak self](error_codeMsg) in
            self!.error_codeMsg=error_codeMsg
            if self!.error_codeMsg == 0 {
                self!.attentionArr.append(collectbtn.tag)
                self!.collectTAG = 0
//                collectbtn.selected = false
//                collectbtn.setImage(UIImage(named: "detail_interaction_bar_favorite"), forState: .Normal)
                collectbtn.setBackgroundImage(UIImage(named: "detail_interaction_bar_favorite"), for: UIControlState())
                print("取消收藏")
                Toast(text: "取消收藏").show()
                print("name:",self!.data[collectbtn.tag].name)
            }else{
                print("请重新登录")
                Toast(text: "请重新登录").show()
            }
        }
    }
    
    func shareButton(_ sender: UIButton){
        print(sender.tag)
        print("name:",data[sender.tag].name)
        YMActionSheet.show()
    }
}

//同步视频接口：http://shiyan360.cn/index.php/api/video_list?desc_type=2&category_id=0&gradeid=408&page=1
//分类查询接口：http://www.shiyan360.cn/index.php/api/experiment_grade_list
//仿真二级分类接口：http://shiyan360.cn/index.php/api/experiment_category_list
//categoryid = "370";// 小学
//categoryid = "369";// 初中
//categoryid = "368";// 高中
//categoryid = "0"; 不限
extension YMProductViewController:DropMenuViewDelegate{
    func dropMenuClick(_ column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        switch column {
        case 0:
            switch row {
            case 0:
                gradeid = "0"
                loadVideoData()
                break
            case 1:
                gradeid = "434"
                loadVideoData()
                break
            case 2:
                gradeid = "433"
                loadVideoData()
                break
            case 3:
                gradeid = "432"
                loadVideoData()
                break
            case 4:
                gradeid = "431"
                loadVideoData()
                break
            case 5:
                gradeid = "430"
                loadVideoData()
                break
            case 6:
                gradeid = "429"
                loadVideoData()
                break
            case 7:
                gradeid = "415"
                loadVideoData()
                break
            case 8:
                gradeid = "414"
                loadVideoData()
                break
            case 9:
                gradeid = "413"
                loadVideoData()
                break
            case 10:
                gradeid = "408"
                loadVideoData()
                break
            case 11:
                gradeid = "407"
                loadVideoData()
                break
            case 12:
                gradeid = "406"
                loadVideoData()
                break
            case 13:
                gradeid = "412"
                loadVideoData()
                break
            case 14:
                gradeid = "411"
                loadVideoData()
                break
            case 15:
                gradeid = "410"
                loadVideoData()
                break
            case 16:
                gradeid = "409"
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
            case 1:
                categoryid = "371"
                loadVideoData()
                break
            case 2:
                categoryid = "373"
                loadVideoData()
                break
            case 3:
                categoryid = "375"
                loadVideoData()
                break
            case 5:
                categoryid = "377"
                loadVideoData()
                break
            case 4:
                categoryid = "0"
                loadVideoData()
                break
            case 6:
                categoryid = "386"
                loadVideoData()
                break
            case 7:
                categoryid = "387"
                loadVideoData()
                break
            case 8:
                categoryid = "388"
                loadVideoData()
                break
            case 9:
                categoryid = "389"
                loadVideoData()
                break
            case 10:
                categoryid = "396"
                loadVideoData()
                break
            case 11:
                categoryid = "397"
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
        case 2:
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
    
    //当视图将要显示的时候调用
    override func viewWillAppear(_ animated: Bool) {
        print("视图将要显示")
        //刷新下拉菜单的数据源
        self.tableView.es_startPullToRefresh()
        configMenuView()
        //当收藏条目大于20条时需要计算page：data.count / 20
        hignlightCollectButton(1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //手动刷新一次界面:解决收藏图标不显示问题
        tableView.reloadData()
    }
    
    func hignlightCollectButton(_ page: Int){
        
        //
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "accessToken") as? String
        print("accessToken:",accessToken)
        let model = "play"
        if accessToken != nil {
            YMNetworkTool.shareNetworkTool.collectList(accessToken!, model: model, page: page, finished: { (items) in
                if items.count>0 {
                    //记录已收藏item对应的ID
                    for item in items{
                        if !self.collectList.contains(item.videoid) {
                            self.collectList.append(item.videoid)
                        }
                        
                    }
                }
                
            })
        }else{
            print("请先进行登录")
//            Toast(text: "请先进行登录").show()
        }
        
    }
}



