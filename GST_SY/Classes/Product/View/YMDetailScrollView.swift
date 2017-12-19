//
//  YMDetailScrollView.swift
//  GST_SY
//

import UIKit

class YMDetailScrollView: UIScrollView {
    
    var product: YMProduct? {
        didSet {
            topScrollView.product = product
            bottomScrollView.product = product
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        
        addSubview(topScrollView)
      
        addSubview(bottomScrollView)
        
        topScrollView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.size.equalTo(CGSize(width: SCREENW, height: 520))
        }
        
        bottomScrollView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(topScrollView.snp_bottom).offset(kMargin)
            make.size.equalTo(CGSize(width: SCREENW, height: SCREENH - 64 - 45))
        }
    }
 
    fileprivate lazy var topScrollView: YMProductDetailTopView = {
        let topScrollView = YMProductDetailTopView()
        topScrollView.backgroundColor = UIColor.white
        return topScrollView
    }()
    

    fileprivate lazy var bottomScrollView: YMProductDetailBottomView = {
        let bottomScrollView = YMProductDetailBottomView()
        bottomScrollView.backgroundColor = UIColor.white
        return bottomScrollView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
