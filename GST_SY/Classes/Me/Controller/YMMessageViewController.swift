//
//  YMMessageViewController.swift
//  GST_SY
//
//

import UIKit


class YMMessageViewController: YMBaseViewController {
    
    var babyImage = ["course1.png","course2.png","course3.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    

    fileprivate func setupTableView() {
        let tableView = UITableView()
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: messageCellID)
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension YMMessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID)
        cell?.textLabel?.text = "消息---" + String(indexPath.row)
        cell?.imageView?.image=UIImage(named: babyImage[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
