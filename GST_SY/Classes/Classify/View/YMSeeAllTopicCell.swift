//
//  YMSeeAllTopicCell.swift
//  GST_SY
//
//

import UIKit
import Kingfisher

class YMSeeAllTopicCell: UITableViewCell {
    
    var collection: YMCollection? {
        didSet {
            let url = collection!.cover_image_url
            
            bgImageView.kf_setImage(with: URL(string: url!))
            self.placeholderButton.isHidden = true
            
//            bgImageView.kf_setImageWithURL(URL(string: url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                self.placeholderButton.hidden = true
//            }
            titleLabel.text = collection!.title
            subtitleLabel.text = collection!.subtitle
        }
    }
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var placeholderButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgImageView.layer.cornerRadius = kCornerRadius
        bgImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
