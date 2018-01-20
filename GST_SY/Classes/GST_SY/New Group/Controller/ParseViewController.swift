//
//  ParseViewController.swift
//  GST_SY
//
//  Created by mac on 2018/1/20.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit

class ParseTableViewCell: UITableViewCell {
    
    var index: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //设置选中状态
        selectionStyle = .none
        
        //布局
        setupUI()
        //事件
        setupEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var paper: Paper? {
        didSet {
            fillData()
        }
    }
    //将当前试题题目作为Key保存答案
    var key = ""
    
    private func fillData() {
        
        key = (paper?.title.md5())!
        debugPrint("key ----->>>  \(key)")
        
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
            //            showOption()
            option1.text = "A." + (paper?.A)!
            option2.text = "B." + (paper?.B)!
            option3.text = "C." + (paper?.C)!
            option4.text = "D." + (paper?.D)!
        }
        //获取用户答案
        let answer = PaperAnswers[key] as? String ?? "没有作答 ~"
        //显示用户答案
        userAnswer.text = answer
        
        //显示解析
        parse.text = paper?.jiexi ?? "暂无解析 ~"
    }
    
    private func setupEvent() {
    
    }
    
    private func handleURLWithImage(str: String) -> URL {
        var urlStr = HOST + str
        urlStr = urlStr.replacingOccurrences(of: "\"", with: "")
        urlStr = urlStr.replacingOccurrences(of: " ", with: "")
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
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(subject)
        containerView.addSubview(picView)
        containerView.addSubview(answer)
        containerView.addSubview(option1)
        containerView.addSubview(option2)
        containerView.addSubview(option3)
        containerView.addSubview(option4)
        containerView.addSubview(userAnswerTip)
        containerView.addSubview(userAnswer)
        containerView.addSubview(parseTip)
        containerView.addSubview(parse)
        containerView.addSubview(bottomView)
        
        //添加约束
        containerView.snp.updateConstraints { (make) in
            make.edges.equalTo(contentView)
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
        userAnswerTip.snp.makeConstraints { (make) in
            make.left.equalTo(answer)
            make.top.equalTo(option4.snp.bottom).offset(10)
            make.right.equalTo(answer)
        }
        userAnswer.snp.makeConstraints { (make) in
            make.left.equalTo(option4)
            make.top.equalTo(userAnswerTip.snp.bottom).offset(10)
            make.right.equalTo(option4)
        }
        parseTip.snp.makeConstraints { (make) in
            make.left.equalTo(answer)
            make.top.equalTo(userAnswer.snp.bottom).offset(10)
            make.right.equalTo(answer)
        }
        parse.snp.makeConstraints { (make) in
            make.left.equalTo(option4)
            make.top.equalTo(parseTip.snp.bottom).offset(10)
            make.right.equalTo(option4)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView)
            make.top.equalTo(parse.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.bottom.equalTo(containerView)
        }
    }
    
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
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var option2: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
        //        l.backgroundColor = UIColor.randomColor
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var option3: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
        //        l.backgroundColor = UIColor.randomColor
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var option4: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.brown
        //        l.backgroundColor = UIColor.randomColor
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var userAnswerTip: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 18)
        l.sizeToFit()
        l.text = "您的答案："
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var userAnswer: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.purple
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var parseTip: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 18)
        l.sizeToFit()
        l.text = "解析："
        l.isUserInteractionEnabled = true
        return l
    }()
    lazy var parse: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16)
        l.sizeToFit()
        l.textColor = UIColor.red
        l.isUserInteractionEnabled = true
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
