//
//  XJTSocketManager.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTSocketManager.h"

@implementation XJTSocketManager
+ (XJTSocketManager *)sharedXJTSocketManager {
    static XJTSocketManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJTSocketManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_socket setAutoDisconnectOnClosedReadStream:NO];
    }
    return self;
}
- (BOOL)connectHost:(NSString *)address port:(uint16_t)port {
    if (_socket.isConnected) {
        [_socket disconnect];
    }
    NSError *error;
    BOOL isConnected = [_socket connectToHost:address onPort:port error:&error];
    return isConnected;
}
- (void)writeDataToService:(NSData *)data {
    [self.socket writeData:data withTimeout:- 1 tag:0];
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:- 1 tag:0];
}

#pragma mark - Async socket delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:@"XJTIPAddress"];
    if (self.connectBlock) {
        self.connectBlock();
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    [sock readDataWithTimeout:- 1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
}

@end
