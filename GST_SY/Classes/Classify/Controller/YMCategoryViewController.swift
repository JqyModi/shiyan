//
//  YMCategoryViewController.swift

import UIKit
import BMPlayer
import SVProgressHUD

let expCellID = "videocell"

class YMCategoryViewController: YMBaseViewController {
    var tableView : UITableView!
    var menuView = WOWDropMenuView()
    var videos = [Experiment]()
    var data:Array <Experiment> = []
    
    var desctype :String?
    var categoryid :String?
    var gradeid :String?
    var page : Int?
    
    var exp_gdcate = [CK_Cate]()
    var exp_cate = [CK_Cate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Feed_SearchBtn_18x18_"), style: .plain, target: self, action: #selector(categoryRightBBClick))
        
        categoryid = "0"
        desctype = "0"
        gradeid = "0"
        page = 1
        
         configMenuView()
        setupTableView()
        
        
        YMNetworkTool.shareNetworkTool.getExperiment(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in
            
            self?.videos=videos
            self!.data = self!.videos
            self!.tableView!.reloadData()
        }

        YMNetworkTool.shareNetworkTool.exp_GdCate_Result{ [weak self] (ck_cate) in
            self?.exp_gdcate = ck_cate
        }
   
        YMNetworkTool.shareNetworkTool.exp_Cate_Result{ [weak self] (ck_cate) in
            self?.exp_cate = ck_cate
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
    
        YMNetworkTool.shareNetworkTool.getExperiment(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](videos) in
            if videos.count > 0 {
                self!.videos.removeAll()
                self?.videos=videos
                self!.data = self!.videos
                print("data:",self!.data)
                self!.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: "数据加载失败请检测网络是否正常")
            }
        }
        
        
        
    }
    func loadmoreVideoData() {
    
        YMNetworkTool.shareNetworkTool.getExperiment(desctype!, categoryid: categoryid!,gradeid: gradeid!, page: page!){ [weak self](items) in
            
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
        
        let nib = UINib(nibName: String(describing: ExperimentTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: expCellID)
        
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

    func categoryRightBBClick() {
        let searchBarVC = YMSearchViewController()
        navigationController?.pushViewController(searchBarVC, animated: true)
    }
    fileprivate func configMenuView(){
        WOWDropMenuSetting.columnTitles = ["全部年级","全部分类","按最新"]
        WOWDropMenuSetting.rowTitles =  [
            ["不限","选修6","选修5","选修4","选修3","选修2","选修1","必修三","必修二","必修一","初三","初二","初一","小六","小五","小四","小三"],
            ["不限","高中物理","高中化学","高中生物","……","初中物理","初中化学","初中生物","……","小学科学","……"],
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
extension YMCategoryViewController: ExperimentTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expCellID) as! ExperimentTableViewCell
        cell.selectionStyle = .none
        cell.videoItem = data[indexPath.row] 
        cell.delegate = self
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        let url = data[indexPath.row].html5Url
        let name = data[indexPath.row].name
        print("url:",url)
        print("name:",name)
        let video = ExperimentDetailViewController()
        video.expname=name as NSString!
        video.expurl=url as NSString!
        video.title=name
        self.navigationController?.pushViewController(video, animated: true)
        //        self.presentViewController(video, animated: true, completion: nil)
    }
}
extension YMCategoryViewController:DropMenuViewDelegate{
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
                gradeid = exp_cate[row - 1].id
                print("gradeid:",gradeid)
                print("gradeidname:",exp_cate[row - 1].name)
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
                categoryid = exp_cate[row - 1].id
                print("categoryid:",categoryid)
                print("categoryidname:",exp_cate[row - 1].name)
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
    }
}
