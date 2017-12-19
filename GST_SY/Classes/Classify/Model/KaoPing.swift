//
//  KaoPing.swift
//  GST_SY
//
//  Created by mac on 17/7/17.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation
class KaoPing :NSObject{
    
//    addtime:"1499154274"
//    id:"7"
//    paper:"铜、锌、稀硫酸原电池反应"
    
    var addtime : String!
    var paper : String!
    var id : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        addtime = dict["addtime"] as? String
        paper = dict["paper"] as? String
        id = dict["id"] as? String
    }
    
}
