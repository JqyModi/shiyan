//
//  KaoPingTableViewCell.swift
//  GST_SY
//
//  Created by mac on 17/7/17.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

protocol KaoPingTableViewCellDelegate: NSObjectProtocol {
}
class KaoPingTableViewCell: UITableViewCell {
    weak var delegate: KaoPingTableViewCellDelegate?
    
    @IBOutlet weak var lbCell: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var kp: KaoPing? {
        didSet {
            lbCell.text = kp!.paper
            timeLabel.text = "更新时间：" + String.formatDateAndTime(str: (kp?.addtime)!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbCell.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbCell.numberOfLines = 0
        lbCell.lineBreakMode = NSLineBreakMode.byCharWrapping
        lbCell.font=UIFont.systemFont(ofSize: 15)
        
        configStyle()
    }
    
    func configStyle(){
//        self.contentView.layer.borderColor = UIColor.clearColor().CGColor
//        self.contentView.layer.masksToBounds = true;
//        
//        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowRadius = 2.0;
//        self.layer.shadowOpacity = 0.5;
//        self.layer.masksToBounds = false;
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).CGPath
        
        self.lbCell.textColor = GSTGlobalFontColor()
        self.lbCell.font = UIFont.systemFont(ofSize: GSTGlobalFontSmallSize())
        
        self.lbCell.textAlignment = .left
    }
    
    //重写frame属性而不是方法
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10/2
            newFrame.size.width -= 10
            newFrame.origin.y += 2
            newFrame.size.height -= 2
            super.frame = newFrame
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
