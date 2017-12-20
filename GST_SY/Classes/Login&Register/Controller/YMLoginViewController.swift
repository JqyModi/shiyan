//
//  YMLoginViewController.swift
//  GST_SY
//

import UIKit
//import MD5
//import JLToast
import CryptoSwift
import Toaster
import SVProgressHUD

class YMLoginViewController: YMBaseViewController {
 
    /**
      * 声明变量时的？只是单纯的告诉Swift这是Optional的，如果没有初始化就默认为nil，
      * 而通过！声明，则之后对该变量操作的时候都会隐式的在操作前添加一个！
      *
      */
    @IBOutlet weak var mobileField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
  
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var forgetPwdBtn: UIButton!
    var loginValidates : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupBarButtonItem()
        
        setupLoginButtonItem()

    }
    
    @IBAction func forgetPwdBtnClick(_ sender: UIButton) {
        let userinfo = SendCodeViewController()
        userinfo.title="忘记密码"
        navigationController?.pushViewController(userinfo, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        
        let username=mobileField.text
        let userpass = passwordField.text
        let userpass_md5 = userpass!.md5()
        print("userpass_md5:",userpass_md5)
        print("username:",username)
//        if !YMIstelphnum.init().isTelNumber(username! as NSString) {
////            Toast(text: "手机号码输入有误").show()
//            SVProgressHUD.showError(withStatus: "手机号码输入有误")
//        }
        if username!.isEmpty{
            SVProgressHUD.showError(withStatus: "账号不能为空")
        }
        else if userpass!.isEmpty{
            SVProgressHUD.showError(withStatus: "密码不能为空")
        }
        else{
        YMNetworkTool.shareNetworkTool.loginResult(username!, userpass: userpass_md5){[weak self](loginValidate) in
            self?.loginValidates=loginValidate
            
            if (self!.loginValidates == true) {
                print("loginValidates:",self!.loginValidates)
                print("登录成功")
                SVProgressHUD.showError(withStatus: "登录成功")
                let userInfoViewController = UserInfoViewController()
                userInfoViewController.title="账号信息"
                userInfoViewController.phoneNum = username
                //将返回按钮定位到用户设置界面而不是返回登录页
                self?.navigationController?.popToRootViewController(animated: true)
                
            }
            else{
                print("登录失败")
                SVProgressHUD.showError(withStatus: "登录失败")
            }
        }
            
        }
    }
    
    @IBAction func presentSSLogin() {
        //跳转到师生登录界面
        let ssVC = SSLoginViewController()
        let data = YMNetworkTool.shareNetworkTool.getSchoolList { (schools) in
            if schools != nil {
                ssVC.school = schools
                ssVC.title = "师生登录"
                ssVC.loginValidates = self.loginValidates
                self.navigationController?.pushViewController(ssVC, animated: true)
            }
        }
    }
    
    fileprivate func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(regiisterButtonClick))
    }
    
    fileprivate func setupLoginButtonItem(){
        loginButton.backgroundColor = YMGlobalGreenColor()
    }    
  
    func regiisterButtonClick() {
        let registerVC = YMRegisterViewController()
        registerVC.title = "注册"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func otherLoginButtonClick(_ sender: UIButton) {
        if let buttonType = YMOtherLoginButtonType(rawValue: sender.tag) {
            switch buttonType {
            case .weiboLogin:
                
                break
            case .weChatLogin:
                
                break
            case .qqLogin:
                
                break
            }
        }
    }
    
}
