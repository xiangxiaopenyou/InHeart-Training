//
//  XLBlockedButton.h
//  DongDong
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ButtonBlocked) (id sender);

@interface XLBlockedButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font image:(UIImage *)image;
- (void)addEventHandler:(ButtonBlocked)handler event:(UIControlEvents)event;

@end
