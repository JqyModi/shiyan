//
//  XZView.swift
//  GST_SY
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
import SnapKit

class XZViewController: UIViewController {

    var paper: Paper? {
        didSet {
            fillData()
        }
    }
    
    private func fillData() {
        
        if paper?.img == "" {
            picView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }
        
        subject.text = paper?.title
        
        option1.text = paper?.A
        option2.text = paper?.B
        option3.text = paper?.C
        option4.text = paper?.D
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(subject)
        scrollView.addSubview(picView)
        scrollView.addSubview(answer)
        scrollView.addSubview(option1)
        scrollView.addSubview(option2)
        scrollView.addSubview(option3)
        scrollView.addSubview(option4)
        
        scrollView.addSubview(bottomView)
        
//        view.snp.makeConstraints { (make) in
//            make.left.top.equalTo(0)
//            make.right.equalTo(UIScreen.main.bounds.width)
//            make.bottom.equalTo(UIScreen.main.bounds.height - 49)
//        }
        
        //添加约束
        subject.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
        }
        picView.snp.makeConstraints { (make) in
            make.centerX.equalTo(subject)
            make.top.equalTo(subject.snp.bottom).offset(10)
            make.width.equalTo(230)
            make.height.equalTo(150)
        }
        
        answer.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(8)
            make.top.equalTo(picView.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-8)
            make.height.equalTo(21)
        }
        
        option1.snp.makeConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(answer.snp.bottom).offset(10)
            make.right.equalTo(answer)
        }
        option2.snp.makeConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option1.snp.bottom).offset(10)
            make.right.equalTo(option1)
        }
        option3.snp.makeConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option2.snp.bottom).offset(10)
            make.right.equalTo(option2)
        }
        option4.snp.makeConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option3.snp.bottom).offset(10)
            make.right.equalTo(option3)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(scrollView)
            make.top.equalTo(option4.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.bottom).offset(20)
        }
        
        //设置scrollView的contentSize: 64 + 49 = 导航栏 + 底部toolbar
        debugPrint("scrollView contentSize1 ---> \(scrollView.contentSize)")
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
//        scrollView.isScrollEnabled = true
//        debugPrint("scrollView contentSize2 ---> \(scrollView.contentSize)")
    }
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = UIColor.randomColor
        return s
    }()
    
    lazy var subject: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var picView: UIImageView = {
        let iv = UIImageView()
        iv.sd_cornerRadius = 10
        iv.backgroundColor = UIColor.randomColor
        return iv
    }()
    
    lazy var answer: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.text = "答案：()"
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option1: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14)
        l.sizeToFit()
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option2: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14)
        l.sizeToFit()
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option3: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14)
        l.sizeToFit()
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option4: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14)
        l.sizeToFit()
        l.backgroundColor = UIColor.randomColor
        return l
    }()
    
    lazy var bottomView: UIView = UIView()
}
