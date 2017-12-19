//
//  OneContent.swift
//  GST_SY
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation

class OneContent: NSObject {
    var page: String?
    var answer: SecondContent?
    var strAnswer: String?
    
    init(page: String, answer: SecondContent) {
        self.page = page
        self.answer = answer
    }
    
    func getJsonStr() -> String{
        let str = self.answer!.getJsonStr()
        return "{\"" + self.page! + "\":\"" + str + "\"}"
    }
}
