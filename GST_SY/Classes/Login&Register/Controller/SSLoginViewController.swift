//
//  SSLoginViewController.swift
//  GST_SY
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import DropDown

class SSLoginViewController: YMLoginViewController {

    private var isDPShow = false
    private var dp: DropDown?
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var dropdownBtn: UIButton! {
        didSet {
            dropdownBtn?.addTarget(self, action: "dropDown", for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var forgetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
    }
    
    private func setupDropDown() {
        dp = DropDown(anchorView: dropdownBtn)
        dp.dataSource = ["one", "two", "three", "four", "five"]
        
    }
    
    private func dropDown() {
        isDPShow ? dp?.show() : dp?.hide()
    }
}
