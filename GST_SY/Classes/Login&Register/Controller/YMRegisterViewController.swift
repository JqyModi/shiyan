//
//  YMRegisterViewController.swift
//  GST_SY
//

import UIKit
//import MD5
//import JLToast
import Toaster
import SVProgressHUD

class YMRegisterViewController: YMBaseViewController {

    @IBOutlet weak var mobileField: UITextField!
    
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var vertifyButton: UIButton!
    @IBOutlet weak var setPassBtn: UIButton!
    var error_codeMsg : Int?
    var code_type : Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mobileField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.shared.windows[UIApplication.shared.windows.count - 1].addSubview(self.view)
        
        //设置按钮主题色
        setupButtonItem()
        
    }
   
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let username=mobileField.text
//        Toast(text: "提示信息").show()
        debugPrint("username ==== \(username)")
        
        if !YMIstelphnum.init().isTelNumber(username! as NSString) {
//            Toast(text: "手机号码输入有误").show()
            SVProgressHUD.showError(withStatus: "手机号码输入有误")
        }
        else {
            //请求短信验证码
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: username, zone: "86", result:{(error) in
                if (error == nil){
//                    Toast(text: "验证码已经发送").show()
                    SVProgressHUD.showError(withStatus: "验证码已经发送，请注意查收")
                    
                    self.showTimeInButton(btn: sender)
                    debugPrint("请求成功,请等待短信～")
                }else{
                    // 错误码可以参考‘SMS_SDK.framework / SMSSDKResultHanderDef.h’
                    debugPrint("请求失败", error)
                    SVProgressHUD.showError(withStatus: "请求失败")
                }
            })
        }
    }
    
    func showTimeInButton(btn: UIButton){
        //设定定时时间为10s
        var countTime = 60
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每0.5秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .milliseconds(1000))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每半秒计时一次
            countTime = countTime - 1
            DispatchQueue.main.async {
                btn.isEnabled = true
                btn.backgroundColor = YMGlobalGreenColor()
                btn.setTitle(String("未收到?重新发送"), for: .normal)
            }
            
            // 时间到了取消时间源
            if countTime <= 0{
                codeTimer.cancel()
            }else{
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
                    btn.isEnabled = false
                    btn.backgroundColor = GSTGlobalBgColor()
                    btn.setTitle(String(countTime), for: .normal)
                }
            }
        })
        //启动定时器
        codeTimer.activate()
    }

    @IBAction func VerificationCodeSumbit(_ sender: UIButton) {
        let username=mobileField.text
        let VerificationCode=codeField.text
        
        if !YMIstelphnum.init().isTelNumber(username! as NSString) {
//            Toast(text: "手机号码输入有误").show()
            SVProgressHUD.showError(withStatus: "手机号码输入有误")
        }
        else if VerificationCode!.isEmpty{
//            Toast(text: "验证码不能为空").show()
            SVProgressHUD.showError(withStatus: "验证码不能为空")
        }
        else {
            //提交短信验证码
            SMSSDK.commitVerificationCode(VerificationCode, phoneNumber: username, zone: "86", result: {(error) in
                debugPrint("开始验证短信")
                if ((error == nil))
                {
                    // 验证成功
                    debugPrint("短信验证成功")
//                    Toast(text: "验证码验证成功").show()
                    SVProgressHUD.showError(withStatus: "验证码验证成功")
                    let userinfo = SetPassViewController()
                    userinfo.title="设置密码"
                    userinfo.user_name=username
                    userinfo.user_code=VerificationCode
                    self.navigationController?.pushViewController(userinfo, animated: true)
                }
                else
                {
                    // error
                    debugPrint("短信验证失败")
//                    Toast(text: "验证码错误").show()
                    SVProgressHUD.showError(withStatus: "验证码错误")
//                    self.error_codeMsg=error.code
//                    if (self.error_codeMsg == 468) {
//                        Toast(text: "验证码错误").show()
//                    }
//                    else if (self.error_codeMsg == 2) {
//                        Toast(text: "此手机已注册").show()
//                    }
//                    else if (self.error_codeMsg == 467) {
//                        Toast(text: "操作频繁，请稍后再试").show()
//                    }
                }
            })
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func setupButtonItem(){
        getCode.backgroundColor = YMGlobalGreenColor()
        setPassBtn.backgroundColor = YMGlobalGreenColor()
    }
    

}
