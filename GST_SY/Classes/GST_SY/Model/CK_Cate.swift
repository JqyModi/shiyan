//
//  CK_Cate.swift
//  GST_SY
//
//  Created by Don on 16/9/9.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation


class CK_Cate : NSObject{
    
    var id : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]) {

        id = dict["id"] as? String
        name = dict["name"] as? String
}
}
