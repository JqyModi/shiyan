//
//  YMSeeMoreController.swift
//  GST_SY
//

import UIKit

let seeAllcellID = "YMSeeAllTopicCell"

class YMSeeAllController: YMBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var collections = [YMCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: String(describing: YMSeeAllTopicCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: seeAllcellID)
        tableView.separatorStyle = .none
        tableView.rowHeight = 160
        YMNetworkTool.shareNetworkTool.loadCategoryCollection(20) { (collections) in
            self.collections = collections
            self.tableView!.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMSeeAllController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: seeAllcellID) as! YMSeeAllTopicCell
        cell.collection = collections[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionDetailVC = YMCollectionDetailController()
        let collection = collections[indexPath.row]
        collectionDetailVC.title = collection.title
        collectionDetailVC.id = collection.id
        collectionDetailVC.type = "专题合集"
        navigationController?.pushViewController(collectionDetailVC, animated: true)
    }
}
