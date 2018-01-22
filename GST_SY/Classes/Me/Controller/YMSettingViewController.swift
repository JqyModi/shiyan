//
//  YMSettingViewController.swift
//  GST_SY
//

import UIKit
import Kingfisher
class YMSettingViewController: YMBaseViewController, UIActionSheetDelegate {
    
    var settings = [AnyObject]()
    var tableView: UITableView?
    var accessToken :String?
    var loginValidates : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        calcuateCacheSizeFromSandBox()
        
  
        configCellFromPlist()
        
        
        setupTableView()
        
        
        
    }

    fileprivate func calcuateCacheSizeFromSandBox() {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { (size) in
            let sizeM = Double(size) / 1024.0 / 1024.0
            let sizeString = String(format: "%.2fM", sizeM)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
//            NotificationCenter.default.postNotificationName("cacheSizeM", object: self, userInfo: ["cacheSize": sizeString])
        }
    }
    

    func configCellFromPlist() {
        let path = Bundle.main.path(forResource: "SettingCell", ofType: ".plist")
        let settingsPlist = NSArray.init(contentsOfFile: path!)
        for arrayDict in settingsPlist! {
            let array = arrayDict as! NSArray
            var sections = [AnyObject]()
            for dict in array {
                let setting = YMSetting(dict: dict as! [String: AnyObject])
                sections.append(setting)
            }
            settings.append(sections as AnyObject)
        }
    }
    

    fileprivate func setupTableView() {
        let tableView = UITableView()
        tableView.frame = view.bounds
        
        tableView.separatorStyle = .none
        let nib = UINib(nibName: String(describing: YMSettingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: messageCellID)
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        self.tableView = tableView
        
        configTableStyle()
        
    }
    
    func configTableStyle(){
        tableView!.backgroundColor = GSTGlobalBgColor()
        tableView!.separatorStyle = .none
    }
    
    fileprivate func clearCacheAlertController(_ indexPath : IndexPath) {
//        let alertController = UIAlertController(title: "确定清除所有缓存？", message: nil, preferredStyle: .ActionSheet)
//        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//        let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (_) in
//            let cache = KingfisherManager.sharedManager.cache
//            cache.clearDiskCache()
//            cache.clearMemoryCache()
//            cache.cleanExpiredDiskCache()
//            let sizeString = "0.00M"
//            NSNotificationCenter.defaultCenter().postNotificationName("cacheSizeM", object: self, userInfo: ["cacheSize": sizeString])
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        
//        //modi iPad上崩溃修复
//        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"title" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        //        for (int i = 0; i < 10; i++) {
//        //            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"actionTitle%d",i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //
//        //                }];
//        //            [alertController addAction:action];
//        //        }
//        //        alertController.popoverPresentationController.sourceView = self.view;
//        //        alertController.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
//        //        [self presentViewController:alertController animated:YES completion:nil];
//        
//        let popover = alertController.popoverPresentationController
//        //指定UIAlertAction弹出位置参照控件
//        let sender = tableView?.cellForRowAtIndexPath(indexPath)
//        let focus = tableView?.cellForRowAtIndexPath(indexPath)?.frame
//        popover!.sourceView = self.view
//        //指定弹窗的位置x,y,width,height
//        popover!.sourceRect = CGRectMake((SCREENW-80)/2,(sender?.y)!+(sender?.height)!,80,50);
////        popover?.sourceRect = focus!
//        //设置箭头指向
//        popover?.permittedArrowDirections = UIPopoverArrowDirection.Up
//        popover?.permittedArrowDirections = UIPopoverArrowDirection.Right
        
        
        //改变AlertAction在iPad上显示的样式
//        if #available(iOS 9.0, *) {
//            alertController.popoverPresentationController?.canOverlapSourceViewRect = true
//        } else {
//            // Fallback on earlier versions
//        }
//        alertController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
//        alertController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
//        presentViewController(alertController, animated: true, completion: nil)
        
        let action = UIActionSheet(title: "确定清除所有缓存？", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "清除")
        action.show(in: self.view)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            print("bottonIndex = \(buttonIndex)")
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            let sizeString = "0.00M"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension YMSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setting = settings[section] as! [YMSetting]
        return setting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID) as! YMSettingCell
        let setting = settings[indexPath.section] as! [YMSetting]
        cell.setting = setting[indexPath.row]
        
        
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                NotificationCenter.default.addObserver(self, selector: #selector(loadCacheSize(_:)), name: NSNotification.Name(rawValue: "cacheSizeM"), object: self)
                
            }
        }
        
        return cell
    }

    func loadCacheSize(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 2, section: 1)
        let cell = tableView?.cellForRow(at: indexPath) as! YMSettingCell
        
        cell.rightLabel.text = userInfo["cacheSize"] as? String
        print("缓存大笑：",userInfo["cacheSize"] as? String ?? "0.0")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin + 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            print("section 0:",indexPath.section)
            switch indexPath.row {
            case 0:
             
                let userDefault = UserDefaults.standard
                accessToken = userDefault.object(forKey: "accessToken") as? String
                debugPrint("accessToken:",accessToken ?? "")
                
            
                if UserDefaults.standard.bool(forKey: isLogin) {
                    let username = userDefault.object(forKey: "username") as? String
                    let userpass_md5 = userDefault.object(forKey: "userpassMD5") as? String
                    //新增字段
                    let table = userDefault.object(forKey: "table") as? String
                    debugPrint("table ------> \(String(describing: table))")
                    YMNetworkTool.shareNetworkTool.loginResult(username!, userpass: userpass_md5!, school: table!){[weak self](loginValidate) in
                        self?.loginValidates=loginValidate
                        if (self!.loginValidates == true) {
                            print("自动登录成功")
                            let userinfo = UserInfoViewController()
                            userinfo.title = "账号信息"
                            userinfo.phoneNum = username
                            self!.navigationController?.pushViewController(userinfo, animated: true)
                        }
                        else{
                            print("自动登录失败")
                            //保存accessToken
                            let defaults : UserDefaults = UserDefaults.standard
                            defaults.setValue("", forKey: "accessToken")
                            defaults.setValue("", forKey: "userpassMD5")
                            defaults.setValue("", forKey: "username")
                            defaults.set(false, forKey: isLogin)
                            defaults.setValue("", forKey: "table")
                            defaults.synchronize()
                            
                        }
                    }
                    
                }else{
             
                    let login = YMLoginViewController()
                    login.title = "登陆"
                    self.navigationController?.pushViewController(login, animated: true)
                }
                
                print("sec 0 row 0:",indexPath.row)
                break
            case 1:
                print("sec 0 row 1:",indexPath.row)
                
                let userinfo = CollectViewController()
                userinfo.title="我的收藏"
                navigationController?.pushViewController(userinfo, animated: true)
          
                break
            case 2:
                print("sec 0 row 2:",indexPath.row)
                //浏览记录
                let userinfo = HistoryViewController()
                userinfo.title="浏览记录"
                navigationController?.pushViewController(userinfo, animated: true)
                break
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                print("sec 1 row 0:",indexPath.row)
                let feedback = FeedBackViewController()
                feedback.title = "意见反馈"
                self.navigationController?.pushViewController(feedback, animated: true)
     
                break
            case 1:
                print("sec 1 row 1:",indexPath.row)
                
                let alertController = UIAlertController(title: "扫描二维码，下载实验掌上通",message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
              
                let alertAction = UIAlertAction(title: "确认", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
        
                let image = UIImage(named: "q_code.png")
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 40, y: 60, width: 200, height: 200)
                
                alertController.view.addSubview(imageView)
                
             
                break
            case 2:
                print("sec 1 row 2:",indexPath.row)
                //清楚缓存
                clearCacheAlertController(indexPath)
                break
            case 3:
                print("sec 1 row 3:",indexPath.row)
      
                let userinfo = AboutViewController()
                userinfo.title="关于我们"
                navigationController?.pushViewController(userinfo, animated: true)
                break
            default:
                break
            }
        default:
            break
        }
    }
    
}
