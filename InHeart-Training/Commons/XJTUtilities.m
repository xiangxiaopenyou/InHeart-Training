//
//  XJTUtilities.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTUtilities.h"
#import <MBProgressHUD.h>

@implementation XJTUtilities
+ (BOOL)isLogin {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERTOKEN]) {
        return YES;
    }
    return NO;
}
+ (NSString *)hexStringFromString:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    NSString *tempString = [string copy];
    NSInteger cha = 30 - tempString.length;
    for (NSInteger i = 0; i < cha; i ++) {
        tempString = [tempString stringByAppendingString:@"0"];
    }
    return tempString;
}
+ (NSInteger)hexByDecimal:(NSInteger)decimal {
    NSString *hex = @"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i < 9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex.integerValue;
}
+ (NSInteger)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (BOOL)checkIPAddress:(NSString *)address {
    NSString *pattern = @"^((25[0-5]|2[0-4]\\d|[1]{1}\\d{1}\\d{1}|[1-9]{1}\\d{1}|\\d{1})($|(?!\\.$)\\.)){4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:address];
}
+ (void)showHUDWithMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:XJTKeyWindow animated:YES];
    hud.square = YES;
    hud.label.text = message;
}
+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:XJTKeyWindow animated:YES];
}
+ (void)showHUDTip:(BOOL)isSuccess message:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:XJTKeyWindow animated:YES];
    hud.detailsLabel.text = message;
    UIImageView *customImage = [[UIImageView alloc] init];
    customImage.image = isSuccess ? [UIImage imageNamed:@"success_tip"] : [UIImage imageNamed:@"error_tip"];
    hud.customView = customImage;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
