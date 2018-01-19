//
//  YMNetworkTool.swift
//  GST_SY
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Toaster
//import JLToast
class YMNetworkTool: NSObject {
    
    static let shareNetworkTool = YMNetworkTool()
    
    
    func loadHomeInfo(_ id: Int, finished:@escaping (_ homeItems: [YMHomeItem]) -> ()) {
        //        let url = BASE_URL + "v1/channels/\(id)/items?gender=1&generation=1&limit=20&offset=0"
        let url = BASE_URL + "v1/channels/\(id)/items"
        let params = ["gender": 1,
                      "generation": 1,
                      "limit": 20,
                      "offset": 0]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                let data = dict["data"].dictionary
                
                if let items = data!["items"]?.arrayObject {
                    var homeItems = [YMHomeItem]()
                    for item in items {
                        let homeItem = YMHomeItem(dict: item as! [String: AnyObject])
                        homeItems.append(homeItem)
                    }
                    finished(homeItems)
                }
            }
        }
    }
    
    
    func loadHomeTopData(_ finished:@escaping (_ ym_channels: [YMChannel]) -> ()) {
        
        let url = BASE_URL + "v2/channels/preset"
        let params = ["gender": 1,
                      "generation": 1]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                //                    SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                let data = dict["data"].dictionary
                if let channels = data!["channels"]?.arrayObject {
                    var ym_channels = [YMChannel]()
                    for channel in channels {
                        let ym_channel = YMChannel(dict: channel as! [String: AnyObject])
                        ym_channels.append(ym_channel)
                    }
                    finished(ym_channels)
                }
            }
        }
    }
    
    
    func loadHotWords(_ finished:@escaping (_ words: [String]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/search/hot_words"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionary {
                    if let hot_words = data["hot_words"]?.arrayObject {
                        finished(hot_words as! [String])
                    }
                }
            }
        }
    }
    
    func loadSearchResult(_ keyword: String, sort: String, finished:@escaping (_ results: [YMSearchRs]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        //modi 获取搜索到的资源
        //let url = "http://api.GST_SYapp.com/v1/search/item"
        let url = "http://www.shiyan360.cn/index.php/api/appsearch"
        
        //        let params = ["keyword": keyword,
        //                      "limit": 20,
        //                      "offset": 0,
        //                      "sort": sort]
        let params = ["keyword":keyword,
                      "p":1] as [String : Any]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                //返回数据格式如下
                //                    {success: true, error_code: 0, message: "数据加载完毕","data":[{id: "4275", model: "Play", title: "泡菜的制作", url: "/Public/Uploads/Video/20160510/57318c712ce68.mp4"}]}
                
                //                    let dict = JSON(value)
                //                    let code = dict["code"].intValue
                //                    let message = dict["message"].stringValue
                
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].intValue
                let message = dict["message"].stringValue
                //                    let id = dict["id"].intValue
                //                    let model = dict["model"].stringValue
                //                    let title = dict["title"].stringValue
                //                    let url = dict["url"].stringValue
                //进度条显示
                //                    guard success == RETURN_OK else {
                //                        SVProgressHUD.showInfoWithStatus(message)
                //                        return
                //                    }
                guard success == true else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                let data = dict["data"].arrayObject
                //                    if let items = data!["items"]?.arrayObject {
                //                        var results = [YMSearchResult]()
                //                        for item in items {
                //                            let result = YMSearchResult(dict: item as! [String: AnyObject])
                //                            results.append(result)
                //                        }
                //                        finished(results: results)
                //                    }
                var results = [YMSearchRs]()
                for item in data!{
                    let result = YMSearchRs(dict: item as! [String: AnyObject])
                    if result.url == "" {
                        continue
                    }
                    
                    results.append(result)
                }
                //返回数据
                finished(results)
            }
        }
    }
    
    /*
     func loadProductData(_ finished:@escaping (_ products: [YMProduct]) -> ()) {
     SVProgressHUD.show(withStatus: "正在加载...")
     let url = BASE_URL + "v2/items"
     let params = ["gender": 1,
     "generation": 1,
     "limit": 20,
     "offset": 0]
     Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
     guard response.result.isSuccess else {
     SVProgressHUD.showError(withStatus: "加载失败...")
     return
     }
     if let value = response.result.value {
     let dict = JSON(value)
     let code = dict["code"].intValue
     let message = dict["message"].stringValue
     guard code == RETURN_OK else {
     SVProgressHUD.showInfo(withStatus: message)
     return
     }
     SVProgressHUD.dismiss()
     if let data = dict["data"].dictionary {
     if let items = data["items"]?.arrayObject {
     var products = [YMProduct]()
     for item in items {
     if let itemData = item["data"] {
     let product = YMProduct(dict: itemData as! [String: AnyObject])
     
     products.append(product)
     }
     }
     finished(products)
     
     }
     }
     }
     }
     }
     */
    
    func loadProductDetailData(_ id: Int, finished:@escaping (_ productDetail: YMProductDetail) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v2/items/\(id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionaryObject {
                    let productDetail = YMProductDetail(dict: data as [String : AnyObject])
                    finished(productDetail)
                }
            }
        }
    }
    
    
    func loadProductDetailComments(_ id: Int, finished:@escaping (_ comments: [YMComment]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v2/items/\(id)/comments"
        let params = ["limit": 20,
                      "offset": 0]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionary {
                    if let commentsData = data["comments"]?.arrayObject {
                        var comments = [YMComment]()
                        for item in commentsData {
                            let comment = YMComment(dict: item as! [String: AnyObject])
                            comments.append(comment)
                        }
                        finished(comments)
                    }
                }
            }
        }
    }
    
    func loadCategoryCollection(_ limit: Int, finished:@escaping (_ collections: [YMCollection]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/collections"
        let params = ["limit": limit,
                      "offset": 0]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionary {
                    if let collectionsData = data["collections"]?.arrayObject {
                        var collections = [YMCollection]()
                        for item in collectionsData {
                            let collection = YMCollection(dict: item as! [String: AnyObject])
                            collections.append(collection)
                        }
                        finished(collections)
                    }
                }
            }
        }
    }
    
    
    func loadCollectionPosts(_ id: Int, finished:@escaping (_ posts: [YMCollectionPost]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/collections/\(id)/posts"
        let params = ["gender": 1,
                      "generation": 1,
                      "limit": 20,
                      "offset": 0]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionary {
                    if let postsData = data["posts"]?.arrayObject {
                        var posts = [YMCollectionPost]()
                        for item in postsData {
                            let post = YMCollectionPost(dict: item as! [String: AnyObject])
                            posts.append(post)
                        }
                        finished(posts)
                    }
                }
            }
        }
    }
    
    /*
     func loadCategoryGroup(_ finished:@escaping (_ outGroups: [AnyObject]) -> ()) {
     SVProgressHUD.show(withStatus: "正在加载...")
     let url = BASE_URL + "v1/channel_groups/all"
     Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
     guard response.result.isSuccess else {
     SVProgressHUD.showError(withStatus: "加载失败...")
     return
     }
     if let value = response.result.value {
     let dict = JSON(value)
     let code = dict["code"].intValue
     let message = dict["message"].stringValue
     guard code == RETURN_OK else {
     SVProgressHUD.showInfo(withStatus: message)
     return
     }
     SVProgressHUD.dismiss()
     if let data = dict["data"].dictionary {
     if let channel_groups = data["channel_groups"]?.arrayObject {
     
     var outGroups = [AnyObject]()
     for channel_group in channel_groups {
     var inGroups = [YMGroup]()
     let channels = channel_group["channels"] as! [AnyObject]
     for channel in channels {
     let group = YMGroup(dict: channel as! [String: AnyObject])
     inGroups.append(group)
     }
     outGroups.append(inGroups as AnyObject)
     }
     finished(outGroups)
     }
     }
     }
     }
     }
     */
    
    func loadStylesOrCategoryInfo(_ id: Int, finished:@escaping (_ items: [YMCollectionPost]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/channels/\(id)/items"
        let params = ["limit": 20,
                      "offset": 0]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                let code = dict["code"].intValue
                let message = dict["message"].stringValue
                guard code == RETURN_OK else {
                    SVProgressHUD.showInfo(withStatus: message)
                    return
                }
                SVProgressHUD.dismiss()
                if let data = dict["data"].dictionary {
                    if let itemsData = data["items"]?.arrayObject {
                        var items = [YMCollectionPost]()
                        for item in itemsData {
                            let post = YMCollectionPost(dict: item as! [String: AnyObject])
                            items.append(post)
                        }
                        finished(items)
                    }
                }
            }
        }
    }
    
    func testPost2(_ desctype : String, categoryid:String,gradeid:String,page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        //http://shiyan360.cn/index.php/api/video_list?desc_type=2&category_id=386&gradeid=408&page=1
        let url = URLSTR + "video_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "gradeid":gradeid,
                      "page":page] as [String : Any]
        print("testPost2  --- > desctype = \(desctype)  :  categoryid = \(categoryid)  :  gradeid = \(gradeid)")
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [VideoModel]()
                    
                    for item in data!{
                        let result = VideoModel(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
            }else{
                SVProgressHUD.showError(withStatus: "数据加载失败请检测网络是否正常")
            }
        }
    }
    
    func getChuangKe(_ desctype : String, categoryid:String, page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        let url = URLSTR + "chuangke_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [VideoModel]()
                    
                    for item in data!{
                        let result = VideoModel(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getWenKu(_ desctype : String, categoryid:String, page:Int,finished:@escaping (_ items: [WenKu]) -> ()) {
        let url = URLSTR + "wenku_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [WenKu]()
                    
                    for item in data!{
                        let dicItem = item as! NSDictionary
                        let url = dicItem.value(forKey: "file_url") as! String
                        if !url.isEmpty {
                            let result = WenKu(dict: item as! [String : AnyObject])
                            results.append(result)
                        }
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    //        获取试卷列表：http://shiyan360.cn/index.php/api/examinPaperList
    //        参数：page
    //        school 学校名称，登录返回来的
    //        banji  班级名称，登录返回来的
    //        nj  年级名称，登录返回的
    //        id 试卷ID
    func getKaoPing(_ school : String, banji:String, nj:String, xueke: String, page:Int,finished:@escaping (_ items: [KaoPing]) -> ()) {
        let url = URLSTR + "examinPaperList"
        let params = ["school": school,
                      "banji": banji,
                      "nj": nj,
                      "id": xueke,
                      "page": page
            ] as [String : Any]
        
        //        data:[{id: "7", paper: "铜、锌、稀硫酸原电池反应", addtime: "1499154274"},…]
        //        error_code:0
        //        message:"数据加载完毕"
        //        success:true
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [KaoPing]()
                    
                    for item in data!{
                        let result = KaoPing(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getPaper(_ paperId: String, finished:@escaping (_ items: [Paper]) -> ()){
        let url = URLSTR + "examinPaperDetail"
        let params = ["id": paperId]
        
        //        data:[{id: "7", paper: "铜、锌、稀硫酸原电池反应", addtime: "1499154274"},…]
        //        error_code:0
        //        message:"数据加载完毕"
        //        success:true
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                var results = [Paper]()
                
                let xcontentJson = dict["xcontent"].dictionaryObject
                if xcontentJson != nil && (xcontentJson?.count)!>0{
                    for item in xcontentJson! {
                        let result = Paper(dict: item.1 as! [String : AnyObject])
                        result.type = "xz"
                        results.append(result)
                    }
                    
                }
                let tcontentJson = dict["tcontent"].dictionaryObject
                if tcontentJson != nil && (tcontentJson?.count)!>0{
                    for item in tcontentJson! {
                        let result = Paper(dict: item.1 as! [String : AnyObject])
                        result.type = "tk"
                        results.append(result)
                    }
                    
                }
                let jcontentJson = dict["jcontent"].dictionaryObject
                if jcontentJson != nil && (jcontentJson?.count)!>0{
                    for item in jcontentJson! {
                        let result = Paper(dict: item.1 as! [String : AnyObject])
                        result.type = "jd"
                        results.append(result)
                    }
                    
                }
                finished(results)
            }
        }
    }
    
    //    3、提交答案到服务器：http://shiyan360.cn/index.php/api/submitPaperJson
    //    参数：json  json字符串包括* cp_id 试卷的序号,
    //    * sid 用户的ID
    //    * title 学生的姓名,
    //    * number 学生的学号,
    //    * hour 做试卷时所用的小时,
    //    * minute 做试卷所用的分钟
    //    * @param map_select 装选择题答案的HashMap
    //    * @param ListALLTAnswer 装填空题答案的List
    //    * @param ListJAnswer 装解答题答案的List
    
    //    {"success":false,"error_code":1,"message":"\u666e\u901a\u9519\u8bef","data":[]}
    func submitAnswer(_ str: String) -> Void{
        let url = URLSTR + "submitPaperJson"
        let params = ["json": str]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                
                if dict["success"].boolValue {
                    Toast(text: "数据提交成功").show()
                }
                else{
                    Toast(text: "数据提交失败").show()
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getKaoShi(_ desctype : String, categoryid:String, page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        
        let url = URLSTR + "kaoshi_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [VideoModel]()
                    
                    for item in data!{
                        let result = VideoModel(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getMingShi(_ desctype : String, categoryid:String, gradeid:String,page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        let url = URLSTR + "mingshi_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "gradeid":gradeid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [VideoModel]()
                    
                    for item in data!{
                        let result = VideoModel(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getPeiXun(_ desctype : String, categoryid:String,page:Int,finished:@escaping (_ items: [PeiXun]) -> ()) {
        let url = URLSTR + "article_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [PeiXun]()
                    
                    for item in data!{
                        let result = PeiXun(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getZhuangBei(_ desctype : String, categoryid:String,page:Int,finished:@escaping (_ items: [PeiXun]) -> ()) {
        let url = URLSTR + "article_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [PeiXun]()
                    
                    for item in data!{
                        let result = PeiXun(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    func getZiXun(_ desctype : String, categoryid:String,page:Int,finished:@escaping (_ items: [ZiXun]) -> ()) {
        let url = URLSTR + "article_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [ZiXun]()
                    
                    for item in data!{
                        let result = ZiXun(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    //会展
    func getHuiZhan(_ desctype : String, categoryid:String,page:Int,finished:@escaping (_ items: [ZiXun]) -> ()) {
        let url = URLSTR + "article_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                let dict = JSON(value)
                //                    print("dict:",dict)
                
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    //                        print("data:",data)
                    var results = [ZiXun]()
                    
                    for item in data!{
                        let result = ZiXun(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
                
            }
        }
    }
    
    //新闻
    func getNews(page:Int = 1,finished:@escaping (_ items: [News]) -> ()) {
        //        http://shiyan360.cn/api/news
        let url = URLSTR + "news"
        let params = ["page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                print("dict:",dict)
                if dict["data"].arrayObject != nil {
                    let data = dict["data"].arrayObject
                    print("data:",data)
                    var results = [News]()
                    for item in data! {
                        let result = News(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
            }
        }
    }
    
    func getExperiment(_ desctype : String, categoryid:String,gradeid:String,page:Int,finished:@escaping (_ items: [Experiment]) -> ()) {
        let url = URLSTR + "experiment_list"
        let params = ["desc_type": desctype,
                      "category_id":categoryid,
                      "gradeid":gradeid,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                if dict["data"].arrayObject != nil{
                    let data = dict["data"].arrayObject
                    var results = [Experiment]()
                    for item in data!{
                        let result = Experiment(dict: item as! [String : AnyObject])
                        results.append(result)
                    }
                    finished(results)
                }
                else{
                    print("暂无内容")
                }
            }else{
                SVProgressHUD.showError(withStatus: "数据加载失败请检测网络是否正常")
            }
        }
    }
    
    func loginResult(_ username: String, userpass: String, school: String = "", finished:@escaping (_ loginValidate: Bool ) -> ())
    {
        var loginValidate : Bool?
        let url = URLSTR + "user_login"
        var params = ["user_name": username,
                      "user_pass":userpass]
        if school != "" {
            params["table"] = school
        }
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let data = dict["data"]
                let message = dict["message"].stringValue
                if success{
                    let accessToken = data["accessToken"].stringValue
                    print("accessToken:",accessToken)
                    print("message:",message)
                    loginValidate = true
                    let userId = data["id"].stringValue
                    
                    let defaults : UserDefaults = UserDefaults.standard
                    defaults.setValue(accessToken, forKey: "accessToken")
                    defaults.setValue(username, forKey: "username")
                    defaults.setValue(userpass, forKey: "userpassMD5")
                    defaults.set(true, forKey: isLogin)
                    defaults.setValue(userId, forKey: "userId")
                    //
                    defaults.setValue(school, forKey: "table")
                    defaults.synchronize()
                    
                }else{
                    
                    print("message:",message)
                    loginValidate = false
                }
                finished(loginValidate!)
                
            }
            
        }
    }
    
    func sendCode(_ username: String, code_type: Int, finished: (_ error_codeMsg: Int) -> ()){
        
    }
    
    func regiestResult(_ username: String, smscode: String, code_type: Int, finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        //        check_code
        let url = URLSTR + "send_code"
        //        let url = URLSTR + "check_code"
        let params = ["user_name": username,
                      "sms_code":smscode,
                      "code_type":code_type] as [String : Any]
        //        let params = ["sms_code":smscode]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(url)
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    
    func setpassResult(_ username: String, smscode: String, userpass:String,finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "user_signup"
        let params = ["user_name": username,
                      "user_code":smscode,
                      "user_pass":userpass
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    //modi 设置密码
    func setpassResult(_ username: String, smscode: String, userpass:String,useremail: String, finished:@escaping (_ error_code: Int, _ msg: String) -> ())
    {
        
        var error_codeMsg : Int?
        let url = URLSTR + "user_signup"
        print("username = \(username)")
        let params = ["user_name": username,
                      "user_email":useremail,
                      "user_pass":userpass
        ]
        print("url === \(url)")
        //        Alamofire.NSURLCache.setSharedURLCache(NSURLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil))
        //        Alamofire.Manager.sharedInstance.session.configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                print("dict --------->\(dict.arrayValue)")
                let data = dict["data"].array
                let error_code = dict["error_code"].int
                let msg = dict["message"].string
                finished(error_code!,msg!)
                
            }
            
        }
        
    }
    
    
    func ck_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "chuangke_category_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value as? NSDictionary{
                
                let datas = value.value(forKey: "data") as! NSArray
                var items = [CK_Cate]()
                
                for dict in datas{
                    let post = CK_Cate(dict: dict as! [String : AnyObject])
                    items.append(post)
                    //                           print("ck cate:：",dict)
                }
                finished(items)
                //                    print("ck cate items",items.count)
            }
            
            
        }
    }
    
    func ks_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "kaoshi_category_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value as? NSDictionary {
                
                
                let datas = value.value(forKey: "data") as! NSArray
                
                var items = [CK_Cate]()
                
                for item in datas {
                    let sub = (item as! NSDictionary).object(forKey: "sub")
                    if sub != nil{
                        for result in sub as! [AnyObject] {
                            let res = CK_Cate(dict: result as! [String : AnyObject])
                            items.append(res)
                        }
                    }
                    finished(items)
                }
                
            }
        }
    }
    
    
    func ms_GdCate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "mingshi_grade_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //                        print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    func ms_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "mingshi_category_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    
    func zb_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "article_category_sub"
        let params = ["id": "135"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"].arrayObject
                
                var results = [CK_Cate]()
                
                for item in data!{
                    print("item:" ,item)
                    let result = CK_Cate(dict: item as! [String : AnyObject])
                    results.append(result)
                }
                finished(results)
                
            }
            
            
        }
    }
    
    
    func wk_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "wenku_category_list"
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"].arrayObject
                
                var results = [CK_Cate]()
                
                for item in data!{
                    print("item:" ,item)
                    let result = CK_Cate(dict: item as! [String : AnyObject])
                    results.append(result)
                }
                finished(results)
                
            }
            
            
        }
    }
    
    func px_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "article_category_sub"
        let params = ["id": "139"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"].arrayObject
                
                var results = [CK_Cate]()
                
                for item in data!{
                    print("item:" ,item)
                    let result = CK_Cate(dict: item as! [String : AnyObject])
                    results.append(result)
                }
                finished(results)
                
            }
            
            
        }
    }
    
    func vd_GdCate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "grade_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //                        print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    
    func vd_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "category_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //                        print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    func exp_GdCate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "experiment_grade_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //                        print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    func exp_Cate_Result(_ finished:@escaping (_ items: [CK_Cate]) -> ())
    {
        let url = URLSTR + "experiment_category_list"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let data = dict["data"]
                let sub = data.array! as [JSON]
                var items = [CK_Cate]()
                for item in sub {
                    let sub = item["sub"].arrayValue
                    //                        print("sub2 :",sub)
                    for result in sub {
                        print("result:" ,result.dictionaryObject)
                        let res = CK_Cate(dict: result.dictionaryObject! as! [String : AnyObject])
                        items.append(res)
                    }
                }
                
                finished(items)
                
            }
            
            
        }
    }
    
    /**
     modi
     获取已经收藏的视频信息
     */
    func collectResult(_ accessToken: String, model: String,id:String, finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "user_collect_add"
        let params = ["accessToken":accessToken,
                      "model":model,
                      "id":id]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                print("collectResult  ---> url ====== \(url)")
                print("collectResult  ---> dict ====== \(dict.arrayValue.description)")
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    func decollectResult(_ accessToken: String, model: String,id:String, finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "user_collect_delete"
        let params = ["accessToken":accessToken,
                      "model":model,
                      "id":id]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    
    func collectList(_ accessToken: String, model: String,page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        
        let url = URLSTR + "user_collect"
        let params = ["accessToken": accessToken,
                      "model":model,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                var dict = JSON(value)
                print("collectList ==== \(dict)")
                if dict["error_code"] == 0{
                    
                    if dict["data"].arrayObject != nil{
                        let data = dict["data"].arrayObject
                        //                        print("data:",data)
                        var results = [VideoModel]()
                        
                        for item in data!{
                            let result = VideoModel(dict: item as! [String : AnyObject])
                            results.append(result)
                        }
                        finished(results)
                    }
                    else{
                        print("暂无内容")
                    }
                }else{
                    print("请重新登录")
                }
            }
        }
    }
    
    //    5a39ffd6986ef-a5a39ffd6986ef9.10347030-b5a39ffd6986ef0.08660714-1694
    func userInfoList(_ accessToken: String,table: String = "", finished:@escaping (_ items: [UserInfoModel]) -> ()) {
        
        let url = URLSTR + "user_profile"
        var params = ["accessToken": accessToken]
        if table != "" {
            params["table"] = table
        }
        //        5a3a05a678424-a5a3a05a6784240.45053935-b5a3a05a6784241.02290804-119
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                var dict = JSON(value)
                print("dict:",dict)
                let success = dict["success"].boolValue
                let message = dict["message"].stringValue
                
                if success{
                    let data1 = dict["data"].dictionaryObject
                    print("data1:",data1)
                    var results = [UserInfoModel]()
                    
                    //                        for item in data1!{
                    let result = UserInfoModel(dict: data1! as [String : AnyObject])
                    //
                    results.append(result)
                    //                        }
                    finished(results)
                    
                }else{
                    print("message",message)
                    print("请重新登录")
                }
            }
        }
    }
    
    func historyList(_ accessToken: String,page:Int,finished:@escaping (_ items: [VideoModel]) -> ()) {
        
        let url = URLSTR + "user_history"
        let params = ["accessToken": accessToken,
                      "page":page] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let value = response.result.value {
                var dict = JSON(value)
                if dict["error_code"] == 0{
                    
                    if dict["data"].arrayObject != nil{
                        let data = dict["data"].arrayObject
                        //                        print("data:",data)
                        var results = [VideoModel]()
                        
                        for item in data!{
                            let result = VideoModel(dict: item as! [String : AnyObject])
                            results.append(result)
                        }
                        finished(results)
                    }
                    else{
                        print("暂无内容")
                    }
                }else{
                    print("请重新登录")
                    Toast(text: "请重新登录").show()
                }
            }
        }
    }
    
    
    func clearHistoryResult(_ accessToken: String,finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "user_history_clear"
        let params = ["accessToken":accessToken]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    
    func changepassResult(_ accessToken: String,old_pass: String,new_pass: String,table: String = "", finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "change_pass"
        var params = ["accessToken":accessToken,
                      "old_pass":old_pass,
                      "new_pass":new_pass]
        if table != "" {
            params["table"] = table
        }
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    
    func resetpassResult(_ username: String, smscode: String, userpass:String,finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "find_pass"
        let params = ["user_name": username,
                      "user_code":smscode,
                      "user_pass":userpass
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
            
        }
    }
    
    func feedbackResult(_ content: String,name: String,tel: String,email: String,qq: String,finished:@escaping (_ error_codeMsg: Int ) -> ())
    {
        var error_codeMsg : Int?
        let url = URLSTR + "guestbook"
        let params = ["content":content,
                      "name":name,
                      "tel":tel,
                      "email":email,
                      "qq":qq,]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let error_code = dict["error_code"].int
                let message = dict["message"].stringValue
                if success{
                    error_codeMsg = error_code
                    print("error_code:",error_code)
                    SVProgressHUD.showProgress(0.5, status: message)
                    
                }else{
                    error_codeMsg = error_code
                }
                finished(error_codeMsg!)
                
            }
        }
    }
    
    
    func getSchoolList(finished: @escaping (_ result: [SchoolModel]?) -> ()) {
        let url = URLSTR + "getAllSchool"
        var error_codeMsg : Int?
        
        var schools = [SchoolModel]()
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let dict = JSON(value)
                let success = dict["success"].boolValue
                let message = dict["message"].stringValue
                let data = dict["data"].arrayObject
                if let list = data as? [[String : String]] {
                    //                    SVProgressHUD.showProgress(0.5, status: message)
                    debugPrint("list -----> \(list)")
                    
                    for item in list {
                        let schoolModel = SchoolModel(dict: item)
                        schools.append(schoolModel)
                    }
                    finished(schools)
                }
                finished(nil)
            }
        }
    }
    
    
}

