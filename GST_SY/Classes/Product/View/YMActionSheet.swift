//
//  YMActionSheet.swift
//  GST_SY
//

import UIKit
import SnapKit

class YMActionSheet: UIView {
    
    class func show() {
        let actionSheet = YMActionSheet()
        actionSheet.frame = UIScreen.main.bounds
        actionSheet.backgroundColor = YMColor(0, g: 0, b: 0, a: 0.6)
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(actionSheet)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(bgView)
        

        bgView.addSubview(topView)

        bgView.addSubview(cancelButton)

        topView.addSubview(shareLabel)

        topView.addSubview(shareButtonView)
        
        topView.snp_makeConstraints { (make) in
            make.bottom.equalTo(cancelButton.snp_top).offset(-kMargin)
            make.left.equalTo(cancelButton.snp_left)
            make.right.equalTo(cancelButton.snp_right)
            make.height.equalTo(kTopViewH)
        }
        
        cancelButton.snp_makeConstraints { (make) in
            make.left.equalTo(bgView).offset(kMargin)
            make.right.bottom.equalTo(bgView).offset(-kMargin)
            make.height.equalTo(44)
        }
        
        shareLabel.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(topView)
            make.height.equalTo(30)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.bgView.y = SCREENH - self.bgView.height
        }) 
    }
    

    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: SCREENH, width: SCREENW, height: 280)
        return bgView
    }()

    fileprivate lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        topView.layer.cornerRadius = kCornerRadius
        topView.layer.masksToBounds = true
        return topView
    }()
    

    fileprivate lazy var shareLabel: UILabel = {
        let shareLabel = UILabel()
        shareLabel.text = "分享到"
        shareLabel.textColor = YMColor(0, g: 0, b: 0, a: 0.7)
        shareLabel.textAlignment = .center
        return shareLabel
    }()

    fileprivate lazy var shareButtonView: YMShareButtonView = {
        let shareButtonView = YMShareButtonView()
        shareButtonView.frame = CGRect(x: 0, y: 30, width: SCREENW - 20, height: kTopViewH - 30)
        return shareButtonView
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: UIControlState())
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.setTitleColor(YMColor(37, g: 142, b: 240, a: 1.0), for: UIControlState())
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        cancelButton.layer.cornerRadius = kCornerRadius
        cancelButton.layer.masksToBounds = true
        return cancelButton
    }()
    
    func cancelButtonClick() {
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.bgView.y = SCREENH
        }, completion: { (_) in
            self.removeFromSuperview()
        }) 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: kAnimationDuration, animations: { 
            self.bgView.y = SCREENH
            }, completion: { (_) in
                self.removeFromSuperview()
        }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
