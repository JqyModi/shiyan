//
//  GridCollectionViewCell.swift
//  GST_SY
//
//  Created by Don on 16/8/16.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.imageView = UIImageView(frame: CGRectMake(30, 20, 70,  75))
//        self.textLabel = UILabel(frame:  CGRectMake(32, 100, 80, 25))
        
        //modi 当iPad时显示位置不合适：重新计算
        self.imageView = UIImageView(frame: CGRect(x: (self.width-50)/2, y: (self.height-50-25)/2, width: 50,  height: 50))
        self.textLabel = UILabel(frame:  CGRect(x: (self.width-80)/2, y: (self.height)/2+imageView.height/2, width: 80, height: 25))
        self.textLabel.textAlignment = NSTextAlignment.center
        self.contentMode = UIViewContentMode.center
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.textLabel)
        
        configStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.imageView.
        //fatalError("init(coder:) has not been implemented")
    }
    
    func configStyle(){
        self.layer.cornerRadius = 5;
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        self.textLabel.textColor = GSTGlobalFontColor()
        self.textLabel.font = UIFont.systemFont(ofSize: GSTGlobalFontSmallSize())
        
        self.imageView.tintColor = YMGlobalGreenColor()
    }
    
    //重写frame属性而不是方法
//    override var frame:CGRect{
//        didSet {
//            var newFrame = frame
//            newFrame.origin.x += 20/2
//            newFrame.size.width -= 20
//            newFrame.origin.y += 10
//            newFrame.size.height -= 10
//            super.frame = newFrame
//        }
//    }
    
}

