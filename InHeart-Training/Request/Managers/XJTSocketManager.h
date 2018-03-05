//
//  XJTSocketManager.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GCDAsyncSocket.h>

typedef void(^XJTSocketManagerConnectBlock)(void);

@interface XJTSocketManager : NSObject <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (copy, nonatomic) XJTSocketManagerConnectBlock connectBlock;

+ (XJTSocketManager *)sharedXJTSocketManager;
- (BOOL)connectHost:(NSString *)address port:(uint16_t)port;
- (void)writeDataToService:(NSData *)data;

@end
