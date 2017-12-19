//
//  PeiXun.swift
//  GST_SY
//
//  Created by Don on 16/8/16.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
class PeiXun :NSObject{
    
    var content : String!
    var id : String!
    var imgUrl : String!
    var imgUrlS : String!
    var pid : String!
    var time : String!
    var title : String!
    var videoUrl : String!
    var viewCount : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dict: [String: AnyObject]){
        content = dict["content"] as? String
        id = dict["id"] as? String
        imgUrl = dict["img_url"] as? String
        imgUrlS = dict["img_url_s"] as? String
        pid = dict["pid"] as? String
        time = dict["time"] as? String
        title = dict["title"] as? String
        videoUrl = dict["video_url"] as? String
        viewCount = dict["view_count"] as? String
    }
    
}
