//
//  XJTBaseRequest.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTBaseRequest.h"
#import "XJTRequestManager.h"

@implementation XJTBaseRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
            NSString *userToken = [[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN];
            [self.params setObject:userToken forKey:@"token"];
        }
    }
    return self;
}
- (void)postRequest:(NSDictionary *)dictionaryParams requstURLString:(NSString *)urlString result:(RequestResultHandler)handler {
    [self.params addEntriesFromDictionary:dictionaryParams];
    [[XJTRequestManager sharedInstance] POST:urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !handler ?: handler(responseObject[@"data"], nil);
        } else {
            !handler ?: handler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !handler ?: handler(nil, XJTNetworkErrorTip);
    }];
}

@end
