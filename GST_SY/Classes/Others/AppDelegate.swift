//
//  AppDelegate.swift
//  GST_SY
//
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var blockRotation: Bool = false
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
       
        /*是否进入引导页*/
        
        if !UserDefaults.standard.bool(forKey: YMFirstLaunch) {
            window?.rootViewController = YMNewfeatureViewController()
            UserDefaults.standard.set(true, forKey: YMFirstLaunch)
        } else {
            window?.rootViewController = YMTabBarController()
        }
//        window?.rootViewController = YMTabBarController()
   
//        SMSSDK.registerApp("11aee97e4d4ec", withSecret: "8be3985767da866344b8d4ffa8bd173e")
   
        /**
         *  初始化ShareSDK应用
         *
         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
         */
        ShareSDK.registerActivePlatforms([
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.typeWechat.rawValue,
            SSDKPlatformType.typeQQ.rawValue,
            SSDKPlatformType.typeCopy.rawValue
            ], onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                    //                case SSDKPlatformType.TypeSinaWeibo:
                //                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        }, onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
            switch platform
            {
                //                case SSDKPlatformType.TypeSinaWeibo:
                //                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                //                    appInfo?.SSDKSetupSinaWeiboByAppKey("568898243",
                //                        appSecret: "38a4f8204cc784f81f9f0daaf31e02e3",
                //                        redirectUri: "http://www.sharesdk.cn",
                //                        authType: SSDKAuthTypeBoth)
            //
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wxbaed711f77d41333",
                                         appSecret: "78923017530e268d4b242f518144fba8")
            case SSDKPlatformType.typeQQ:
                //设置QQ应用信息: 1106264158 ：Edi92Ta7O8HuydpU
                appInfo?.ssdkSetupQQ(byAppId: "100371282",
                                     appKey: "aed9b0303e3ed1e27bae87c33761161d",
                                     authType: SSDKAuthTypeWeb)
            default:
                break
            }
        })
    
//        SMSSDK.enableAppContactFriends(false)
        
        //初始化腾讯bug收集
        Bugly.start(withAppId: BUGAPPID)
    
        return true
    }

    func setupWithStatusBar(_ application: UIApplication) {
    
        application.isStatusBarHidden = true;
        application.setStatusBarHidden(true, with: UIStatusBarAnimation.fade);
  
        application.statusBarStyle = UIStatusBarStyle.lightContent;
        application.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true);
    }
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        if self.blockRotation{
//            return UIInterfaceOrientationMask.All
//        } else {
//            return UIInterfaceOrientationMask.Portrait
//        }
//        
//        
//    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

