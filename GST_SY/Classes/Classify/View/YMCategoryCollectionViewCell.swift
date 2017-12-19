//
//  YMCategoryCollectionViewCell.swift
//  GST_SY
//
import UIKit
import Kingfisher

class YMCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var placeholderButton: UIButton!
    
    var collection: YMCollection? {
        didSet {
            let url = collection!.banner_image_url
            collectionImageView.kf_setImage(with: URL(string: url!)!)
            self.placeholderButton.isHidden = true
//            collectionImageView.kf_setImageWithURL(URL(string: url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                self.placeholderButton.hidden = true
//            }
        }
    }
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
