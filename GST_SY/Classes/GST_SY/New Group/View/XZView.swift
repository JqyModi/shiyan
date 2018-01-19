//
//  XZView.swift
//  GST_SY
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class XZViewController: UIViewController {

    var paper: Paper? {
        didSet {
            fillData()
        }
    }
    
    private func fillData() {
        subject.text = "题目：" + (paper?.title)!
        
        if paper?.img == "" {
            hiddenPic()
        }else {
//            showPic()
            //显示图片
            let url = handleURLWithImage(str: (paper?.img)!)
            picView.sd_setImage(with: url, completed: nil)
        }
        
        //判断是否是选择题
        if paper?.type == "xz" {
            hiddenBlank()
//            showOption()
            option1.text = "A." + (paper?.A)!
            option2.text = "B." + (paper?.B)!
            option3.text = "C." + (paper?.C)!
            option4.text = "D." + (paper?.D)!
        }else {
            //不用隐藏选项：因为自动计算高度所有不填内容高度自然为0
//            hiddenOption()
//            showBlank()
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //运行时设置UITextView提示文本控件
        fillBlank.setValue(placeHolderLabel, forKeyPath: "_placeholderLabel")
    }
    
    private func handleURLWithImage(str: String) -> URL {
        var urlStr = HOST + str
        urlStr = urlStr.replacingOccurrences(of: "\"", with: "")
        urlStr = urlStr.replacingOccurrences(of: " ", with: "")
//        debugPrint("url2  ----> \(urlStr)")
        return URL(string: urlStr)!
    }
    
    private func showOption() {
        option1.snp.updateConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(answer.snp.bottom).offset(10)
            make.right.equalTo(answer)
        }
        option2.snp.updateConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option1.snp.bottom).offset(10)
            make.right.equalTo(option1)
        }
        option3.snp.updateConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option2.snp.bottom).offset(10)
            make.right.equalTo(option2)
        }
        option4.snp.updateConstraints { (make) in
            make.left.equalTo(answer).offset(20)
            make.top.equalTo(option3.snp.bottom).offset(10)
            make.right.equalTo(option3)
        }
    }
    
    private func hiddenOption() {
        option1.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        option2.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        option3.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        option4.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
    
    private func hiddenBlank() {
        fillBlank.snp.updateConstraints({ (make) in
            make.height.equalTo(0)
        })
    }
    
    private func showBlank() {
        fillBlank.snp.updateConstraints({ (make) in
            make.top.equalTo(option4.snp.bottom).offset(20)
            make.left.equalTo(option4)
            make.right.equalTo(option4).offset(-10)
            make.height.equalTo(42)
        })
    }
    
    private func hiddenPic() {
        picView.snp.updateConstraints({ (make) in
            make.height.equalTo(0)
        })
    }
    
    private func showPic() {
        picView.snp.updateConstraints({ (make) in
            make.centerX.equalTo(subject)
            make.top.equalTo(subject.snp.bottom).offset(10)
            make.width.equalTo(230)
            make.height.equalTo(150)
        })
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(subject)
        containerView.addSubview(picView)
        containerView.addSubview(answer)
        containerView.addSubview(option1)
        containerView.addSubview(option2)
        containerView.addSubview(option3)
        containerView.addSubview(option4)
        
        //加入提示文本
        fillBlank.addSubview(placeHolderLabel)
        containerView.addSubview(fillBlank)
        
        containerView.addSubview(bottomView)
        
        //添加约束
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        subject.snp.makeConstraints { (make) in
            make.top.left.equalTo(containerView).offset(8)
            make.right.equalTo(containerView).offset(-8)
        }
        picView.snp.makeConstraints { (make) in
            make.centerX.equalTo(subject)
            make.top.equalTo(subject.snp.bottom).offset(10)
            make.width.equalTo(230)
            make.height.equalTo(150)
        }
        
        answer.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(8)
            make.top.equalTo(picView.snp.bottom).offset(10)
            make.right.equalTo(containerView).offset(-8)
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
        
        fillBlank.snp.makeConstraints { (make) in
            make.top.equalTo(option4.snp.bottom).offset(20)
            make.left.equalTo(option4)
            make.right.equalTo(option4).offset(-10)
            make.height.equalTo(66)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView)
            make.top.equalTo(fillBlank.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        //设置scrollView的contentSize: 64 + 49 = 导航栏 + 底部toolbar
        //自动布局设置frame无效：需要给ScrollView添加约束来自动计算ContentSize
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
            make.bottom.equalTo(bottomView.snp.bottom).offset(49)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
//        s.backgroundColor = UIColor.randomColor
        s.backgroundColor = UIColor.init(white: 0.92, alpha: 1.0)
        return s
    }()
    
    lazy var subject: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 18)
        l.sizeToFit()
//        l.backgroundColor = UIColor.randomColor
        l.textColor = UIColor.brown
        return l
    }()
    lazy var picView: UIImageView = {
        let iv = UIImageView()
        //圆角半径
        iv.layer.cornerRadius = 10
        //允许裁剪
        iv.clipsToBounds = true
        
        iv.layer.borderColor = UIColor.randomColor.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    lazy var answer: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 18)
        l.sizeToFit()
        l.text = "答案：()"
//        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option1: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
//        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option2: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
//        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option3: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
//        l.backgroundColor = UIColor.randomColor
        return l
    }()
    lazy var option4: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
//        l.backgroundColor = UIColor.randomColor
        return l
    }()
    
    lazy var fillBlank: UITextView = {
        let tv = UITextView()
//        tv.backgroundColor = UIColor.randomColor
        //设置替换文字
//        tv.placeholder = "请输入答案，如有多个空格请用分号隔开 ~ "
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.randomColor.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    //懒加载一个：替换文本: _placeholderLabel：UITextView运行时的一个属性
    lazy var placeHolderLabel: UILabel = {
        let l = UILabel()
        l.text = "请输入答案，如有多个空格请用分号隔开 ~ "
        l.numberOfLines = 0
        l.textColor = UIColor.randomColor
        l.sizeToFit()
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    lazy var bottomView: UIView = {
        let v = UIView()
//        v.backgroundColor = UIColor.randomColor
        return v
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
}
