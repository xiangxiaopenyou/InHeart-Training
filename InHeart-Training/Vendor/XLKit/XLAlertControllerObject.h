//
//  XLAlertControllerObject.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/27.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^XLAlertControllerEnsureBlock)(void);

@interface XLAlertControllerObject : NSObject
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelString ensureTitle:(NSString *)ensureString ensureBlock:(XLAlertControllerEnsureBlock)block;

@end
