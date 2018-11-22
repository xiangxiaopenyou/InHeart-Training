//
//  XJTSocketManager.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GCDAsyncSocket.h>
@protocol XJTSocketManagerDelegate<NSObject>
- (void)socketServerDidConnect;
@end

@interface XJTSocketManager : NSObject <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, copy) void (^receivedBlock)(NSDictionary *dictionary);
//@property (nonatomic, copy) void (^disconnectedBlock)(void);
@property (nonatomic, weak) id<XJTSocketManagerDelegate> delegate;

+ (XJTSocketManager *)sharedXJTSocketManager;
- (BOOL)connectHost:(NSString *)address port:(uint16_t)port;
- (void)disconnect;
- (void)writeDataToService:(NSData *)data;

@end
