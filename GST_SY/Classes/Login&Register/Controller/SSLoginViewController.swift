//
//  SSLoginViewController.swift
//  GST_SY
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class SSLoginViewController: YMBaseViewController {

    var loginValidates : Bool?
    
//    private var isDPShow = false
    private var dp: DropDown?
    private var ds: [String]?
    
    var school: [SchoolModel]? {
        didSet {
            ds = getDataSource(schools: school)
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var dropdownBtn: UIButton! {
        didSet {
            dropdownBtn?.addTarget(self, action: "dropDown", for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.addTarget(self, action: "loginBtnDidClick", for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var forgetBtn: UIButton! {
        didSet {
            forgetBtn.addTarget(self, action: "forgetPwdBtnDidClick", for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
    }
    
    private func getDataSource(schools: [SchoolModel]?) -> [String] {
        var ds = [String]()
        if let sm = schools {
            for item in sm {
                ds.append(item.name!)
            }
            return ds
        }
        return ["暂无数据"]
    }
    
    private func setupDropDown() {
        dp = DropDown(anchorView: dropdownBtn)
        dp?.dataSource = ds!
        dp?.reloadAllComponents()
//        dp?.dataSource = ["one", "two", "three", "four", "five", "one", "two", "three", "four", "five", "one", "two", "three", "four", "five", "one", "two", "three", "four", "five", "one", "two", "three", "four", "five", "one", "two", "three", "four", "five"]
        dp?.selectionAction = { (data) in
            //data返回一个元组(index,String)
            debugPrint("data ---> \(data)")
            self.dropdownBtn.setTitle(data.1, for: .normal)
        }
    }
    
    @objc private func dropDown() {
        dp?.show()
    }
    
    // MARK: - 登录操作
    @objc private func loginBtnDidClick() {
        
        let username = usernameTextField.text
        let userpass = passwordTextField.text
        let userpass_md5 = userpass!.md5()
        
        let schoolStr = dropdownBtn.titleLabel?.text
        guard let schoolPy = getSchoolPy(schoolStr: schoolStr!) else {
            SVProgressHUD.showInfo(withStatus: "请先选择学校 ~ ")
            return
        }
        
        debugPrint("userpass_md5:",userpass_md5)
        debugPrint("username:",username)
        debugPrint("schoolPy:",schoolPy)
        if username!.isEmpty{
            SVProgressHUD.showError(withStatus: "账号不能不能为空")
        }
        else if userpass!.isEmpty{
            SVProgressHUD.showError(withStatus: "密码不能为空")
        }
        else{
            YMNetworkTool.shareNetworkTool.loginResult(username!, userpass: userpass_md5, school: schoolPy){[weak self](loginValidate) in
                self?.loginValidates = loginValidate
                
                if (self!.loginValidates == true) {
                    debugPrint("loginValidates:",self!.loginValidates)
                    debugPrint("登录成功")
                    SVProgressHUD.showError(withStatus: "登录成功")
                    let userInfoViewController = UserInfoViewController()
                    userInfoViewController.title="账号信息"
                    userInfoViewController.phoneNum = username
                    //将返回按钮定位到用户设置界面而不是返回登录页
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                else{
                    debugPrint("登录失败")
                    SVProgressHUD.showError(withStatus: "登录失败")
                }
            }
            
        }
    }
    
    private func getSchoolPy(schoolStr: String) -> String? {
        var py: String?
        for item in school! {
            if item.name == schoolStr {
                py = item.pinyin!
            }
        }
        return py
    }
    
    // MARK: - 忘记密码操作
    @objc private func forgetPwdBtnDidClick() {
        let userinfo = SendCodeViewController()
        userinfo.title="忘记密码"
        navigationController?.pushViewController(userinfo, animated: true)
    }
}
