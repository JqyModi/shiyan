//
//  ZiXunTableViewCell.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

protocol ZiXunTableViewCellDelegate: NSObjectProtocol {
}
class ZiXunTableViewCell: UITableViewCell {
    weak var delegate: ZiXunTableViewCellDelegate?
    
    
    
    @IBOutlet weak var lbCell: UILabel!
    var videoItem: ZiXun? {
        didSet {
            
            lbCell.text = videoItem!.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configStyle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configStyle(){
        
        self.lbCell.textColor = GSTGlobalFontColor()
        self.lbCell.font = UIFont.systemFont(ofSize: 12)
        self.lbCell.adjustsFontSizeToFitWidth = true
        self.lbCell.textAlignment = .center
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
    
}
