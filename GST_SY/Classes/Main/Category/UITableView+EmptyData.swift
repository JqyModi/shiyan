//
//  UITableView+EmptyData.swift
//  GST_SY
//

import UIKit

public extension UITableView {
    func tableView(_ message: String, image: String, cellCount: Int) {
        if cellCount == 0 {
            
            let button = YMVerticalButton()
            button.setTitleColor(YMColor(200, g: 200, b: 200, a: 1.0), for: UIControlState())
            button.setTitle(message, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setImage(UIImage(named: image), for: UIControlState())
            button.addTarget(self, action: #selector(emptyButtonClick), for: .touchUpInside)
            button.imageView?.sizeToFit()
            backgroundView = button
            separatorStyle = .none
        } else {
            backgroundView = nil
            separatorStyle = .singleLine
        }
    }
    
    func emptyButtonClick() {
        print("---")
    }
}
