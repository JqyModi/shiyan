//
//  FeedBackViewController.swift
//  GST_SY
//
//  Created by Don on 16/8/29.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
//import JLToast
import Toaster
import SVProgressHUD

class FeedBackViewController: YMBaseViewController {
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var qqField: UITextField!
    @IBOutlet weak var adviceField: UITextField!
    var error_codeMsg : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnSubmit.backgroundColor = YMGlobalGreenColor()
        
        configStyle()
    }

    func configStyle(){
        
    }
    
    @IBAction func SubmitClick(_ sender: UIButton) {
        let name = nameField.text
        if adviceField.text!.isEmpty {
            SVProgressHUD.showError(withStatus: "请输入内容")
//            Toast(text: "请输入内容").show()
        }
        else if (phoneField.text! == "") && (emailField.text! == "") && (qqField.text! == ""){
//            Toast(text: "为了让我联系到您，请至少填一种联系方式吧～").show()
            SVProgressHUD.showError(withStatus: "为了让我联系到您，请至少填一种联系方式吧～")
        }else{
            debugPrint("成功")
            
            YMNetworkTool.shareNetworkTool.feedbackResult(adviceField.text!, name: name!,tel: phoneField.text!,email: emailField.text!,qq: qqField.text!){[weak self](error_codeMsg) in
                self!.error_codeMsg=error_codeMsg
                
                if (self!.error_codeMsg == 0) {
                    debugPrint("error_codeMsg:",self!.error_codeMsg)
//                    Toast(text: "提交反馈成功").show()
                    SVProgressHUD.showError(withStatus: "提交反馈成功")
                    self!.navigationController?.popToRootViewController(animated: true)
                }
                else {
//                    Toast(text: "提交反馈失败").show()
                    SVProgressHUD.showError(withStatus: "提交反馈失败")
                }
                
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
