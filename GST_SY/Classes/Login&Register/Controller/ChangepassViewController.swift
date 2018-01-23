//
//  ChangepassViewController.swift
//  GST_SY
//
//  Created by Don on 16/9/27.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
//import MD5
//import JLToast
import Toaster
import CryptoSwift

class ChangepassViewController: YMBaseViewController {
    @IBOutlet weak var oldpassTextFlied: UITextField!

    @IBOutlet weak var newpassTextFlied: UITextField!
    
    var oldpassword: String!
    var newpassword: String!
    var accessToken: String!
    var error_codeMsg : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefault = UserDefaults.standard
        accessToken = userDefault.object(forKey: "accessToken") as? String
        debugPrint("accessToken:",accessToken)
    }

    @IBAction func changepassClick(_ sender: UIButton) {
        oldpassword = oldpassTextFlied.text?.md5()
        newpassword = newpassTextFlied.text?.md5()
//         oldpassword = oldpassTextFlied.text?.md5Hash()
//         newpassword = newpassTextFlied.text?.md5Hash()
        
        //table
        let table = UserDefaults.standard.object(forKey: "table") as? String
        
        if oldpassword!.isEmpty{
            Toast(text: "旧密码不能为空").show()
        }else if newpassword!.isEmpty{
            Toast(text: "新密码不能为空").show()
        }else{
            
        if accessToken != nil{
           
            YMNetworkTool.shareNetworkTool.changepassResult(accessToken!, old_pass: oldpassword!,new_pass: newpassword, table: table!){ [weak self](error_codeMsg) in
                self!.error_codeMsg=error_codeMsg
                if self!.error_codeMsg == 0 {
                    
                    let userinfo = YMLoginViewController()
                    userinfo.title = "登陆"
                    self!.navigationController?.pushViewController(userinfo, animated: true)
                    Toast(text: "修改成功").show()
                }else{
                    debugPrint("修改失败")
                    Toast(text: "修改失败").show()
                }
            }
        }else{
            debugPrint("请先进行登录")
            Toast(text: "请先进行登录").show()
        }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
