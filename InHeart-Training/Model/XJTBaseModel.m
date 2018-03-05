//
//  XJTBaseModel.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/16.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTBaseModel.h"

@implementation XJTBaseModel
+ (NSArray *)setupWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJTBaseModel *model = [self yy_modelWithDictionary:obj];
        [resultArray addObject:model];
    }];
    return resultArray;
}

@end
