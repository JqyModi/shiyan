//
//  YMProductDetailToolBar.swift
//  GST_SY
//

import UIKit

protocol YMProductDetailToolBarDelegate: NSObjectProtocol {
    func toolBarDidClickedTMALLButton()
}

class YMProductDetailToolBar: UIView {
    
    weak var delegate: YMProductDetailToolBarDelegate?
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.layer.borderColor = YMGlobalRedColor().cgColor
        likeButton.layer.borderWidth = klineWidth
        likeButton.setImage(UIImage(named: "content-details_like_16x16_"), for: UIControlState())
        likeButton.setImage(UIImage(named: "content-details_like_selected_16x16_"), for: .selected)
    }
    
    @IBAction func likeButtonClick(_ sender: UIButton) {
   
        if UserDefaults.standard.bool(forKey: isLogin) {
            sender.isSelected = !sender.isSelected
        } else {
            let loginVC = YMLoginViewController()
            loginVC.title = "登录"
            let nav = YMNavigationController(rootViewController: loginVC)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func goTMALLButtonClick() {
        delegate?.toolBarDidClickedTMALLButton()
    }
}
