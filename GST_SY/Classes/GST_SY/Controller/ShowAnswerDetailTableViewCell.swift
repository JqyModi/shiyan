//
//  ShowAnswerDetailTableViewCell.swift
//  GST_SY
//
//  Created by mac on 17/7/22.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

class ShowAnswerDetailTableViewCell: UITableViewCell {

    //填充数据
    var model: Paper?
    
    
    
    var orgData: Paper?
    //获取到用户填写的答案数据
    var userData: String?
    
    var pTitle: UILabel?
    var pImg: UIImageView?
    var pAnswer: UILabel?
    var pAnswer1: UILabel?
    var pAnswer2: UILabel?
    var pAnswer3: UILabel?
    var pAnswer4: UILabel?
    var pUserAnswer: UILabel?
    var pJiexi: UILabel?
    var pTkAnswer: UILabel?
    var pJx: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configAutoLayout(){
//        self.contentView.backgroundColor = UIColor.grayColor()
//        self.backgroundColor = UIColor.orangeColor()
        initChildView()
        
    }
    
    func initChildView(){
        
        /*
         注意:先把需要自动布局的view加入父view然后在进行自动布局，例：
         
         UIView *view0 = [UIView new];
         UIView *view1 = [UIView new];
         [self.view addSubview:view0];
         [self.view addSubview:view1];
         
         view0.sd_layout
         .leftSpaceToView(self.view, 10)
         .topSpaceToView(self.view, 80)
         .heightIs(100)
         .widthRatioToView(self.view, 0.4);
         
         view1.sd_layout
         .leftSpaceToView(view0, 10)
         .topEqualToView(view0)
         .heightRatioToView(view0, 1)
         .rightSpaceToView(self.view, 10);
         
         
         view2.sd_layout
         .topSpaceToView(_view1, 10)
         .rightSpaceToView(self.contentView, 10)
         .leftEqualToView(_view1)
         .autoHeightRatio(0);
         */
        
        //1.将子View加入父View
        pTitle = UILabel()
        
        pAnswer1 = UILabel()
        pAnswer2 = UILabel()
        pAnswer3 = UILabel()
        pAnswer4 = UILabel()
        
        pAnswer = UILabel()
        
        pUserAnswer = UILabel()
        
        pJx = UILabel()
        
        pJiexi = UILabel()
        pTkAnswer = UILabel()
        
        pImg = UIImageView()
        
        configLabel(pTitle!)
        configLabel(pAnswer1!)
        configLabel(pAnswer2!)
        configLabel(pAnswer3!)
        configLabel(pAnswer4!)
        configLabel(pUserAnswer!)
        configLabel(pJiexi!)
        configLabel(pTkAnswer!)
        
        let contentView = self.contentView
        contentView.addSubview(pTitle!)
        contentView.addSubview(pAnswer1!)
        contentView.addSubview(pAnswer2!)
        contentView.addSubview(pAnswer3!)
        contentView.addSubview(pAnswer4!)
        
        contentView.addSubview(pAnswer!)
        
        contentView.addSubview(pUserAnswer!)
        
        contentView.addSubview(pJx!)
        
        contentView.addSubview(pJiexi!)
        contentView.addSubview(pTkAnswer!)
        contentView.addSubview(pImg!)
        
        let margin: CGFloat = 10
        
        //2.自动布局
        pTitle?.sd_layout()
            .leftSpaceToView(contentView,margin)?
            .rightSpaceToView(contentView,margin)?
            .topSpaceToView(contentView, margin)?
            //高度自适应
            .autoHeightRatio(0)
        
        pImg?.sd_layout()
            .heightIs(150)?
            .widthIs(180)?
            .topSpaceToView(pTitle,margin)?
            .leftSpaceToView(contentView, (contentView.width-180)/2)
        
        pAnswer?.sd_layout()
            .leftEqualToView(pTitle)?
            .topSpaceToView(self.pImg, margin)?
            .widthIs(self.width - margin)?
            .heightIs(21)
        
        pAnswer1?.sd_layout()
            .leftSpaceToView(contentView,2 * margin)?
            .topSpaceToView(self.pAnswer, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
        pAnswer2?.sd_layout()
            .leftEqualToView(pAnswer1)?
            .topSpaceToView(self.pAnswer1, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
        pAnswer3?.sd_layout()
            .leftEqualToView(pAnswer1)?
            .topSpaceToView(self.pAnswer2, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
        pAnswer4?.sd_layout()
            .leftEqualToView(pAnswer1)?
            .topSpaceToView(self.pAnswer3, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
        pUserAnswer?.sd_layout()
            .leftEqualToView(pAnswer)?
            .topSpaceToView(self.pAnswer4, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
        pJx?.sd_layout()
            .leftEqualToView(pAnswer)?
            .topSpaceToView(self.pUserAnswer,margin)?
            .rightSpaceToView(contentView, margin)?
            .heightIs(21)
        
        pJiexi?.sd_layout()
            .leftEqualToView(pAnswer1)?
            .topSpaceToView(self.pJx, margin)?
            .rightSpaceToView(contentView, margin)?
            .autoHeightRatio(0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModelWithPaper(_ model: Paper) {
        //填充数据
        self.model = model
        
        pTitle?.text = model.title
        //显示图片
        var url = (model.img)!
        if url != "" {
            url = HOST + url
            url = url.replacingOccurrences(of: "\"", with: "")
            url = url.replacingOccurrences(of: " ", with: "")
            
//            self.pImg!.kf_setImageWithURL(URL(string: url))
            self.pImg?.kf_setImage(with: URL(string: url))
        }else{
            pImg?.sd_layout().autoHeightRatio(0)
        }
        pAnswer?.text = "答案"
        
        //设置答案的显示隐藏
        if model.A != nil {  //说明该题是选择题
            self.pAnswer1!.isHidden = false
            self.pAnswer2!.isHidden = false
            self.pAnswer3!.isHidden = false
            self.pAnswer4!.isHidden = false
            self.pTkAnswer!.isHidden = true
            
            self.pAnswer1!.text = "A. "+(model.A)!
            self.pAnswer2!.text = "B. "+(model.B)!
            self.pAnswer3!.text = "C. "+(model.C)!
            self.pAnswer4!.text = "D. "+(model.D)!
        }else{  //设置填空题答案
            
            self.pTkAnswer!.isHidden = false
            self.pAnswer1!.isHidden = true
            self.pAnswer2!.isHidden = true
            self.pAnswer3!.isHidden = true
            self.pAnswer4!.isHidden = true
            
            self.pTkAnswer!.text = self.model?.right
        }
        //显示用户选择的答案
        self.pUserAnswer!.text = "您的答案：" + (model.userRight)!
        
        pJx?.text = "解析:"
        
        //显示解析
        self.pJiexi!.text = self.model?.jiexi.replacingOccurrences(of: "解析:", with: "")
        self.pJiexi!.text = self.model?.jiexi.replacingOccurrences(of: "解析：", with: "")
        self.pJiexi!.text = self.model?.jiexi.replacingOccurrences(of: "【分析】", with: "")
        
        self.setupAutoHeight(withBottomView: self.pJiexi, bottomMargin: 30)
        
    }
    
    func configLabel(_ label: UILabel){
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = UIColor.gray
    }
    
    /*
    func configStyle(){
        self.contentView.layer.borderColor = UIColor.clearColor().CGColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).CGPath
        
        self.lbCell.textColor = GSTGlobalFontColor()
        self.lbCell.font = UIFont.systemFontOfSize(GSTGlobalFontSmallSize())
    }
    
    //重写frame属性而不是方法
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10/2
            newFrame.size.width -= 10
            newFrame.origin.y += 1
            newFrame.size.height -= 1
            super.frame = newFrame
        }
    }
     */
}
