//
//  XJTUtilities.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJTUtilities : NSObject
+ (BOOL)isLogin;
+ (NSString *)hexStringFromString:(NSString *)str;
+ (NSInteger)hexByDecimal:(NSInteger)decimal;
+ (NSInteger)numberWithHexString:(NSString *)hexString;
+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (BOOL)checkIPAddress:(NSString *)address;
+ (void)showHUDWithMessage:(NSString *)message;
+ (void)hideHUD;
+ (void)showHUDTip:(BOOL)isSuccess message:(NSString *)message;
@end
