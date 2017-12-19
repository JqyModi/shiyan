//
//  Paper.swift
//  GST_SY
//
//  Created by mac on 17/7/17.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation
class Paper :NSObject{
    
//    {
//    "success":true,
//    "error_code":0,
//    "message":"数据加载完毕！",
//    "xcontent":Object{...},
//    "tcontent":Object{...},
//    "jcontent":Object{...}
//    }
    
//    {
//    "0":"佛山剪纸",
//    "1":"潮州木雕",
//    "2":"信宜竹编",
//    "3":"客家米酒",
//    "title":"下列民间制作属于化学变化的是",
//    "img":"",
//    "right":"D",
//    "jiexi":"【分析】 有新物质生成的变化叫化学变化，没有新物质生成的变化叫物理变化．化学变化的特征是：有新物质生成．判断物理变化和化学变化的依据是：是否有新物质生成．佛山剪纸没有新物质生成；潮州木雕、信宜竹编都没有新物质生成；客家米酒是用米酿酒，酒精是新物质． 【解答】 解：A、佛山剪纸没有新物质生成，属于物理变化，故选项错误； B、潮州木雕没有新物质生成，属于物理变化，故选项错误； C、信宜竹编没有新物质生成，属于物理变化，故选项错误； D、客家米酒是用米酿酒，酒精是新物质，属于化学变化，故选项正确； 故选D"
//    }
    
    var title : String!
    var img : String!
    var right : String!
    var jiexi: String!
    var A: String!
    var B: String!
    var C: String!
    var D: String!
    var type: String!
    
    var userRight: String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        title = dict["title"] as? String
        img = dict["img"] as? String
        jiexi = dict["jiexi"] as? String
        right = dict["right"] as? String
        A = dict["0"] as? String
        B = dict["1"] as? String
        C = dict["2"] as? String
        D = dict["3"] as? String
        type = dict["type"] as? String
        
        userRight = ""
    }
    
}
