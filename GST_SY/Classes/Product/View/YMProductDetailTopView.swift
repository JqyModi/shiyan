//
//  YMProductDetailTopView.swift
//  GST_SY

import UIKit
import SnapKit
import Kingfisher

let detailCollectionViewCellID = "detailCollectionViewCellID"

class YMProductDetailTopView: UIView {
    
    var imageURLs = [String]()
    
    var product: YMProduct? {
        didSet {
            imageURLs = product!.image_urls!
            collectionView.reloadData()
            pageControl.numberOfPages = imageURLs.count
            titleLabel.text = product!.name
            priceLabel.text = "￥\(product!.price!)"
            describeLabel.text = product!.describe
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        addSubview(pageControl)
        
        addSubview(titleLabel)
        
        addSubview(priceLabel)
        
        addSubview(describeLabel)
        
        pageControl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(collectionView.snp_bottom).offset(-30)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(collectionView.snp_bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self.snp_right).offset(-5)
            make.height.equalTo(30)
        }
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.height.equalTo(25)
        }
        
        describeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp_left)
            make.right.equalTo(priceLabel.snp_right)
            make.top.equalTo(priceLabel.snp_bottom).offset(5)
            make.bottom.equalTo(self.snp_bottom).offset(-5)
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENW, height: 375), collectionViewLayout: YMDetailLayout())
        let nib = UINib(nibName: String(describing: YMDetailCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: detailCollectionViewCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
  
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        return pageControl
    }()
    

    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    

    fileprivate lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.numberOfLines = 0
        priceLabel.textColor = YMGlobalRedColor()
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        return priceLabel
    }()
    

    fileprivate lazy var describeLabel: UILabel = {
        let describeLabel = UILabel()
        describeLabel.numberOfLines = 0
        describeLabel.textColor = YMColor(0, g: 0, b: 0, a: 0.6)
        describeLabel.font = UIFont.systemFont(ofSize: 15)
        return describeLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YMProductDetailTopView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCollectionViewCellID, for: indexPath) as! YMDetailCollectionViewCell
        let url = imageURLs[indexPath.item]

        cell.bgImageView.kf_setImage(with: URL(string: url)!)
        cell.placeholderButton.isHidden = true
//        cell.bgImageView.kf_setImageWithURL(URL(string: url)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
//            cell.placeholderButton.hidden = true
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = offsetX / scrollView.width
        pageControl.currentPage = Int(page + 0.5)
    }
    
}

private class YMDetailLayout: UICollectionViewFlowLayout {

    fileprivate override func prepare() {

        itemSize = CGSize(width: SCREENW, height: 375)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
   
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
