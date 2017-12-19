//
//  YMHomeCell.swift
//  GST_SY
//
import UIKit
import Kingfisher

protocol YMHomeCellDelegate: NSObjectProtocol {
    func homeCellDidClickedFavoriteButton(_ button: UIButton)
}

class YMHomeCell: UITableViewCell {
    
    weak var delegate: YMHomeCellDelegate?
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var placeholderBtn: UIButton!
    
    var homeItem: YMHomeItem? {
        didSet {
            let url = homeItem!.cover_image_url
            
            bgImageView.kf_setImage(with: URL(string: url!)!)
            self.placeholderBtn.isHidden = true
            
//            bgImageView.kf_setImageWithURL(URL(string: url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                self.placeholderBtn.hidden = true
//            }
            titleLabel.text = homeItem!.title
            favoriteBtn.setTitle(" " + String(homeItem!.likes_count!) + " ", for: UIControlState())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteBtn.layer.cornerRadius = favoriteBtn.height * 0.5
        favoriteBtn.layer.masksToBounds = true
        favoriteBtn.layer.rasterizationScale = UIScreen.main.scale
        favoriteBtn.layer.shouldRasterize = true
        bgImageView.layer.cornerRadius = kCornerRadius
        bgImageView.layer.masksToBounds = true
        bgImageView.layer.shouldRasterize = true
        bgImageView.layer.rasterizationScale = UIScreen.main.scale
    }
    
  
    @IBAction func favoriteButtonClick(_ sender: UIButton) {
        delegate?.homeCellDidClickedFavoriteButton(sender)
    }
}
