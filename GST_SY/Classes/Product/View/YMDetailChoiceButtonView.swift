//
//  YMDetailChoiceButton.swift
//  GST_SY
//

import UIKit

protocol YMDetailChoiceButtonViewDegegate: NSObjectProtocol {

    func choiceIntroduceButtonClick()

    func choicecommentButtonClick()
}

class YMDetailChoiceButtonView: UIView {
    
    weak var delegate: YMDetailChoiceButtonViewDegegate?

    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBAction func introduceButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.lineView.x = 0
        }) 
        delegate?.choiceIntroduceButtonClick()
    }
    
    @IBAction func commentButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.lineView.x = SCREENW * 0.5
        }) 
        delegate?.choicecommentButtonClick()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func choiceButtonView() -> YMDetailChoiceButtonView{
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! YMDetailChoiceButtonView
    }
    
}
