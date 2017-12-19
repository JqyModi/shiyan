//
//  WenKu.swift
//  GST_SY
//
//  Created by Don on 16/8/16.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
class WenKu :NSObject{
    
    var cateid : String!
    var fileUrl : String!
    var id : String!
    var imgUrl : String!
    var imgUrlS : String!
    var time : String!
    var title : String!
    var viewCount : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        cateid = dict["cateid"] as? String
        fileUrl = dict["file_url"] as? String
        id = dict["id"] as? String
        imgUrl = dict["img_url"] as? String
        imgUrlS = dict["img_url_s"] as? String
        time = dict["time"] as? String
        title = dict["title"] as? String
        viewCount = dict["view_count"] as? String
    }
    
}
