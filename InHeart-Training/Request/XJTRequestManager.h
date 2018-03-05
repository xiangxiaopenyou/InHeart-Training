//
//  XJTRequestManager.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface XJTRequestManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
