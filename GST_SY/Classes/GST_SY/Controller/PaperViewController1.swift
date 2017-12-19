//
//  PaperViewController1.swift
//  GST_SY
//
//  Created by mac on 17/7/19.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
//已过时
class PaperViewController1: UIViewController {
    //定义用到的控件
    var pImg: UIImageView!
    var pTitle: UILabel!
    var pAnswer: UILabel!
    var pAnswer1: UIButton!
    var pAnswer2: UIButton!
    var pAnswer3: UIButton!
    var pAnswer4: UIButton!
    var pTkAnswer: UITextView!
    
    var scrollView: UIScrollView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initView(){
        self.view.backgroundColor = UIColor.gray
        
        //初始化一个UIScrollView
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: SCREENW,height: SCREENH))
        
        pImg = UIImageView(frame: CGRect(x: 8,y: 126,width: SCREENW-16,height: 200))
        pTitle = UILabel(frame: CGRect(x: 8,y: 30,width: SCREENW-16,height: 84))
        pAnswer = UILabel(frame: CGRect(x: 8,y: 334,width: SCREENW-16,height: 21))
        pAnswer1 = UIButton(frame: CGRect(x: 8,y: 363,width: SCREENW-16,height: 21))
        pAnswer2 = UIButton(frame: CGRect(x: 8,y: 392,width: SCREENW-16,height: 21))
        pAnswer3 = UIButton(frame: CGRect(x: 8,y: 421,width: SCREENW-16,height: 21))
        pAnswer4 = UIButton(frame: CGRect(x: 8,y: 450,width: SCREENW-16,height: 21))
        pTkAnswer = UITextView(frame: CGRect(x: 8,y: 363,width: SCREENW-16,height: 144))
//        pTkAnswer = UITextView(frame: CGRectMake(8,700,SCREENW-16,144))
        
        scrollView.addSubview(pImg)
        scrollView.addSubview(pTitle)
        scrollView.addSubview(pAnswer)
        scrollView.addSubview(pAnswer1)
        scrollView.addSubview(pAnswer2)
        scrollView.addSubview(pAnswer3)
        scrollView.addSubview(pAnswer4)
        scrollView.addSubview(pTkAnswer)
        
        //设置UIScrollView滚动条件是：contentSize的宽高大于frame的宽高时才能滚动
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: SCREENW, height: 1200)
        self.view.addSubview(scrollView)
        
        //模拟数据
        pImg.image = UIImage(named: "course1")
//        pTitle.text = "题目："
        pTitle.text = "天平的正确使用方法：一放：将托盘天平放置在水平桌面上，将游码拨至标尺左端零刻度线上；\r\n二调：调节横梁左右两端的平衡螺母，使横梁平衡，此时指针恰好指在分度盘的中央或左右摆幅度相等；\r\n三称：左物右码，用镊子向右盘中加减砝码，当加最小砝码横梁还不平衡时，调节游码在标尺上的位置，使天平再次平衡；\r\n四记：物体的质量等于右盘中砝码的质量与标尺上游码所对应的刻度值之和。\r\n\r\n天平应放在水平桌面上；\r\n游码应拨至标尺左端零刻度线上；\r\n指针出现了如图所示的现象，说明天平栋梁左边重，左偏右调；\r\n如果物体与砝码位置放反了，最后记数时物体的质量等于左盘中砝码的质量与标尺上游码所对应的刻度值之差，即：m=50g-2.4g=47.6g\r\n标尺上的分度值为0.2g．\r\n答案：水平；零刻度；右；47.6g"
//        pTitle.adjustsFontSizeToFitWidth = true
//        pTitle.contentMode = .ScaleToFill
        pTitle.contentMode = .left
        pTitle.textAlignment = .left
        pTitle.adjustsFontSizeToFitWidth = true
        pTitle.numberOfLines = 10
        
        pAnswer.text = "答案："
        pAnswer1.contentMode = .left
        pAnswer2.contentMode = .left
        pAnswer3.contentMode = .left
        pAnswer4.contentMode = .left
        pAnswer1.setTitle("A. ", for: UIControlState())
        pAnswer2.setTitle("B. ", for: UIControlState())
        pAnswer3.setTitle("C. ", for: UIControlState())
        pAnswer4.setTitle("D. ", for: UIControlState())
        
    }

}
