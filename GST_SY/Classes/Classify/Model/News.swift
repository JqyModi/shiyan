//
//  News.swift
//  GST_SY
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit

class News: NSObject {
    //    "id":"1204",
    //    "title":"新课程背景下的高中化学实验教学",
    //    "dateline":"1515634589"
    
    var id: String?
    var title: String?
    var dateline: String?
    
    init(dict: [String : Any]?) {
        super.init()
        setValuesForKeys(dict!)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

