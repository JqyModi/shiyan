//
//  KaoPingDetailViewController.swift
//  GST_SY
//
//  Created by mac on 17/7/17.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import CKViewPager
//import JLToast
import Toaster
import SwiftyJSON

protocol KaoPingDetailViewControllerDelegate {
    func didChangeTabToIndex(didChangeTabToIndex index: UInt)
}

class KaoPingDetailViewController: ViewPagerController, ViewPagerDelegate, ViewPagerDataSource, UITabBarDelegate {

    //title是系统自带属性不需要重新定义
    var paperId: String?
    var paperName: String?
    
    //定义变量
    var time: String?
    //存储用户选择的答案
//    var answers: NSDictionary?
//    var answers = NSMutableArray()
    var answers = NSMutableDictionary()
    //从0开始计数
    var currentIndex: UInt = 0
    var papers = [Paper]()
    var data:Array <Paper> = []
    
    var paperVC: PaperViewController?
    var item2: UITabBarItem?
    var delegate1: KaoPingDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YMGlobalColor()
        
        self.dataSource = self
        self.delegate = self
        
        //获取试卷列表：http://shiyan360.cn/index.php/api/examinPaperDetail?id=1
        //id 试卷ID
        
        YMNetworkTool.shareNetworkTool.getPaper(paperId!){ [weak self](items) in
            self?.papers=items
            self!.data = self!.papers
            print("papers.count  = \(self!.papers.count)")
            if items.count>0 {
                print("题目条数：\(items.count)")
                self?.reloadData()
            }else{
                print("暂无内容")
                Toast(text: "服务器数据异常，请稍后再试").show()
                //禁止操作
                self!.view.isUserInteractionEnabled = false
                return
            }
            
        }
        
        //清空数据
        if PaperAnswers.count>0 {
            PaperAnswers.removeAllObjects()
        }
        
        self.initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.answers.removeAllObjects()
    }
    
    func initView(){
        //隐藏指示器及布局
        self.indicatorHeight = 0
        self.tabHeight = 0

//        let view = UIView(frame: CGRectMake(0,SCREENH - 100,SCREENW,100))
//        view.backgroundColor = UIColor.greenColor()
//        self.view.addSubview(view)
        
        let tabbar = UITabBar(frame: CGRect(x: 0,y: SCREENH - 50 + 1,width: SCREENW,height: 50))
        //设置Tabbar颜色
        tabbar.backgroundColor = UIColor.white
        let item1 = UITabBarItem(title: "上一题", image: UIImage(named: "pre"), tag: 0)
        item2 = UITabBarItem(title: "提交", image: UIImage(named: "submit"), tag: 1)
//        item2.accessibilityElementsHidden = true
        item2!.isEnabled = false
        let item3 = UITabBarItem(title: "下一题", image: UIImage(named: "next"), tag: 2)
        let items = [item1,item2!,item3]
        tabbar.setItems(items, animated: true)
        tabbar.delegate = self
        self.view.addSubview(tabbar)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("上一题")
            //上一题操作
            if self.currentIndex == 0 {
                Toast(text: "已经是第一题了").show()
            }else{
                self.selectTab(at: self.currentIndex-1)
            }
            break
        case 1:
            print("提交")
            //添加最后一题答案进入答案集合
            if self.paperVC?.pTkAnswer.text != "" {
                //记录当前试题答案
                self.paperVC?.dictAnswer.setValue(self.paperVC?.paper?.type, forKey: "type")
                self.paperVC?.dictAnswer.setValue(self.paperVC?.pTkAnswer.text, forKey: "user")
                let key = "\(Int((self.paperVC?.currentIndex)!))"
                PaperAnswers.setValue(self.paperVC?.dictAnswer, forKey: key)
            }
            
            if PaperAnswers.count>0 && PaperAnswers.count == papers.count {
                print("数据保存成功")
                //跳转到答案显示详情页
                let showAnswerDetailVC = ShowAnswerDetailViewController()
                showAnswerDetailVC.title = "试题解析"
                //传递数据到详情页
                showAnswerDetailVC.data = self.data
                showAnswerDetailVC.answers = self.answers
                showAnswerDetailVC.paperId = self.paperId
                showAnswerDetailVC.paperName = self.paperName
                self.navigationController?.pushViewController(showAnswerDetailVC, animated: true)
            }
            break
        case 2:
            print("下一题")
            //下一题操作
            if self.currentIndex == UInt(self.data.count-1) {
                Toast(text: "没有更多题目了").show()
            }else{
                self.selectTab(at: self.currentIndex+1)
            }
            break
        default:
            break
        }
    }
    
    func numberOfTabs(forViewPager viewPager: ViewPagerController!) -> UInt {
        return UInt(self.data.count)
    }
    func viewPager(_ viewPager: ViewPagerController!, contentViewControllerForTabAt index: UInt) -> UIViewController! {
        print("contentViewControllerForTabAtIndex  =  \(index)")
        
        //是否显示提交按钮
        if PaperAnswers.count >= data.count - 2 {
//            item2.accessibilityElementsHidden = false
            item2!.isEnabled = true
        }else{
            item2!.isEnabled = false
        }
        
        /*
        paperVC = PaperViewController()
        let paper = self.data[Int(index)]
        paperVC!.paper = paper
        paperVC?.currentIndex = index
        if PaperAnswers.count>0 && self.currentIndex > 0 {
            var key = ""
            if index < self.currentIndex {
                key = String(self.currentIndex-1)
            }
            if index > self.currentIndex {
                key = String(self.currentIndex+1)
            }
            let answer = (PaperAnswers.value(forKey: key) as AnyObject).value(forKey: "user")
            if answer != nil {
                paperVC!.answer = (answer as AnyObject).description!
                print("当前题目答案为: \(answer)")
            }
            
        }
        return paperVC
        */
        
        let vc = XZViewController()
        let paper = self.data[Int(index)]
        vc.paper = paper
        return vc
    }
    func viewPager(_ viewPager: ViewPagerController!, didChangeTabTo index: UInt) {
        print("didChangeTabToIndex  =  \(index)")
        self.currentIndex = index
        
    }
    
    func viewPager(_ viewPager: ViewPagerController!, viewForTabAt index: UInt) -> UIView! {
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
