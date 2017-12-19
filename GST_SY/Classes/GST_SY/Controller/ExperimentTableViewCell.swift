//
//  ExperimentTableViewCell.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
protocol ExperimentTableViewCellDelegate: NSObjectProtocol {
}
class ExperimentTableViewCell: UITableViewCell {
    weak var delegate: ExperimentTableViewCellDelegate?
    
    @IBOutlet weak var lbCell: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    var videoItem: Experiment? {
        didSet {
            let url = videoItem!.imgUrlS
            cellImg.kf_setImage(with: URL(string: url!)!)
//            cellImg.kf_setImageWithURL(URL(string: url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                
//            }
            
            lbCell.text = videoItem!.name
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
