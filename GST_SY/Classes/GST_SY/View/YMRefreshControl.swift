//
//  YMRefreshControl.swift
//  GST_SY
//
//

import UIKit
import SnapKit

class YMRefreshControl: UIRefreshControl {
   
    fileprivate var rotationArrowFlag = false
   
    fileprivate var loadingViewAnimationFlag = false
    
    override init() {
        super.init()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
       
        addSubview(refreshView)
        
        refreshView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 170, height: 60))
        }
      
        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      
        if frame.origin.y >= 0 {
            return
        }
        
   
        if isRefreshing && !loadingViewAnimationFlag {
          
            loadingViewAnimationFlag = true
            
            refreshView.startLodingViewAnimation()
            return
        }
        
        if frame.origin.y >= -40 && rotationArrowFlag {
        
            rotationArrowFlag = false
            refreshView.rotationArrowIcon(rotationArrowFlag)
        } else if frame.origin.y < -40 && !rotationArrowFlag {
            rotationArrowFlag = true
            refreshView.rotationArrowIcon(rotationArrowFlag)
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        removeObserver(self, forKeyPath: "frame")
        
    }
 
    override func endRefreshing() {
        super.endRefreshing()
      
        refreshView.stopLodingViewAnimation()
        
        loadingViewAnimationFlag = false
    }
    

    fileprivate lazy var refreshView: YMRefreshView = YMRefreshView.refreshView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
