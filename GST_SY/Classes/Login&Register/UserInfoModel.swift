//
//  User.swift
//  GST_SY
//
//  Created by Don on 16/8/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
class UserInfoModel : NSCoder {
    
    var accessToken : String!
    var avatar : String!
    var id : String!
    var name : String!
    var nickname : String!
    var school : AnyObject!
    var sex : String!
    var status : String!
    var type : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        accessToken = dict["accessToken"] as? String
        avatar = dict["avatar"] as? String
        id = dict["id"] as? String
        name = dict["name"] as? String
        nickname = dict["nickname"] as? String
        school = dict["school"] as? String as AnyObject!
        sex = dict["sex"] as? String
        status = dict["status"] as? String
        type = dict["type"] as? String
    }
    
}
