//
//  YMVerticalButton.swift
//  GST_SY
//

import UIKit
import Kingfisher

class YMVerticalButton: UIButton {
    
    var group: YMGroup? {
        didSet {
            let url = group!.icon_url
            imageView?.kf_setImage(with: URL(string: url!)!)
//            imageView?.kf_setImageWithURL(URL(string: url!)!)
            titleLabel?.text = group!.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        imageView?.x = 10
        imageView?.y = 0
        imageView?.width = self.width - 20
        imageView?.height = imageView!.width

        titleLabel?.x = 0
        titleLabel?.y = imageView!.height
        titleLabel?.width = self.width
        titleLabel?.height = self.height - self.titleLabel!.y
    }
    
}
