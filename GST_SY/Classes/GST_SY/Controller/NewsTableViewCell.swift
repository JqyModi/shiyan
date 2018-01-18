//
//  NewsTableViewCell.swift
//  GST_SY
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbCell: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var newsItem: News? {
        didSet {
            lbCell.text = newsItem!.title
            timeLabel.text = "更新时间：" + String.formatDateAndTime(str: (newsItem?.dateline)!)
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


