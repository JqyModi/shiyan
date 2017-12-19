//
//  SMSSDK-Bridging-Header.h
//  GST_SY
//
//  Created by Don on 16/8/31.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  SMSSDK-Bridging-Header.h
//  SMS-SDK(swift)
//
//  Created by lisk@uuzu.com on 15/9/6.
//  Copyright (c) 2015年 MOB. All rights reserved.
//

#ifndef SMS_SDK_swift__SMSSDK_Bridging_Header_h
#define SMS_SDK_swift__SMSSDK_Bridging_Header_h

//导入SMS-SDK的头文件
#import <SMS_SDK/SMSSDK.h>
//关闭访问通讯录需要导入的头文件
//#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import <WXApi.h>
//新浪微博SDK头文件<
//#import <WeiboSDK.h>
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加”-ObjC”

#endif /* SMSSDK_Bridging_Header_h */


#import "XKeyBoard.h"
//#import "UITableView+FDTemplateLayoutCell.h"

#import "SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

//BUG收集
#import <Bugly/Bugly.h>

