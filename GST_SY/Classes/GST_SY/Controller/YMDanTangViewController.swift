//
//  YMGST_SYViewController.swift
//  GST_SY
//


import UIKit
import Toaster

class YMGST_SYViewController: YMBaseViewController,CarouselBannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    var channels = [YMChannel]()
    var collectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    var bannerView = CarouselBannerView()
    var imageSource = NSArray()
    var scrollImageUrls: [String] {
        get {
            return ["a01.png", "a02.png", "a03.png", "a04.png"]
        }
    }
//    let courses = [
//        ["name":"实验资讯","pic":"sc_message.png"],
//        ["name":"名师讲堂","pic":"te_activity.png"],
//        ["name":"实验文库","pic":"ex_library.png"],
//        ["name":"考试视频","pic":"tr_college.png"],
//        ["name":"创客空间","pic":"ck_space.png"],
//        ["name":"会展中心","pic":"tr_college.png"],
//        ["name":"培训学院","pic":"sen_physical.png"],
//        ["name":"实验装备","pic":"sen_biological.png"],
//        ["name":"小学科学","pic":"pri_science.png"],
//        ["name":"初中物理","pic":"mid_physical.png"],
//        ["name":"初中化学","pic":"mid_chemical.png"],
//        ["name":"初中生物","pic":"mid_biological.png"]
//    ]
    
    let courses = [
        ["name":"同步视频","pic":"grid_tb.png"],
        ["name":"实验文库","pic":"grid_wk.png"],
        ["name":"考评系统","pic":"grid_kp.png"],
        ["name":"备考视频","pic":"grid_bk.png"],
        ["name":"实验装备","pic":"grid_zb.png"],
        ["name":"名师讲堂","pic":"grid_jt.png"],
        ["name":"创新实验","pic":"grid_cx.png"],
        ["name":"活动赛事","pic":"grid_hd.png"],
        ["name":"新闻动态","pic":"grid_hz.png"]

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNav()
       
        YMNetworkTool.shareNetworkTool.loadHomeTopData { [weak self] (ym_channels) in
            for channel in ym_channels {
                let vc = YMTopicViewController()
                vc.title = channel.name!
                vc.type = channel.id!
                self!.addChildViewController(vc)
            }
 
        }
        
        self.setupViewPager()
        
        setupTabView()

    }
   
    func setupNav() {
        view.backgroundColor = UIColor.white
    }
    
   
    func setupViewPager(){
     
        self.bannerView = CarouselBannerView.init(frame: CGRect(x: 0, y: kTitlesViewH, width: SCREENW, height: SCREENH*1/3-kTitlesViewH))
        self.view.addSubview(self.bannerView)
        self.bannerView.bannerDelegate = self
        
        //        imageSource = NSArray.init(objects: "http://static.damai.cn/cfs/2015/12/1ab03ad9-fcab-4806-b2a9-56e111bcde1f.jpg","http://static.dmcdn.cn/cfs/2016/1/86cb20f1-ec19-451a-975c-9123a92b1b16.jpg","http://static.dmcdn.cn/cfs/2015/12/f1f88dd4-493f-43d0-9f67-a62c4ce70d54.jpg","http://pimg.damai.cn/perform/damai/NewIndexManagement/201601/e0cbde39ecc94a4986e9ed8f6b2767e8.jpg")
        imageSource=scrollImageUrls as NSArray
        
        self.perform(#selector(YMGST_SYViewController.fetchData), with:nil, afterDelay: 3)
    }
  
    func fetchData(){
        self.bannerView .reloadData()
    }
   
    func scrollView(toScrollView scrollView: CarouselBannerView, andImageAtIndex index: NSInteger, forImageView imageView: UIImageView) {
        
//        imageView.kf_setImageWithURL(NSURL(string: imageSource.objectAtIndex(index) as! String)!, placeholderImage: UIImage.init(named: "a02.png"))
        imageView.image = UIImage(named: imageSource.object(at: index) as! String)
    }
   
    func numberOfImageInScrollView(toScrollView scrollView: CarouselBannerView) -> Int {
        return imageSource.count
    }
   
    func  scrollView ( toScrollView scrollView : CarouselBannerView, didTappedImageAtIndex  index : NSInteger){
        print("点击\(index)")
    }


    fileprivate func setupTabView(){
        
        //modi 通过该布局来控制Cell的样式及位置
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing=3
        layout.minimumInteritemSpacing=3
        //设置单元格Cell的宽高
//        layout.itemSize=CGSizeMake(SCREENW/3-1, 133)
        layout.itemSize=CGSize(width: (SCREENW-9)/3, height: ((SCREENH-bannerView.height-44-49-6) + 3)/3)
//        layout.sectionInset = UIEdgeInsets(top:0, left:0, bottom:0, right:0)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: SCREENH*1/3, width: SCREENW, height: SCREENH*2/3-50), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "gridcell")
        collectionView.backgroundColor = GSTGlobalBgColor()
        self.view.addSubview(collectionView)


    }
   
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      
        return courses.count;
    }
    

  
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridcell", for: indexPath) as! GridCollectionViewCell
        cell.textLabel?.text = courses[indexPath.item]["name"]
         cell.imageView?.image = UIImage(named: courses[indexPath.item]["pic"]!)
        cell.backgroundColor = UIColor.white
               return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top:0, left: 0, bottom:0, right: 1)
    }

    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        print("点击了：",indexPath)
        switch indexPath.item {
        case 0:
            print("点击了：",indexPath.item)
            let syncVideo = YMProductViewController(nibName: nil, bundle: nil)
            self.navigationController?.pushViewController(syncVideo, animated: true)
            syncVideo.title = "同步视频"
        case 1:
            let chuangke = WenKuViewController()
            chuangke.title = "实验文库"

            self.navigationController?.pushViewController(chuangke, animated: true)
            
        case 2:
            //判断用户是否登录
            let userDefault = UserDefaults.standard
            let accessToken = userDefault.object(forKey: "accessToken") as? String
            print("accessToken:",accessToken)
            if (accessToken != "") {
                let chuangke = KaoPingViewController()
                chuangke.title = "考评系统"
                self.navigationController?.pushViewController(chuangke, animated: true)
            }else {
                Toast(text: "您还没有登录哦 ~ 请先到个人中心登录").show()
                return
            }
            
            print("点击了：",indexPath.item)
        case 3:
            print("点击了：",indexPath.item)
            let chuangke = KaoShiViewController()
            chuangke.title = "备考视频"
            
            self.navigationController?.pushViewController(chuangke, animated: true)
        case 4:
            let chuangke = ZhuangBeiVIewController()
            chuangke.title = "实验装备"
            self.navigationController?.pushViewController(chuangke, animated: true)

        case 5:
            print("点击了：",indexPath.item)
            let chuangke = MingShiViewController()
            chuangke.title = "名师讲堂"
            self.navigationController?.pushViewController(chuangke, animated: true)
        case 6:
            print("点击了：",indexPath.item)
            let chuangke = ChuangKeViewController()
            chuangke.title = "创新实验"
            self.navigationController?.pushViewController(chuangke, animated: true)
        case 7:
            print("点击了：",indexPath.item)
            let chuangke = VoteListCollectionViewController()
            chuangke.title = "活动赛事"
            self.navigationController?.pushViewController(chuangke, animated: true)
        case 8:
            //http://shiyan360.cn/index.php/api/article_list?desc_type=0&category_id=134
            let chuangke = HuiZhanViewController()
             chuangke.title = "新闻动态"
            chuangke.categoryid = "134"
            self.navigationController?.pushViewController(chuangke, animated: true)
            print("点击了：",indexPath.item)
//        case 9:
//            let chuangke = XueKeViewController()
//            chuangke.title = "初中物理"
//            chuangke.categoryid = "386"
//            self.navigationController?.pushViewController(chuangke, animated: true)
//            print("点击了：",indexPath.item)
//        case 10:
//            let chuangke = XueKeViewController()
//            chuangke.title = "初中化学"
//            chuangke.categoryid = "387"
//            self.navigationController?.pushViewController(chuangke, animated: true)
//            print("点击了：",indexPath.item)
//        case 11:
//            let chuangke = XueKeViewController()
//            chuangke.title = "初中生物"
//            chuangke.categoryid = "388"
//            self.navigationController?.pushViewController(chuangke, animated: true)
//            print("点击了：",indexPath.item)
        
            
        default:
            print("点击了：",indexPath.item)
        }
    }

}






