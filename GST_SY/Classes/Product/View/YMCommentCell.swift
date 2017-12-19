//
//  YMCommentCell.swift
//  GST_SY
//
//

import UIKit
import Kingfisher

class YMCommentCell: UITableViewCell {

    var comment: YMComment? {
        didSet {
            let user = comment!.user
            let url = user!.avatar_url
            avatarImageView.kf_setImage(with: URL(string: url!)!)
//            avatarImageView.kf_setImageWithURL(URL(string: url!)!)
            nicknameLabel.text = user!.nickname
            contentLabel.text = comment!.content
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
