//
//  XLAlertControllerObject.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/27.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLAlertControllerObject.h"
#import <UIKit/UIKit.h>

@implementation XLAlertControllerObject
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelString ensureTitle:(NSString *)ensureString ensureBlock:(XLAlertControllerEnsureBlock)block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    if (ensureString) {
        UIAlertAction *playAction = [UIAlertAction actionWithTitle:ensureString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            block();
        }];
        [alertController addAction:playAction];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
