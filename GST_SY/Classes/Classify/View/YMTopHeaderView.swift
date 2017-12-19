//
//  YMTopHeaderView.swift
//  GST_SY
//
//

import UIKit

protocol YMTopHeaderViewDelegate: NSObjectProtocol {
    func topViewDidClickedMoreButton(_ button: UIButton)
}

class YMTopHeaderView: UIView {
    
    weak var delegate: YMTopHeaderViewDelegate?
    
  
    @IBAction func viewAllButton(_ sender: UIButton) {
        delegate?.topViewDidClickedMoreButton(sender)
    }
}
