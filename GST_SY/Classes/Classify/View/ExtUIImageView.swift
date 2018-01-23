import Foundation
import UIKit
import AVFoundation

extension UIImageView{
    
    //获取网络视频截图：链接默认需要https的如果要使用http则需要在info.plist中添加如下配置：
//    1、在Info.plist中添加 NSAppTransportSecurity 类型 Dictionary ;
//    2、在 NSAppTransportSecurity 下添加 NSAllowsArbitraryLoads 类型Boolean ,值设为 YES
    
    func getNetWorkVidoeImage(_ url:String){
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            
            //需要长时间处理的代码
            
            let asset = AVURLAsset(url:URL(string: url)!)
            
            let generator = AVAssetImageGenerator(asset: asset)
            
            generator.appliesPreferredTrackTransform=true
            
            let time = CMTimeMakeWithSeconds(10.0,600)
            
            var actualTime = CMTimeMake(0, 0)
            //            varactualTime : CMTime = CMTimeMake(0,0)
            
            var image:CGImage!
            
            do{
                image = try generator.copyCGImage(at: time, actualTime: &actualTime)
            }catch let error as NSError{
                debugPrint("error === \(error)")
            }
            DispatchQueue.main.async(execute: {
                
                //需要主线程执行的代码
                if image != nil {
                    self.image = UIImage(cgImage: image)
                }else{
                    debugPrint("image为nil")
                    return
                }
                
                
            })
        })
    }
}

//扩展之后可以直接使用原来的类：已经新增了扩展以后的方法

//class MyImg: UIImageView {
//    override init(image: UIImage?) {
//        debugPrint("我是构造函数")
//        super.init(image: image)
//        self.getNetWorkVidoeImage(url: String)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


















