//
//  YMTabBarController.swift
//  GST_SY
//

import UIKit

class YMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置tabbar的主题色
//        tabBar.tintColor = UIColor(red: 245 / 255, green: 80 / 255, blue: 83 / 255, alpha: 1.0)
//        tabBar.tintColor = UIColor(red: 169 / 255, green: 225 / 255, blue: 48 / 255, alpha: 1.0)
        tabBar.tintColor = YMGlobalGreenColor()
        addChildViewControllers()
        
        //
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 169 / 255, green: 225 / 255, blue: 48 / 255, alpha: 1.0)
    }

    fileprivate func addChildViewControllers() {
        /*
         * YMGST_SYViewController,这个Controller是属于实验首页
         */
        addChildViewController("YMGST_SYViewController", title: "实验首页", imageName: "TabBar_home_23x23_")
        /*
         * YMProductViewController,这个Controller是属于同步视频
         */
        addChildViewController("YMProductViewController", title: "同步视频", imageName: "TabBar_gift_23x23_")
        /*
         * YMCategoryViewController，这个Controller是属于仿真试验
         */
        addChildViewController("YMCategoryViewController", title: "仿真实验", imageName: "TabBar_category_23x23_")
        /*
         * YMSettingViewController,这个Controller是属于更多设置
         */
        addChildViewController("YMSettingViewController", title: "更多设置", imageName: "TabBar_me_boy_23x23_")
    }
  
    fileprivate func addChildViewController(_ childControllerName: String, title: String, imageName: String) {
       
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
       
        let cls: AnyClass? = NSClassFromString(ns + "." + childControllerName)
        let vcClass = cls as! UIViewController.Type
        let vc = vcClass.init()
    
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "selected")
        vc.title = title
        print("title === \(title)")
      
        let nav = YMNavigationController()
        //获取导航栏高度
//        print("nav.navigationBar.height ===== \(nav.navigationBar.height)")
//        print("tabBar.height ===== \(self.tabBar.height)")
        
        nav.addChildViewController(vc)
        addChildViewController(nav)
        NSLog("\(nav.navigationBar.height)", "g%")
    }

}
