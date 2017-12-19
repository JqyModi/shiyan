//
//  YMNewfeatureViewController.swift
//  GST_SY
//
//

import UIKit
import SnapKit

let newFeatureID = "newFeatureID"

class YMNewfeatureViewController: UICollectionViewController {
    
    fileprivate var layout: UICollectionViewFlowLayout = YMNewfeatureLayout()
    init() {
        super.init(collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(YMNewfeatureCell.self, forCellWithReuseIdentifier: newFeatureID)
        
    }
}

extension YMNewfeatureViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNewFeatureCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFeatureID, for: indexPath) as! YMNewfeatureCell
        cell.imageIndex = indexPath.item
        //清除子view
        if indexPath.item != 3 {
            if cell.startButton != nil{
                cell.startButton.isHidden = true
            }
        }
        
        return cell
    }
  
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let path = collectionView.indexPathsForVisibleItems.last!
        if path.item == (kNewFeatureCount - 1) {
            let cell = collectionView.cellForItem(at: path) as! YMNewfeatureCell
            cell.startBtnAnimation()
        }
    }
}

/// YMNewfeatureCell
private class YMNewfeatureCell: UICollectionViewCell {
    
    fileprivate var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "walkthrough_\(imageIndex! + 1)")
        }
    }
    
    func startBtnAnimation() {
        startButton.isHidden = false
    
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        
        // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
       
            self.startButton.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                self.startButton.isUserInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        startButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp_bottom).offset(-50)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.centerX.equalTo(SCREENW/2)
        }
    }
    
    fileprivate lazy var iconView = UIImageView()
    fileprivate lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "btn_begin"), for: UIControlState())
        btn.addTarget(self, action: #selector(startButtonClick), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    @objc func startButtonClick() {
        UIApplication.shared.keyWindow?.rootViewController = YMTabBarController()
        startButton.isHidden = true
    }
}

private class YMNewfeatureLayout: UICollectionViewFlowLayout {

    fileprivate override func prepare() {
        
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
       
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
