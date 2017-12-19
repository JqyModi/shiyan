//
//  YMSearchResult.swift
//  GST_SY
//
//

import UIKit

//class YMSearchResult: NSObject {
//
//    var favorites_count: Int?
//
//    var likes_count: Int?
//
//    var id: Int?
//
//    var price: String?
//
//    var liked: Bool?
//
//    var cover_image_url: String?
//
//    var describe: String?
//
//    var name: String?
//    
//    init(dict: [String: AnyObject]) {
//        id = dict["id"] as? Int
//        name = dict["name"] as? String
//        favorites_count = dict["favorites_count"] as? Int
//        price = dict["price"] as? String
//        liked = dict["liked"] as? Bool
//        cover_image_url = dict["cover_image_url"] as? String
//        describe = dict["description"] as? String
//    }
//}

//"data":[{id: "4275", model: "Play", title: "泡菜的制作", url: "/Public/Uploads/Video/20160510/57318c712ce68.mp4"}
class YMSearchRs:NSObject{
    var id : Int?
    var model : String?
    var title : String?
    var url:String?
    var img:String?
    init(dict: [String: AnyObject]) {
        id = dict["id"] as? Int
        model = dict["model"] as? String
        title = dict["title"] as? String
        url = dict["url"] as? String
        img = dict["img"] as? String 
    }
}
