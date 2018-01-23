//
//  YMSearchViewController.swift
//  GST_SY
//

import UIKit
import Toaster
//import JLToast

let searchCollectionCellID = "searchCollectionCellID"

class YMSearchViewController: YMBaseViewController {
    let HOST = "http://shiyan360.cn"
   
    var results = [YMSearchRs]()
    
    weak var collectionView: UICollectionView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNav()
        
        view.addSubview(searchRecordView)
    }
    
 
    func setupNav() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(navigationBackClick))
    }
    
 
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.dataSource = self
        let nib = UINib(nibName: String(describing: YMCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: searchCollectionCellID)
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    

    func sortButtonClick() {
        popView.show()
    }
    
    fileprivate lazy var popView: YMSortTableView = {
        let popView = YMSortTableView()
        popView.delegate = self
        return popView
    }()
    
  
    func navigationBackClick() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索视频、实验、专题"
        return searchBar
    }()
    
    fileprivate lazy var searchRecordView: YMSearchRecordView = {
        let searchRecordView = YMSearchRecordView()
        searchRecordView.backgroundColor = YMGlobalColor()
        searchRecordView.frame = CGRect(x: 0, y: 64, width: SCREENW, height: SCREENH - 64)
        return searchRecordView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMSearchViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, YMCollectionViewCellDelegate, YMSortTableViewDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
  
        setupCollectionView()
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkUserType_backward_9x15_"), style: .plain, target: self, action: #selector(navigationBackClick))
        //隐藏搜索界面排序
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_sort_21x21_"), style: .Plain, target: self, action: #selector(sortButtonClick))
    
        let keyword = searchBar.text
        YMNetworkTool.shareNetworkTool.loadSearchResult(keyword!, sort: "") { [weak self] (results) in
            self!.results = results
            self!.collectionView!.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if results.count == 0 {
//            let label = UILabel(frame: CGRect(x: 10, y: 10, width: 60, height: 20))
//            label.text = "没有搜索到相关数据"
//            label.textColor = UIColor.redColor()
//            label.backgroundColor = UIColor.orangeColor()
//            searchRecordView.addSubview(label)
            //弹窗提示没有搜索到相关数据
            Toast(text: "没有搜索到相关数据").show()
        }
        return results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCollectionCellID, for: indexPath) as! YMCollectionViewCell
        cell.result = results[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let productDetailVC = YMProductDetailViewController()
//        productDetailVC.title = "商品详情"
//        productDetailVC.type = String(self)
//        productDetailVC.result = results[indexPath.item]
//        navigationController?.pushViewController(productDetailVC, animated: true)
        
        let url = HOST + results[indexPath.row].url!
        let name = results[indexPath.row].title
        debugPrint("url:",url)
        debugPrint("name:",name)

        if (url.contains(".mp4")) {
            //展示视频
            let video = VideoPlayViewController()
            video.videoname=name as NSString!
            video.videourl=url as NSString!
            self.navigationController?.pushViewController(video, animated: true)
        }else{
            //展示文档
            let video = WenKuDetailViewController()
            video.filename=name as NSString!
            video.fileurl=url as NSString!
            video.title="文库详情"
            self.navigationController?.pushViewController(video, animated: true)
        }
        
        //        self.presentViewController(video, animated: true, completion: nil)
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        debugPrint(indexPath.row)
//        
//        
//        let url = data[indexPath.row].videoUrl
//        let name = data[indexPath.row].name
//        debugPrint("url:",url)
//        debugPrint("name:",name)
//        
//        let video = VideoPlayViewController()
//        video.videoname=name
//        video.videourl=url
//        self.navigationController?.pushViewController(video, animated: true)
//        //        self.presentViewController(video, animated: true, completion: nil)
//    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 20) / 2
        let height: CGFloat = 245
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    // MARK: - YMCollectionViewCellDelegate
    func collectionViewCellDidClickedLikeButton(_ button: UIButton) {
        if !UserDefaults.standard.bool(forKey: isLogin) {
            let loginVC = YMLoginViewController()
            loginVC.title = "登录"
            let nav = YMNavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
        } else {
            
        }
    }
    
    // MARK: - YMSortTableViewDelegate
    func sortView(_ sortView: YMSortTableView, didSelectSortAtIndexPath sort: String) {
      
        let keyword = searchBar.text
        YMNetworkTool.shareNetworkTool.loadSearchResult(keyword!, sort: sort) { [weak self] (results) in
            sortView.dismiss()
            self!.results = results
            self!.collectionView!.reloadData()
        }
    }
    
}
