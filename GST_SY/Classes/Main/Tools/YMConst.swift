//
//  YMConst.swift
//  GST_SY
//
import UIKit

enum YMTopicType: Int {

    case selection = 4

    case food = 14

    case household = 16

    case digital = 17

    case goodThing = 13

    case grocery = 22
}

enum YMShareButtonType: Int {

    case weChatTimeline = 0

    case weChatSession = 1

    case weibo = 2

    case qZone = 3

    case qqFriends = 4

    case copyLink = 5
}

enum YMOtherLoginButtonType: Int {

    case weiboLogin = 100

    case weChatLogin = 101

    case qqLogin = 102
}

let BASE_URL = "http://api.GST_SYapp.com/"

//let URLSTR="http://www.shiyan360.cn/index.php/api/"
//去掉www否则会导致数据重定向而访问两次数据：一直返回请输入数据错误
let URLSTR="http://shiyan360.cn/index.php/api/"
let YMFirstLaunch = "firstLaunch"

let HOST = "http://shiyan360.cn"

let isLogin = "isLogin"

let BUGAPPID = "3a1f6c6701"

let RETURN_OK = 200

let kMargin: CGFloat = 10.0

let kCornerRadius: CGFloat = 5.0

let klineWidth: CGFloat = 1.0

let kIndicatorViewH: CGFloat = 2.0

let kNewFeatureCount = 4

let kTitlesViewH: CGFloat = 35

let kTitlesViewY: CGFloat = 64

let kAnimationDuration = 0.25

let SCREENW = UIScreen.main.bounds.size.width

let SCREENH = UIScreen.main.bounds.size.height

// 状态栏(statusbar)
let statusH = UIApplication.shared.statusBarFrame.height

// 导航栏（navigationbar）
//let navH = 

let kitemH: CGFloat = 75

let kitemW: CGFloat = 150

let kYMMineHeaderImageHeight: CGFloat = 200

let kTopViewH: CGFloat = 230
//SMSSDK.registerApp("11aee97e4d4ec", withSecret: "8be3985767da866344b8d4ffa8bd173e")
let APPKEY = "11aee97e4d4ec"
let APPSECRET = "8be3985767da866344b8d4ffa8bd173e"

//定义一个全局变量用来存储用户操作试题时的答案
let PaperAnswers = NSMutableDictionary()


func YMColor(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}


func YMGlobalColor() -> UIColor {
    return YMColor(240, g: 240, b: 240, a: 1)
}


func YMGlobalRedColor() -> UIColor {
    return YMColor(245, g: 80, b: 83, a: 1.0)
}

func YMGlobalGreenColor() -> UIColor {
    return YMColor(51, g: 153, b: 255, a: 1.0)
}

func YMGlobalGreenColor1() -> UIColor {
    return YMColor(169, g: 225, b: 48, a: 1.0)
}

func GSTGlobalBgColor() -> UIColor {
    return YMColor(235, g: 235, b: 235, a: 1.0)
}

func GSTGlobalFontColor() -> UIColor {
    return YMColor(77, g: 77, b: 77, a: 1.0)
}

func GSTGlobalFontBigSize() -> CGFloat {
    return 18
}

func GSTGlobalFontMiddleSize() -> CGFloat {
    return 16
}

func GSTGlobalFontSmallSize() -> CGFloat {
    return 14
}


let isIPhone5 = SCREENH == 568 ? true : false

let isIPhone6 = SCREENH == 667 ? true : false

let isIPhone6P = SCREENH == 736 ? true : false
