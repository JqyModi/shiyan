//
//  KPViewController.swift
//  GST_SY
//
//  Created by mac on 2018/1/19.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import SnapKit
import Toaster

class KPViewController: TabmanViewController {

    var viewControllers = [UIViewController]()
    
    //title是系统自带属性不需要重新定义
    var paperId: String?
    var paperName: String?
    
    var papers: [Paper] = [Paper]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.96, alpha: 1.0)
        
        view.addSubview(tabBar)
        
        //添加约束
        tabBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(50)
        }
    }
    
    private func initializeViewControllers(papers: [Paper]) {
        var viewControllers = [UIViewController]()
        var barItems = [Item]()
        for index in 0 ..< papers.count {
            let viewController = ExaminationViewController()
            viewController.paper = papers[index]
            viewController.index = index + 1
            barItems.append(Item(title: "Page No. \(index + 1)"))
            viewControllers.append(viewController)
        }
        //不添加页码显示
//        bar.items = barItems
//        bar.style = .scrollingButtonBar
        self.viewControllers = viewControllers
    }
    
    private func loadData() {
        YMNetworkTool.shareNetworkTool.getPaper(paperId!){ [weak self](items) in
            self?.papers = items
            self?.initializeViewControllers(papers: (self?.papers)!)
            //重新加载数据
            self?.reloadPages()
        }
    }
    
    //懒加载一个UITabBar
    lazy var tabBar: UITabBar = {
        let tabbar = UITabBar()
        //设置Tabbar颜色
        tabbar.backgroundColor = UIColor.white
        let item1 = UITabBarItem(title: "上一题", image: UIImage(named: "pre"), tag: 0)
        let item2 = UITabBarItem(title: "提交", image: UIImage(named: "submit"), tag: 1)
        item2.isEnabled = false
        let item3 = UITabBarItem(title: "下一题", image: UIImage(named: "next"), tag: 2)
        let items = [item1,item2,item3]
        tabbar.setItems(items, animated: true)
        tabbar.delegate = self
        return tabbar
    }()

}

extension KPViewController: PageboyViewControllerDataSource, UITabBarDelegate {
    
    //MARK: -PageboyViewControllerDataSource
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        //一开始进来没有数据：异步加载数据：数据加载完成重新刷新数据
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
//        let vc = ExaminationViewController()
//        vc.paper = self.papers[index]
//        return vc
        if PaperAnswers.count == papers.count || papers.count == 1 {
            let submitItem = tabBar.items![1]
            debugPrint("显示提交按钮")
            submitItem.isEnabled = true
        }
        return self.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    //MARK: -UITabBarDelegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            debugPrint("上一题")
            //上一题操作
            if self.currentIndex == 0 {
                Toast(text: "已经是第一题了").show()
            }else{
                scrollToPage(PageboyViewController.Page.previous, animated: true)
            }
            break
        case 1:
            debugPrint("提交")
            //跳转到答案显示详情页
//            let showAnswer = ShowAnswerDetailViewController()
//            showAnswer.title = "试题解析"
//            //传递数据到详情页
//            showAnswer.data = self.papers
//            showAnswer.paperId = self.paperId
//            showAnswer.paperName = self.paperName
            
            let parseVC = ParseTableViewController()
            parseVC.papers = papers
            parseVC.title = "试题解析"
            self.navigationController?.pushViewController(parseVC, animated: true)
            break
        case 2:
            debugPrint("下一题")
            //下一题操作
            if self.currentIndex == viewControllers.count - 1 {
                Toast(text: "没有更多题目了").show()
            }else{
                scrollToPage(PageboyViewController.Page.next, animated: true)
            }
            break
        default:
            break
        }
    }
    
}
