//
//  ShowAnswerTableViewController.swift
//  GST_SY
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "reuseIdentifier"

class ParseTableViewController: UITableViewController {
    
    var papers = [Paper]()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //重写返回操作
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ParseTableViewController.back))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        //提交答案
        submitDataToServer()
        
    }
    
    @objc private func back() {
        debugPrint(#function)
        //跳转到指定vc 不在返回答题界面
        let vcArry = self.navigationController?.viewControllers
        let vc = vcArry![(vcArry?.count)!-3]
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    func submitDataToServer(){
        let submitData = NSMutableDictionary()
        let xcontent = NSMutableDictionary()
        let tcontent = NSMutableDictionary()
        let jcontent = NSMutableDictionary()
        //封装需要提交到服务器的数据
        let defaults : UserDefaults = UserDefaults.standard
        let sid = defaults.value(forKey: "userId")
        
        submitData["hour"] = "0"
        submitData["minute"] = "10"
        submitData["cp_id"] = PaperAnswers["paperId"]
        submitData["sid"] = sid
        submitData["title"] = PaperAnswers["paperName"]
        var x = 1, t = 1, j = 1
        for (paper) in papers {
            let key = paper.title.md5()
            let dictTemp = NSMutableDictionary()
            dictTemp["user"] = PaperAnswers[key]
            
            switch paper.type {
            case "xz":
                xcontent["\(x)"] = dictTemp
                x = x + 1
            case "tk":
                tcontent["\(t)"] = dictTemp
                t = t + 1
            case "jd":
                jcontent["\(j)"] = dictTemp
                j = j + 1
            default:
                break
            }
        }
        
        submitData["xcontent"] = xcontent
        submitData["tcontent"] = tcontent
        submitData["jcontent"] = jcontent
        
        let json = JSON(submitData)
        let str = json.description
        debugPrint("提交到服务器的数据：str = \(str)")
        
        YMNetworkTool.shareNetworkTool.submitAnswer(str)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.init(white: 0.96, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.red
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        tableView.register(ParseTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //设置行高
        tableView.rowHeight = 400
        
        //设置分割线
        tableView.separatorStyle = .none
        
        //自动计算行高：Cell自动布局1
        //1.设置估计值
        tableView.estimatedRowHeight = tableView.rowHeight
        //2.设置自动计算
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //添加约束
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return papers.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ParseTableViewCell

        // Configure the cell...
        cell?.paper = papers[indexPath.row]

        return cell!
    }

}
