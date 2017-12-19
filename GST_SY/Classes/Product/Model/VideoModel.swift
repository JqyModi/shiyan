//
//  VideoModel.swift
//  GST_SY
//
//  Created by Don on 16/8/8.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import Foundation
import SwiftyJSON
class VideoModel : NSObject{
    
    var cateid : String!
    var gradeid : String!
    var id : String!
    var imgUrl : String!
    var imgUrlS : String!
    var name : String!
    var remark : String!
    var time : String!
    var videoUrl : String!
    var viewCount : String!
    var videoid : String!
    var videostate: String!
    
   init(dict: [String: AnyObject]) {
        super.init()
        cateid = dict["cateid"] as? String
        gradeid = dict["gradeid"] as? String
        id = dict["id"] as? String
        imgUrl = dict["img_url"] as? String
        imgUrlS = dict["img_url_s"] as? String
        name = dict["name"] as? String
        remark = dict["remark"] as? String
        time = dict["time"] as? String
        videoUrl = dict["video_url"] as? String
        viewCount = dict["view_count"] as? String
        videoid = dict["video_id"] as? String
        videostate = dict["video_state"] as? String
    }
    
    
    

    
    
}
