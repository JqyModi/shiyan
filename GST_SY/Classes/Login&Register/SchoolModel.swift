//
//  SchoolModel.swift
//  GST_SY
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit

class SchoolModel: NSObject {
    @objc var name: String?
    @objc var pinyin: String?
    
    init(dict: [String : String]?) {
        super.init()
        //
        setValuesForKeys(dict!)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
