//
//  SetPassViewController.swift
//  GST_SY
//
//  Created by Don on 16/9/1.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
//import MD5
//import JLToast
import Toaster
import CryptoSwift
import SVProgressHUD

class SetPassViewController: YMBaseViewController {

    var user_name: String!
    var user_code: String!
    var error_codeMsg : Int?
//    var user_email : String?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var regiest_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regiestButtonClick(_ sender: UIButton) {
        let userpass=passField.text
        let useremail=emailField.text
        
        print("邮箱  == \(useremail)")
        print("密码 == \(userpass)")
        
        let userpass_md5 = userpass!.md5()
//        let userpass_md5 = userpass!.md5Hash()
        if userpass!.isEmpty{
//            Toast(text: "密码不能为空").show()
            SVProgressHUD.showError(withStatus: "密码不能为空")
        }
        else {
     
//            YMNetworkTool.shareNetworkTool.setpassResult(user_name!, smscode: user_code!,userpass:userpass_md5){[weak self](error_codeMsg) in
//                self!.error_codeMsg=error_codeMsg
//                
//                if (self!.error_codeMsg == 0) {
//                    print("error_codeMsg:",self!.error_codeMsg)
//                    JLToast.makeText("注册成功", delay: 0.5, duration: JLToastDelay.ShortDelay).show()
//                    let userinfo = YMLoginViewController()
//                    userinfo.title="登陆"
//                    self!.navigationController?.pushViewController(userinfo, animated: true)
//                }
//                else {
//                    JLToast.makeText("注册失败", delay: 0.5, duration: JLToastDelay.ShortDelay).show()
//                }
//                
//                
//                
//            }
            
            YMNetworkTool.shareNetworkTool.setpassResult(user_name!, smscode: user_code!,userpass:userpass_md5, useremail:useremail!){[weak self](error_codeMsg,msg1) in
                self!.error_codeMsg=error_codeMsg
                
                print("注册返回消息\(msg1)")
                
                if (self!.error_codeMsg == 0) {
                    print("error_codeMsg:",self!.error_codeMsg)
//                    Toast(text: "注册成功").show()
                    SVProgressHUD.showError(withStatus: "注册成功")
                    let userinfo = YMLoginViewController()
                    userinfo.title="登陆"
                    self!.navigationController?.pushViewController(userinfo, animated: true)
                }
                else {
                    SVProgressHUD.showError(withStatus: "注册失败")
//                    Toast(text: "注册失败").show()
                }
                
                
                
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func setupButtonItem(){
        regiest_btn.backgroundColor = YMGlobalGreenColor()
    }
    
}
