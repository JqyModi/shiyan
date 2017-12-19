//
//  SecondContent.swift
//  GST_SY
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 hrscy. All rights reserved.
//
import Foundation
class SecondContent: NSObject {
    var key: String?
    var value: String?
    
    init(key: String,value: String) {
        self.key = key
        self.value = value
    }
    
    func getJsonStr() -> String{
        return "{\"" + self.key! + "\":\"" + self.value! + "\"}"
    }
}
