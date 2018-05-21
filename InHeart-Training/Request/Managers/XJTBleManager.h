//
//  XJTBleManager.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/3/1.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol XJTBleManagerConnectDelegate <NSObject>
- (void)didDiscoverUsefulPeripheral:(NSArray *)peripheralsArray;
- (void)didReceiveConnectResult:(XJTBleConnectStatus)connectStatus;
@end

@protocol XJTBleManagerCommunicationDelegate <NSObject>
- (void)bleDidReady;
- (void)didReceiveHeartRateData:(NSInteger)rateInt;
@end

@interface XJTBleManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *blesArray;
@property (nonatomic, weak) id<XJTBleManagerConnectDelegate> connectDelegate;
@property (nonatomic, weak) id<XJTBleManagerCommunicationDelegate> communicationDelegate;
@property (nonatomic, copy) void (^centralStatusBlock)(CBManagerState state);

+ (XJTBleManager *)sharedBleManager;
- (void)connectPeripheral:(CBPeripheral *)tempPeripheral;
- (void)disconnectPeripheral:(CBPeripheral *)tempPeripheral;
- (void)readyForStart;
- (void)startCommand;
- (void)writeDateToPeripherial:(NSData *)data;

@end
