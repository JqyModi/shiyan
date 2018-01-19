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

class KPViewController: TabmanViewController, PageboyViewControllerDataSource {

//    var viewControllers: [UIViewController]?
    private var viewControllers = [UIViewController]()
    
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
        view.backgroundColor = UIColor.init(white: 0.96, alpha: 1.0)
        self.dataSource = self
        
        // bar customisation
        bar.location = .top
        //        bar.style = .custom(type: CustomTabmanBar.self) // uncomment to use CustomTabmanBar as style.
//        bar.appearance = PresetAppearanceConfigs.forStyle(self.bar.style, currentAppearance: self.bar.appearance)
    }
    
    private func initializeViewControllers(papers: [Paper]) {
        var viewControllers = [UIViewController]()
        var barItems = [Item]()
        
        for index in 0 ..< papers.count {
            let viewController = ExaminationViewController()
            viewController.paper = papers[index]
//            viewController.index = index + 1
            barItems.append(Item(title: "Page No. \(index + 1)"))
//            let viewController = UIViewController()
//            viewController.view.backgroundColor = UIColor.randomColor
//            barItems.append(Item(title: "Page No. \(index + 1)"))
            viewControllers.append(viewController)
        }
        
        bar.items = barItems
        self.viewControllers = viewControllers
    }
    
    private func loadData() {
        YMNetworkTool.shareNetworkTool.getPaper(paperId!){ [weak self](items) in
            self?.papers = items
            self?.initializeViewControllers(papers: (self?.papers)!)
            print("papers.count  = \(self!.papers.count)")
            if items.count>0 {
                print("题目条数：\(items.count)")
            }else{
                print("暂无内容")
//                Toast(text: "服务器数据异常，请稍后再试").show()
            }
            
        }
    }

    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        
        return self.viewControllers.count ?? 0
//        return self.papers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
//                let vc = ExaminationViewController()
//                vc.paper = papers[index]
//                return vc
        
        return self.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension KPViewController {

}
