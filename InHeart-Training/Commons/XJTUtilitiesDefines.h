//
//  XJTUtilitiesDefines.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTUtilities.h"

//判断登录状态
#define XJTIsLogin [XJTUtilities isLogin]

//string转换成十六进制字符串
#define XJTHexStringFromString(aString) [XJTUtilities hexStringFromString:aString]

//十进制转十六进制
#define XJTHexByDecimal(aDecimal) [XJTUtilities hexByDecimal:aDecimal]

//十六进制字符串转数字
#define XJTNumberWithHexString(aString) [XJTUtilities numberWithHexString:aString]

//NSData转换成十六进制字符串
#define XJTConvertDataToHexStr(aData) [XJTUtilities convertDataToHexStr:aData]

//系统字体
#define XJTSystemFont(x) [UIFont systemFontOfSize:x]
#define XJTBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]

/**
 *  RGB颜色
 */
#define XJTRGBColor(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 *  Hex颜色转RGB颜色
 */
#define XJTHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//验证IP地址
#define XJTCheckIPAddress(aString) [XJTUtilities checkIPAddress:aString]

//主界面
#define XJTKeyWindow [UIApplication sharedApplication].keyWindow

