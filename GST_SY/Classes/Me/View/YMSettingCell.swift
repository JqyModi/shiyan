//
//  YMSettingCell.swift
//  GST_SY
//

import UIKit

class YMSettingCell: UITableViewCell {
    
    var setting: YMSetting! {
        didSet {
            iconImageView.image = UIImage(named: setting!.iconImage!)
            leftLabel.text = setting!.leftTitle
            rightLabel.text = setting.rightTitle
            switchView.isHidden = setting!.isHiddenSwitch!
            rightLabel.isHidden = setting.isHiddenRightTitle!
            
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var disclosureIndicator: UIImageView!
    
    @IBOutlet weak var switchView: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configStyle()
    }
    
    func configStyle(){
        
        self.leftLabel.textColor = GSTGlobalFontColor()
        self.leftLabel.font = UIFont.systemFont(ofSize: GSTGlobalFontSmallSize())
        
        self.rightLabel.textColor = GSTGlobalFontColor()
        self.rightLabel.font = UIFont.systemFont(ofSize: GSTGlobalFontSmallSize())
    }
    
    //重写frame属性而不是方法
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10/2
            newFrame.size.width -= 10
            newFrame.origin.y += 4
            newFrame.size.height -= 4
            super.frame = newFrame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
