//
//  Experiment.swift
//  GST_SY
//
//  Created by Don on 16/8/23.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
class Experiment : NSObject{
    
    var cateid : String!
    var gradeid : String!
    var html5Url : String!
    var id : String!
    var imgUrl : String!
    var imgUrlS : String!
    var name : String!
    var remark : String!
    var time : String!
    var viewCount : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        cateid = dict["cateid"] as? String
        gradeid = dict["gradeid"] as? String
        html5Url = dict["html5_url"] as? String
        id = dict["id"] as? String
        imgUrl = dict["img_url"] as? String
        imgUrlS = dict["img_url_s"] as? String
        name = dict["name"] as? String
        remark = dict["remark"] as? String
        time = dict["time"] as? String
        viewCount = dict["view_count"] as? String
    }
}
