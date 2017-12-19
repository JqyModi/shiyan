//
//  YMCategoryBottomView.swift
//  GST_SY
//
//

import UIKit
import Kingfisher

protocol YMCategoryBottomViewDelegate: NSObjectProtocol {
    func bottomViewButtonDidClicked(_ button: UIButton)
}

class YMCategoryBottomView: UIView {
    
    weak var delegate: YMCategoryBottomViewDelegate?
    
    var outGroups = [AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        YMNetworkTool.shareNetworkTool.loadCategoryGroup { [weak self] (outGroups) in
//            self!.outGroups = outGroups
//            self!.setupUI()
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupUI() {
        let topGroups = outGroups[0] as! NSArray
        let bottomGroups = outGroups[1] as! NSArray
   
        let topView = UIView()
        topView.width = SCREENW
        topView.backgroundColor = UIColor.white
        addSubview(topView)
        let styleLabel = setupLabel("风格")
        topView.addSubview(styleLabel)
        
        for index in 0..<topGroups.count {
            let group = topGroups[index] as! YMGroup
            let button = setupButton(index, group: group)
            topView.addSubview(button)
            if index == topGroups.count - 1 {
                topView.height = button.frame.maxY + kMargin
            }
        }
        
    
        let bottomView = UIView()
        bottomView.width = SCREENW
        bottomView.y = topView.frame.maxY + kMargin
        bottomView.backgroundColor = UIColor.white
        addSubview(bottomView)
        let categoryLabel = setupLabel("品类")
        bottomView.addSubview(categoryLabel)
        
        for index in 0..<bottomGroups.count {
            let group = bottomGroups[index] as! YMGroup
            let button = setupButton(index, group: group)
            bottomView.addSubview(button)
            if index == bottomGroups.count - 1 {
                bottomView.height = button.frame.maxY + kMargin
            }
        }
    }
    
    fileprivate func setupButton(_ index: Int, group: YMGroup) -> YMVerticalButton{
        let buttonW: CGFloat = SCREENW / 4
        let buttonH: CGFloat = buttonW
        let styleLabelH: CGFloat = 40
        
        let button = YMVerticalButton()
        button.width = buttonW
        button.height = buttonH
        button.x = buttonW * CGFloat(index % 4)
        button.y = buttonH * CGFloat(index / 4) + styleLabelH
        if index > 3 {
            button.y = buttonH * CGFloat(index / 4) + styleLabelH + kMargin
        }
        button.tag = group.id!
        button.addTarget(self, action: #selector(groupButonClick(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(YMColor(0, g: 0, b: 0, a: 0.6), for: UIControlState())
        button.kf_setImage(with: URL(string: group.icon_url!)!, for: .normal)
//        button.kf_setImageWithURL(URL(string: group.icon_url!)!, forState: .Normal)
        button.setTitle(group.name, for: UIControlState())
        return button
    }
    
    func groupButonClick(_ button: UIButton) {
        delegate?.bottomViewButtonDidClicked(button)
    }
    
    fileprivate func setupLabel(_ title: String) -> UILabel {
        let styleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: SCREENW - 10, height: 40))
        styleLabel.text = title
        styleLabel.textColor = YMColor(0, g: 0, b: 0, a: 0.6)
        styleLabel.font = UIFont.systemFont(ofSize: 16)
        return styleLabel
    }
}
