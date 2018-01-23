//
//  UserInfoViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
import Toaster
//import JLToast
class UserInfoViewController: YMBaseViewController {
    @IBOutlet weak var avastar: UIImageView!
    @IBOutlet weak var nickname_btn: UIButton!
    @IBOutlet weak var name_btn: UIButton!
    @IBOutlet weak var identity_btn: UIButton!
    @IBOutlet weak var school_btn: UIButton!
    @IBOutlet weak var phonenum_btn: UIButton!
    @IBOutlet weak var changepass_btn: UIButton!
    @IBOutlet weak var logout_btn: UIButton!
    
    var accessToken :String?
    var user = [UserInfoModel]()
    var phoneNum :String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogoutButtonItem()
        
        let userDefault = UserDefaults.standard
        accessToken = userDefault.object(forKey: "accessToken") as? String
        let table = userDefault.object(forKey: "table") as? String
        
        debugPrint("accessToken:",accessToken)
        debugPrint("table:",table)
        if accessToken != nil{
            YMNetworkTool.shareNetworkTool.userInfoList(accessToken!, table: table!){ [weak self](results) in
                self?.user=results
                debugPrint("user get",self?.user)
                //更新用户信息
                self!.setUserUI()
            }
            
        }else{
            debugPrint("请先进行登录")
            Toast(text: "请先进行登录").show()
        }

    }
    
    fileprivate func setupLogoutButtonItem(){
        logout_btn.backgroundColor = YMGlobalGreenColor()
    }
    
    @IBAction func ChangepassClick(_ sender: UIButton) {
        
        let userinfo = ChangepassViewController()
        userinfo.title=" 修改密码"
        navigationController?.pushViewController(userinfo, animated: true)
    }

    @IBAction func loginoutclick(_ sender: AnyObject) {
        Toast(text: "退出登录").show()

        let defaults : UserDefaults = UserDefaults.standard
        defaults.setValue("", forKey: "accessToken")
        defaults.setValue("", forKey: "userpassMD5")
        defaults.setValue("", forKey: "username")
        //
        defaults.setValue("", forKey: "table")
        defaults.set(false, forKey: isLogin)
        defaults.synchronize()
       
        self.navigationController?.popToRootViewController(animated: true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setUserUI(){
    
        if self.user[0].nickname != ""{
            self.nickname_btn.setTitle(self.user[0].nickname, for: UIControlState())
        }
        else{
            nickname_btn.setTitle("未填写", for: UIControlState())
        }
 
        if self.user[0].name != ""{
            name_btn.setTitle(user[0].name, for: UIControlState())
        }
        else{
            name_btn.setTitle("未填写", for: UIControlState())
        }
     
        phonenum_btn.setTitle(phoneNum, for: UIControlState())
        
    }

}

