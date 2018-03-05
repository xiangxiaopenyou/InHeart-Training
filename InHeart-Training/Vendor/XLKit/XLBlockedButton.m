//
//  XLBlockedButton.m
//  DongDong
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLBlockedButton.h"

@interface XLBlockedButton()
@property (copy, nonatomic) ButtonBlocked block;

@end

@implementation XLBlockedButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        if (color) {
            [self setTitleColor:color forState:UIControlStateNormal];
        }
        if (font) {
            self.titleLabel.font = font;
        }
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
        }
        
    }
    return self;
}

- (void)addEventHandler:(ButtonBlocked)handler event:(UIControlEvents)event {
    self.block = [handler copy];
    [self addTarget:self action:@selector(actionSelector:) forControlEvents:event];
}
- (void)actionSelector:(id)sender {
    if (self.block) {
        self.block(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
