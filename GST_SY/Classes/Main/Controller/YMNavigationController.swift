//
//  YMNavigationController.swift
//  GST_SY
//

import UIKit
import SVProgressHUD

class YMNavigationController: UINavigationController {

    internal override class func initialize() {
        super.initialize()
      
        let navBar = UINavigationBar.appearance()
        // modi 设置导航栏颜色
//        navBar.barTintColor = YMGlobalRedColor()
        navBar.barTintColor = YMGlobalGreenColor()
        
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
       
        if viewControllers.count > 0 {
         
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkUserType_backward_9x15_"), style: .plain, target: self, action: #selector(navigationBackClick))
        }
        
        super.pushViewController(viewController, animated: true)
    }
   
    func navigationBackClick() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        popViewController(animated: true)
    }

}
