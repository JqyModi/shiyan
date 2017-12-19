//
//  YMMineHeaderView.swift
//  YMMineHeaderView
//  GST_SY

import UIKit
import SnapKit

class YMMineHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        setupUI()
    }
    
    fileprivate func setupUI() {

        addSubview(bgImageView)
        addSubview(settingButton)
        addSubview(messageButton)
        addSubview(iconButton)
        addSubview(nameLabel)
      
        bgImageView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(-20)
        }
        
        settingButton.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.equalTo(self)
            make.top.equalTo(0)
        }
        
        messageButton.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.left.equalTo(self)
            make.top.equalTo(settingButton.snp_top)
        }
        
        iconButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.centerX)
            make.size.equalTo(CGSize(width: 75, height: 75))
            make.bottom.equalTo(nameLabel.snp_top).offset(-kMargin)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_bottom).offset(-3 * kMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(2 * kMargin)
        }
        
    }
    

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "Me_ProfileBackground")
        return bgImageView
    }()

    lazy var messageButton: UIButton = {
        let messageButton = UIButton()
        messageButton.setImage(UIImage(named: "Me_message_20x20_"), for: UIControlState())
        return messageButton
    }()
    

    lazy var settingButton: UIButton = {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "Me_settings_20x20_"), for: UIControlState())
        return settingButton
    }()
    

    lazy var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.setBackgroundImage(UIImage(named: "Me_AvatarPlaceholder_75x75_"), for: UIControlState())
        iconButton.layer.cornerRadius = iconButton.width * 0.5
        iconButton.layer.masksToBounds = true
        return iconButton
    }()
    

    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "hrscy"
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 15.0)
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
