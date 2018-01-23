//import Foundation
//import Alamofire
//import SVProgressHUD
//import SwiftyJSON
//import JLToast
//
//extension Alamofire.Manager{
//    @discardableResult
//    
//    open func requestWithoutCache(
//        _ url: URLConvertible,
//          method: HTTPMethod = .get,
//          parameters: Parameters? = nil,
//          encoding: ParameterEncoding = URLEncoding.default,
//        headers: HTTPHeaders? = nil)
//        -> DataRequest
//    {
//        do {
//            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
//            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
//            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
//            return request(encodedURLRequest)
//        } catch {
//            debugPrint(error)
//            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
//        }
//    }
//}
