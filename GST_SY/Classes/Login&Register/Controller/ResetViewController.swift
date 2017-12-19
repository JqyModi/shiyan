//
//  ResetViewController.swift
//  GST_SY
//
//  Created by Don on 16/9/27.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
//import JLToast
import Toaster

class ResetViewController: YMBaseViewController {
    var user_name: String!
    var user_code: String!
    var error_codeMsg : Int?
    
    @IBOutlet weak var resetPass: UIButton!
    @IBOutlet weak var passtextfiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonItem()
        // Do any additional setup after loading the view.
    }

    @IBAction func SubmitClick(_ sender: UIButton) {
        
        let userpass=passtextfiled.text
        let userpass_md5 = userpass!.md5()
//        let userpass_md5 = userpass!.md5Hash()
        if userpass!.isEmpty{
            Toast(text: "密码不能为空").show()
        }
        else {
         
            YMNetworkTool.shareNetworkTool.resetpassResult(user_name!, smscode: user_code!,userpass:userpass_md5){[weak self](error_codeMsg) in
                self!.error_codeMsg=error_codeMsg
                
                if (self!.error_codeMsg == 0) {
                    print("error_codeMsg:",self!.error_codeMsg)
                    Toast(text: "重置成功").show()
                    let userinfo = YMLoginViewController()
                    userinfo.title="登陆"
                    self!.navigationController?.pushViewController(userinfo, animated: true)
                }
                else {
                    Toast(text: "重置失败").show()
                }
                
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupButtonItem(){
        resetPass.backgroundColor = YMGlobalGreenColor()
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
