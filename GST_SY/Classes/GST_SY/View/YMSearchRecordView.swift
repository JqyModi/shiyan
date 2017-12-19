//
//  YMSearchRecord.swift
//  GST_SY
//
//

import UIKit

class YMSearchRecordView: UIView {
    
    var words = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weak var weakSelf = self
        YMNetworkTool.shareNetworkTool.loadHotWords { (hot_words) in
            weakSelf!.words = hot_words
            weakSelf!.setupUI()
        }
    }
    
    func setupUI() {
        
        let topView = UIView()
        addSubview(topView)
        let hotLabel = setupLabel("大家都在搜")
        hotLabel.frame = CGRect(x: 10, y: 20, width: 200, height: 20)
        topView.addSubview(hotLabel)
        
        let bottomView = UIView()
        
        addSubview(bottomView)
    }
    
    
    
    func setupLabel(_ title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = YMColor(0, g: 0, b: 0, a: 0.6)
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
