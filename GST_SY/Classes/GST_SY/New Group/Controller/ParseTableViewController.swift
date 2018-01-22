//
//  ShowAnswerTableViewController.swift
//  GST_SY
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
private let reuseIdentifier = "reuseIdentifier"
class ParseTableViewController: UITableViewController {
    
    var papers = [Paper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
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
        return papers.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ParseTableViewCell

        // Configure the cell...
        cell?.paper = papers[indexPath.row]

        return cell!
    }

}
