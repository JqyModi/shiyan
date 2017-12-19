//
//  YMMeChoiceView.swift
//  GST_SY
//

import UIKit
import Kingfisher

class YMMeChoiceView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
 
         addSubview(leftButton)

        addSubview(rightButton)

        addSubview(indicatorView)
        
        leftButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(rightButton)
        }
        
        rightButton.snp_makeConstraints { (make) in
            make.left.equalTo(leftButton.snp_right)
            make.top.right.bottom.equalTo(self)
        }
        
        indicatorView.snp_makeConstraints { (make) in
            make.height.equalTo(kIndicatorViewH)
            make.bottom.left.equalTo(self)
            make.right.equalTo(leftButton)
        }
    }
    

    fileprivate lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("喜欢的商品", for: UIControlState())
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftButton.setTitleColor(YMColor(0, g: 0, b: 0, a: 0.7), for: UIControlState())
        leftButton.backgroundColor = UIColor.white
        leftButton.addTarget(self, action: #selector(leftButtonClick(_:)), for: .touchUpInside)
        leftButton.layer.borderColor = YMColor(230, g: 230, b: 230, a: 1.0).cgColor
        leftButton.layer.borderWidth = klineWidth
        leftButton.isSelected = true
        return leftButton
    }()
    

    fileprivate lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitle("喜欢的专题", for: UIControlState())
        rightButton.setTitleColor(YMColor(0, g: 0, b: 0, a: 0.7), for: UIControlState())
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightButton.backgroundColor = UIColor.white
        rightButton.addTarget(self, action: #selector(rightButtonClick(_:)), for: .touchUpInside)
        rightButton.layer.borderColor = YMColor(230, g: 230, b: 230, a: 1.0).cgColor
        rightButton.layer.borderWidth = klineWidth
        return rightButton
    }()
    

    fileprivate lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = YMGlobalRedColor()
        return indicatorView
    }()
    
    func leftButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.indicatorView.x = 0
        }) 
    }
    
    func rightButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.indicatorView.x = SCREENW * 0.5
        }) 
    }
}
