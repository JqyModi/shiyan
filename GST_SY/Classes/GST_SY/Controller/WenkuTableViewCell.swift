//
//  WenkuTableViewCell.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

protocol WenkuTableViewCellDelegate: NSObjectProtocol {
}
class WenkuTableViewCell: UITableViewCell {
    weak var delegate: WenkuTableViewCellDelegate?
    
  
    
    @IBOutlet weak var lbCell: UILabel!
    var videoItem: WenKu? {
        didSet {
            
            lbCell.text = videoItem!.title
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
