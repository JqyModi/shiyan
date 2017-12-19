//
//  FilterView.swift
//  GST_SY
//
//  Created by Don on 16/9/7.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

class FilterView: UIView{

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     fileprivate func setupUI() {
        
        addSubview(menuView)
    }
 
    lazy var menuView: WOWDropMenuView = {
        let menuView = WOWDropMenuView(frame:CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 44))
        WOWDropMenuSetting.columnTitles = ["综合排序","筛选","快递"]
        WOWDropMenuSetting.rowTitles =  [
            ["销量","价格","信誉","性价比高","口碑超赞"],
            ["热销的咯","推荐","进口保证","美国"],
            ["申通","圆通速递","韵达","德邦"]
        ]
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.columnEqualWidth = true
        WOWDropMenuSetting.cellTextLabelSelectColoror = UIColor.red
        WOWDropMenuSetting.showDuration = 0.2
//        menuView.delegate = self
        
        return menuView
    }()

}
