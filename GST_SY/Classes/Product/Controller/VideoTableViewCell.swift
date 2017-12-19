//
//  VideoTableViewCell.swift
//  GST_SY
//
//  Created by Don on 16/8/4.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
protocol VideoTableViewCellDelegate: NSObjectProtocol {
    }
class VideoTableViewCell: UITableViewCell {
    weak var delegate: VideoTableViewCellDelegate?
    @IBOutlet weak var cellImg: UIImageView!
    
    @IBOutlet weak var lbCell: UILabel!
    
    @IBOutlet weak var btn_collect: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    
    var videoItem: VideoModel? {
        didSet {
            let url = videoItem!.imgUrlS
            if !(url?.isEmpty)! {
                cellImg.kf_setImage(with: URL(string: url!)!)
            }
            
//            cellImg.kf_setImageWithURL(URL(string: url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//
//            }
            
            lbCell.text = videoItem!.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            newFrame.origin.y += 4
            newFrame.size.height -= 4
            super.frame = newFrame
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
