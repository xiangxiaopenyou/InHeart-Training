//
//  XJTBaseRequest.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef BOOL (^ParamsBlock)(id request);
typedef void (^RequestResultHandler)(id object, NSString *msg);

@interface XJTBaseRequest : NSObject
@property (strong, nonatomic) NSMutableDictionary *params;
- (void)postRequest:(NSDictionary *)dictionaryParams requstURLString:(NSString *)urlString result:(RequestResultHandler)handler;

@end
