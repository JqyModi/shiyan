//
//  PaperViewController.swift
//  GST_SY
//
//  Created by mac on 17/7/18.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

//定义一个block
//typealias Push_descriptionCallBack = (_ descStr: String) -> Void
typealias PaperViewControllerCallBack = (_ type: String, _ tag: Int, _ tkAnswer: String, _ paperType: String) -> Void
class PaperViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    //title是系统自带属性不需要重新定义
//    var paperId: String?
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    //点击评论弹出输入框时的遮罩View
    var layView: UIView?
    
    @IBOutlet weak var pImg: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pAnswer: UILabel!
    @IBOutlet weak var pAnswer1: UIButton!
    @IBOutlet weak var pAnswer2: UIButton!
    @IBOutlet weak var pAnswer3: UIButton!
    @IBOutlet weak var pAnswer4: UIButton!
    @IBOutlet weak var pTkAnswer: UITextView!
    @IBOutlet weak var tvPlaceHolder: UILabel!
    
    @IBOutlet weak var imgLayout: NSLayoutConstraint!
    //存储用户答案
    var answer: String?
    var dictAnswer = NSMutableDictionary()
    
    //从1开始计数
    var currentIndex: UInt?
    
    var scollView: UIScrollView?
    //定义变量
    var callback: PaperViewControllerCallBack?
    
    var paper: Paper?
//    var data:Array <Paper> = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalRedColor()
        
        //配置字体样式
        configStyle()
        
        self.initView()
        self.initEvent()
        
        debugPrint("*********************currentIndex = \(self.currentIndex)****************************")
        
    }
    
    func configStyle(){
        self.pTitle.textColor = GSTGlobalFontColor()
        self.pAnswer.textColor = GSTGlobalFontColor()
        self.pTitle.font = UIFont.systemFont(ofSize: GSTGlobalFontMiddleSize())
        self.pAnswer.font = UIFont.systemFont(ofSize: GSTGlobalFontMiddleSize())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.initView()
        
        //当当前题目显示时回填答案
        if self.answer != nil && self.answer != "" {
            debugPrint("详情页当前题目答案为：\(self.answer)")
            //判断时选择还是填空／简答
            if self.answer?.characters.count == 1 {
                self.pAnswer.text? = "答案:(\(self.answer!))"
            }else{
                debugPrint("详情页填空题答案：\(self.answer)")
                //隐藏提示文字
                self.tvPlaceHolder.isHidden = true
                self.pTkAnswer.text = self.answer
            }
            
        }
        
        //为按钮设置Tag／ID
        self.pAnswer1.tag = 1
        self.pAnswer2.tag = 2
        self.pAnswer3.tag = 3
        self.pAnswer4.tag = 4
        
        
        let tkframeY = self.pTkAnswer.frame.maxY
        //隐藏导航栏
        let viewCount = self.view.subviews.count
        debugPrint("子View的个数：\(viewCount)")
        scollView = self.view.subviews[0] as! UIScrollView
        //tkframeY + 50 加上底部tabbar的高度
        scollView?.contentSize = CGSize(width: SCREENW, height: tkframeY + 50)
        //给scrollView添加事件监听
        scollView?.delegate = self
        
        
//        scollView?.setContentOffset(CGPoint(x: 0,y: 1000), animated: true)
    }
    
    func initView(){
        
        if paper!.title != nil && paper!.title != "" {
            self.pTitle.text = "题目：" + String(self.currentIndex! + 1) + "."+paper!.title
            debugPrint("题目：  ->  \(paper?.title)")
        }else{
            self.pTitle.text = "题目："
        }
        if paper!.img != nil && paper!.img != "" {
            self.imgLayout.constant = 180
            var url = HOST + (paper?.img)!
            self.pImg.isHidden = false
            
            url = url.replacingOccurrences(of: "\"", with: "")
            url = url.replacingOccurrences(of: " ", with: "")
            debugPrint("url  --> \(url)")
            self.pImg.kf_setImage(with: URL(string: url))
//            self.pImg.kf_setImageWithURL(URL(string: url))
            
            
        }else{
            self.imgLayout.constant = 0
            self.pImg.isHidden = true
        }
        if paper!.A != nil && paper!.A != "" {
            debugPrint("显示答案label")
            self.pAnswer1.isHidden = false
            self.pAnswer2.isHidden = false
            self.pAnswer3.isHidden = false
            self.pAnswer4.isHidden = false
            self.pAnswer1.setTitle("A. " + paper!.A, for: UIControlState())
            self.pAnswer2.setTitle("B. " + paper!.B, for: UIControlState())
            self.pAnswer3.setTitle("C. " + paper!.C, for: UIControlState())
            self.pAnswer4.setTitle("D. " + paper!.D, for: UIControlState())
        }else{
            //显示填空输入框
            self.pTkAnswer.isHidden = false
            self.pAnswer.text = "答案:"
            //显示提示文字
            self.tvPlaceHolder.isHidden = false
            //设置输入框样式
            //设置边框颜色
            self.pTkAnswer.layer.borderColor = YMGlobalGreenColor().cgColor
            //设置圆角
            self.pTkAnswer.layer.masksToBounds = true
            //设置边框宽度    
            self.pTkAnswer.layer.borderWidth = 2
            //设置圆角半径
            self.pTkAnswer.layer.cornerRadius = 10
            
        }
    }
    func initData(){
        //数据填充
    }
    
    //添加点击事件
    func initEvent(){
        self.pAnswer1.addTarget(self, action: #selector(PaperViewController.clickAnswer(_:)), for: UIControlEvents.touchUpInside)
        self.pAnswer2.addTarget(self, action: #selector(PaperViewController.clickAnswer(_:)), for: UIControlEvents.touchUpInside)
        self.pAnswer3.addTarget(self, action: #selector(PaperViewController.clickAnswer(_:)), for: UIControlEvents.touchUpInside)
        self.pAnswer4.addTarget(self, action: #selector(PaperViewController.clickAnswer(_:)), for: UIControlEvents.touchUpInside)
        
//        self.tvPlaceHolder
        self.pTkAnswer.delegate = self
        
        //注册键盘事件
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        let scrollGesture = UISwipeGestureRecognizer(target: self, action: #selector(PaperViewController.scrollGesture))
        scrollGesture.direction = UISwipeGestureRecognizerDirection.up
        
        self.scollView?.addGestureRecognizer(scrollGesture)
    }
    
    func scrollGesture(){
        debugPrint("上滑手势")
    }
    
    /**
     * 响应键盘事件
     * keyboardWillShowNotification
     */
    func keyboardWillShowNotification(_ notify: Notification){
        
        UIView.animate(withDuration: 0.3, animations: { 
            debugPrint("开始执行动画")
            //将约束设置为-200,则界面会上移，需要将上移过程变慢用以下操作layoutIfNeeded():一帧一帧上移界面：动画
            self.topLayout.constant = -200
            self.view.layoutIfNeeded()
            
            }, completion: { (isComplete) in
                
        }) 
    }
    
    func keyboardWillHideNotification(_ notify: Notification){
        
        UIView.animate(withDuration: 0.3, animations: { 
            debugPrint("开始执行动画")
            //将约束设置为-200,则界面会上移，需要将上移过程变慢用以下操作layoutIfNeeded():一帧一帧上移界面：动画
            self.topLayout.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { (isComplete) in
                
        }) 
        
    }
    
    
    func clickAnswer(_ sender: UIButton){
        //用户点击答案显示到答案标签
        switch sender.tag {
        case 1:
            debugPrint("选择的答案为：A")
            self.pAnswer.text? = "答案:(A)"
            dictAnswer.setValue("A", forKey: "user")
            break
        case 2:
            debugPrint("选择的答案为：B")
            self.pAnswer.text? = "答案:(B)"
            dictAnswer.setValue("B", forKey: "user")
            break
        case 3:
            debugPrint("选择的答案为：C")
            self.pAnswer.text? = "答案:(C)"
            dictAnswer.setValue("C", forKey: "user")
            break
        case 4:
            debugPrint("选择的答案为：D")
            self.pAnswer.text? = "答案:(D)"
            dictAnswer.setValue("D", forKey: "user")
            break
        default:
            debugPrint("")
        }
        //记录选择题答案
        self.dictAnswer.setValue(paper?.type, forKey: "type")
        PaperAnswers.setValue(dictAnswer, forKey: String(self.currentIndex!))
        
    }
    
    //监听输入框变化以显示提示文字
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.tvPlaceHolder.isHidden = false
            self.tvPlaceHolder.text = "  请输入答案以分号(;)分隔每个小空"
        }else{
//            self.tvPlaceHolder.text = ""
            self.tvPlaceHolder.isHidden = true
        }
    }
    //点击键盘上的完成回调
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        debugPrint("textView")
        if text == "\n" {
            debugPrint("shouldChangeTextInRange")
            //取消焦点：键盘隐藏
            self.pTkAnswer.resignFirstResponder()
        }
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDragging")
        self.pTkAnswer.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        debugPrint("页面即将消失的时候保存数据")
        if self.pTkAnswer.text != "" {
            //记录当前试题答案
            self.dictAnswer.setValue(paper?.type, forKey: "type")
            dictAnswer.setValue(self.pTkAnswer.text, forKey: "user")
            PaperAnswers.setValue(dictAnswer, forKey: String(self.currentIndex!))
            
        }
    }
    
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
}
