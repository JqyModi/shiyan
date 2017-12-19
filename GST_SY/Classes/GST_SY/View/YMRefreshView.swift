//
//  YMRefreshView.swift
//  GST_SY
//
//

import UIKit

class YMRefreshView: UIView {

    @IBOutlet weak var arrowIcon: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var loadingView: UIImageView!
    
 
    func rotationArrowIcon(_ flag: Bool) {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animate(withDuration: kAnimationDuration, animations: { 
            self.arrowIcon.transform = self.arrowIcon.transform.rotated(by: CGFloat(angle))
        }) 
    }
    
    func startLodingViewAnimation() {
        
        tipView.isHidden = true
  
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * M_PI
        animation.duration = 1
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        loadingView.layer.add(animation, forKey: nil)
    }
    

    func stopLodingViewAnimation() {
        tipView.isHidden = false
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> YMRefreshView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! YMRefreshView
    }
    
}
