//
//  XJTSocketManager.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTSocketManager.h"
@interface XJTSocketManager ()
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, assign) uint16_t port;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSTimer *timer;
@end

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
    _port = port;
    _ipAddress = address;
    if (self.socket.isConnected) {
        [self.socket disconnect];
    }
    NSError *error;
    BOOL isConnected = [self.socket connectToHost:address onPort:port error:&error];
    return isConnected;
}
- (void)disconnect {
    if ([self.socket isConnected]) {
        [self.socket disconnect];
        _isRunning = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)writeDataToService:(NSData *)data {
    [self.socket writeData:data withTimeout:- 1 tag:0];
}

#pragma mark - Async socket delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:@"XJTIPAddress"];
    _isRunning = YES;
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:- 1 tag:0];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSData *data = [@"KEEP\r\n" dataUsingEncoding:NSUTF8StringEncoding];
        [self writeDataToService:data];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketServerDidConnect)]) {
        [self.delegate socketServerDidConnect];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (temp) {
        if (self.receivedBlock) {
            self.receivedBlock(temp);
        }
    }
    [self.socket readDataWithTimeout:- 1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self.socket readDataWithTimeout:- 1 tag:0];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.timer invalidate];
    self.timer = nil;
    if (_ipAddress && _port && _isRunning) {
        BOOL success = [self.socket connectToHost:_ipAddress onPort:_port error:nil];
        if (success) {
            
        }
    }
//    if (self.disconnectedBlock) {
//        self.disconnectedBlock();
//    }
}


@end
