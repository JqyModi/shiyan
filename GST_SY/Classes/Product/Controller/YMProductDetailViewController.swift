//
//  YMProductDetailViewController.swift
//  GST_SY
//

import UIKit
import SnapKit

class YMProductDetailViewController: YMBaseViewController, YMProductDetailToolBarDelegate {
    
    var product: YMProduct?
    
    var result: YMSearchRs?
    
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "GiftShare_icon_18x22_"), style: .plain, target: self, action: #selector(shareBBItemClick))
        
        view.addSubview(scrollView)
        

        view.addSubview(toolBarView)
        scrollView.product = product
        
        scrollView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(toolBarView.snp_top)
        }
        
        toolBarView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(45)
        }
        
        scrollView.contentSize = CGSize(width: SCREENW, height: SCREENH - 64 - 45 + kMargin + 520)
    }
    

    func shareBBItemClick() {
        YMActionSheet.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// scrollView
    fileprivate lazy var scrollView: YMDetailScrollView = {
        let scrollView = YMDetailScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    

    fileprivate lazy var toolBarView: YMProductDetailToolBar = {
        let toolBarView = Bundle.main.loadNibNamed(String(describing: YMProductDetailToolBar()), owner: nil
            , options: nil)?.last as! YMProductDetailToolBar
        toolBarView.delegate = self
        return toolBarView
    }()
    

    func toolBarDidClickedTMALLButton() {
        let tmallVC = YMTMALLViewController()
        tmallVC.title = "商品详情"
        tmallVC.product = product
        let nav = YMNavigationController(rootViewController: tmallVC)
        present(nav, animated: true, completion: nil)
    }
}

extension YMProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetY = scrollView.contentOffset.y
        if offsetY >= 465 {
            offsetY = CGFloat(465)
            scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }
}

