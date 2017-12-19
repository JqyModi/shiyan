//
//  YMCollectionViewCell.swift
//  CollectionViewDemo
//
import UIKit
import Kingfisher
//import KeyframePicker
import AVFoundation
import MobileCoreServices

protocol YMCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidClickedLikeButton(_ button: UIButton)
}

class YMCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: YMCollectionViewCellDelegate?
    let HOST = "http://shiyan360.cn"
    
    var result: YMSearchRs? {
        didSet {
            let vurl = result!.url!
            var iurl = HOST+vurl
            
            //http://shiyan360.cn/public/uploads/video/20160510/57318c712ce68.mp4
//            如果是文本文件就显示这个图片：icon_doc
            NSLog("iurl == \(iurl)", "g%")
            NSLog("iurl ========= \(result?.img)", "g%")

            productImageView.kf_setImage(with: URL(string: HOST+result!.img!)!)
            self.placeholderBtn.isHidden = true
            
//            productImageView.kf_setImageWithURL(URL(string: HOST+result!.img!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                self.placeholderBtn.hidden = true
//            }
//            if iurl.containsString(".mp4") {
//                productImageView.getNetWorkVidoeImage(iurl)
//            }else{
//                productImageView.image = UIImage(named: "icon_doc")
//            }
            
            self.placeholderBtn.isHidden = true
            
//            likeButton.setTitle(" " + String(result!.favorites_count!) + " ", forState: .Normal)
//            titleLabel.text = result!.name
//            priceLabel.text = "￥" + String(result!.price!)
            titleLabel.text = result!.title
            priceLabel.text = result!.model
            var str = (result?.model)! as String
            //判断讲类型转换成中文
            switch str {
            case "Chuangke":
                priceLabel.text = "创客"
            case "Wenku":
                priceLabel.text = "文库"
            case "Shiyan":
                priceLabel.text = "实验"
            case "Play":
                priceLabel.text = "视频"
            case "Article":
                priceLabel.text = "文章"
            case "Mingshi":
                priceLabel.text = "名师"
            default:
                priceLabel.text = result!.model
            }
            
        }
    }
    
    
    var product: YMProduct? {
        didSet {
            let url = product!.cover_image_url!
            
            productImageView.kf_setImage(with: URL(string: HOST+result!.img!)!)
            self.placeholderBtn.isHidden = true
            
//            productImageView.kf_setImageWithURL(URL(string: url)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//                self.placeholderBtn.hidden = true
//            }
            likeButton.setTitle(" " + String(product!.favorites_count!) + " ", for: UIControlState())
            titleLabel.text = product!.name
            priceLabel.text = "￥" + String(product!.price!)
        }
    }

    @IBOutlet weak var placeholderBtn: UIButton!

    @IBOutlet weak var productImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likeButtonClick(_ sender: UIButton) {
        delegate?.collectionViewCellDidClickedLikeButton(sender)
    }
    
}
