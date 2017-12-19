//
//  YMShareButtonView.swift
//  GST_SY
//

import UIKit

class YMShareButtonView: UIView {
  
    let images = ["Share_WeChatTimelineIcon_70x70_", "Share_WeChatSessionIcon_70x70_", "Share_WeiboIcon_70x70_", "Share_QzoneIcon_70x70_", "Share_QQIcon_70x70_", "Share_CopyLinkIcon_70x70_"]

    let titles = ["微信朋友圈", "微信好友", "微博", "QQ 空间", "QQ 好友", "复制链接"]
    
//    let images = ["Share_QzoneIcon_70x70_", "Share_QQIcon_70x70_", "Share_CopyLinkIcon_70x70_"]
//    
//    let titles = ["QQ 空间", "QQ 好友", "复制链接"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        let maxCols = 3
        
        let buttonW: CGFloat = 70
        let buttonH: CGFloat = buttonW + 30
        let buttonStartX: CGFloat = 20
        let xMargin: CGFloat = (SCREENW - 20 - 2 * buttonStartX - CGFloat(maxCols) * buttonW) / CGFloat(maxCols - 1)
        
       
        for index in 0..<images.count {
            let button = YMVerticalButton()
            button.tag = index
            button.setImage(UIImage(named: images[index]), for: UIControlState())
            button.setTitle(titles[index], for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.width = buttonW
            button.height = buttonH
            button.addTarget(self, action: #selector(shareButtonClick(_:)), for: .touchUpInside)
            
        
            let row = Int(index / maxCols)
            let col = index % maxCols
            let buttonX: CGFloat = CGFloat(col) * (xMargin + buttonW) + buttonStartX
            let buttonMaxY: CGFloat = CGFloat(row) * buttonH
            let buttonY = buttonMaxY
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            addSubview(button)
        }
    }
    
    func shareButtonClick(_ button: UIButton) {
        if let shareButtonType = YMShareButtonType(rawValue: button.tag) {
            
            // 1.创建分享参数
            let shareParames = NSMutableDictionary()
            shareParames.ssdkSetupShareParams(byText: "分享内容",
                                              images : UIImage(named: "q_code"),
                                              url : URL(string:"http://qq.com"),
                                              title : "分享标题",
                                              type : SSDKContentType.image)

            
            switch shareButtonType {
            case .weChatTimeline:
                //分享到微信朋友圈
//                ShareSDK
                ShareSDK.share(SSDKPlatformType.subTypeWechatTimeline, parameters: shareParames, onStateChanged: { (respState, nil, entity, error) in
                    print("分享回调")
                    
                    switch respState{
                        
                    case SSDKResponseState.success: print("分享成功")
                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                    case SSDKResponseState.cancel:  print("操作取消")
                        
                    default:
                        break
                    }
                    
                })
                break
            case .weChatSession:
                //分享到微信好友
                ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: shareParames, onStateChanged: { (respState, nil, entity, error) in
                    print("分享回调")
                    
                    switch respState{
                        
                    case SSDKResponseState.success: print("分享成功")
                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                    case SSDKResponseState.cancel:  print("操作取消")
                        
                    default:
                        break
                    }
                    
                })
                break
            case .weibo:
                //分享到微博
                break
            case .qZone:
                //分享到QQ空间
                // 1.创建分享参数
                let shareParames = NSMutableDictionary()
                shareParames.ssdkSetupShareParams(byText: "分享内容",
                                                        images : nil,
                                                        url : URL(string:"http://qzone.qq.com/"),
                                                        title : "分享标题",
                                                        type : SSDKContentType.auto)
                ShareSDK.share(SSDKPlatformType.subTypeQZone, parameters: shareParames, onStateChanged: { (respState, nil, entity, error) in
                    print("分享回调")
                    
                    switch respState{
                        
                    case SSDKResponseState.success: print("分享成功")
                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                    case SSDKResponseState.cancel:  print("操作取消")
                        
                    default:
                        break
                    }
                    
                })
                break
            case .qqFriends:
                //分享到QQ好友
                //2.进行分享
                //2.进行分享
//                ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
//                    
//                    switch state{
//                        
//                    case SSDKResponseState.success: print("分享成功")
//                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
//                    case SSDKResponseState.cancel:  print("操作取消")
//                        
//                    default:
//                        break
//                    }
//                    
//                }
                ShareSDK.share(SSDKPlatformType.typeQQ, parameters: shareParames, onStateChanged: { (respState, nil, entity, error) in
                    print("分享回调")
                    
                    switch respState{
                        
                    case SSDKResponseState.success: print("分享成功")
                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                    case SSDKResponseState.cancel:  print("操作取消")
                        
                    default:
                        break
                    }
                    
                })
                break
            case .copyLink:
                //复制链接
                // 1.创建分享参数
                let shareParames = NSMutableDictionary()
                shareParames.ssdkSetupShareParams(byText: "分享内容",
                                                        images : nil,
                                                        url : nil,
                                                        title : "分享标题",
                                                        type : SSDKContentType.auto)
                ShareSDK.share(SSDKPlatformType.typeCopy, parameters: shareParames, onStateChanged: { (respState, nil, entity, error) in
                    print("分享回调")
                    
                    switch respState{
                        
                    case SSDKResponseState.success: print("分享成功")
                    case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
                    case SSDKResponseState.cancel:  print("操作取消")
                        
                    default:
                        break
                    }
                    
                })
                break
            }
        }
        print(button.titleLabel!.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
