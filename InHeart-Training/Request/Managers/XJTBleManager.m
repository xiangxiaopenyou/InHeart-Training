//
//  XJTBleManager.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/3/1.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTBleManager.h"
#import <MBProgressHUD.h>
@interface XJTBleManager ()
@end

@implementation XJTBleManager
+ (XJTBleManager *)sharedBleManager {
    static XJTBleManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJTBleManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}
- (void)connectPeripheral:(CBPeripheral *)tempPeripheral {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:XJTKeyWindow animated:YES];
    hud.square = YES;
    hud.label.text = @"正在连接...";
    [self.manager connectPeripheral:tempPeripheral options:nil];
}
- (void)disconnectPeripheral:(CBPeripheral *)tempPeripheral {
    [self.manager cancelPeripheralConnection:tempPeripheral];
}
- (void)readyForStart {
    [self.peripheral discoverServices:nil];
    
}
//开始指令
- (void)startCommand:(XJTOrderModel *)model {
    NSString *nameString = model.name;
    NSString *resultString = XJTHexStringFromString(nameString);
    NSInteger nameLenthHex = XJTHexByDecimal(nameString.length * 3);
    Byte bytes1[20] = {0x03, 0x00, 0x01, 0x10, nameLenthHex};
    for (int i = 0; i < 15; i ++) {
        NSString *tempString = [resultString substringWithRange:NSMakeRange(i * 2, 2)];
        NSString *tempHexString = [NSString stringWithFormat:@"0x%@", tempString];
        bytes1[i + 5] = XJTNumberWithHexString(tempHexString);
    }
    NSData *data1 = [NSData dataWithBytes:bytes1 length:sizeof(bytes1)];
    [self writeDateToPeripherial:data1];
    NSString *phoneString = model.mobile;
    if (phoneString.length < 11) {
        phoneString = @"00000000000";
    }
    Byte bytes2[20] = {0x03, 0x00, 0x02, 0x10, 0x01, 0x01, 0x0B};
    for (int i = 0; i < phoneString.length; i ++) {
        NSString *temp = [phoneString substringWithRange:NSMakeRange(i, 1)];
        NSInteger tempHex = XJTHexByDecimal(temp.integerValue);
        bytes2[i + 7] = tempHex;
    }
    bytes2[18] = 0x00;
    bytes2[19] = 0x00;
    NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
    [self writeDateToPeripherial:data2];
    Byte bytes3[8] = {0x03, 0x00, 0x83, 0x04, 0x00, 0x00, 0x20, 0x00};
    NSData *data3 = [NSData dataWithBytes:bytes3 length:sizeof(bytes3)];
    [self writeDateToPeripherial:data3];
}
//结束指令
- (void)endCommand {
    Byte stopBytes[5] = {0x04, 0x00, 0x81, 0x01, 0x00};
    NSData *stopData = [NSData dataWithBytes:stopBytes length:sizeof(stopBytes)];
    [self writeDateToPeripherial:stopData];
    Byte bytes[5] = {0x84, 0x00, 0x81, 0x01, 0x00};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self writeDateToPeripherial:data];
}
- (void)writeDateToPeripherial:(NSData *)data {
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - Central manager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    } else {
        if (self.centralStatusBlock) {
            self.centralStatusBlock(central.state);
        }
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.blesArray containsObject:peripheral] && peripheral.name && [peripheral.name containsString:@"Z4"]) {
        [self.blesArray addObject:peripheral];
        if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(didDiscoverUsefulPeripheral:)]) {
            [self.connectDelegate didDiscoverUsefulPeripheral:self.blesArray];
        }
    }
}
/**
 连接失败
 
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [MBProgressHUD hideHUDForView:XJTKeyWindow animated:YES];
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(didReceiveConnectResult:)]) {
        [self.connectDelegate didReceiveConnectResult:XJTBleConnectStatusFail];
    }
}

/**
 连接成功
 
 @param central 中心管理者
 @param peripheral 连接的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [MBProgressHUD hideHUDForView:XJTKeyWindow animated:YES];
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(didReceiveConnectResult:)]) {
        [self.connectDelegate didReceiveConnectResult:XJTBleConnectStatusSuccess];
    }
}

/**
 连接断开
 
 @param central 中心管理者
 @param peripheral 连接的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [MBProgressHUD hideHUDForView:XJTKeyWindow animated:YES];
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(didReceiveConnectResult:)]) {
        [self.connectDelegate didReceiveConnectResult:XJTBleConnectStatusBroken];
    }
}

#pragma mark - Peripheral delegate
/**
 扫描服务
 
 @param peripheral 设备
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"服务:%@", service.UUID.UUIDString);
        if ([service.UUID.UUIDString isEqualToString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
/**
 扫描到对应的特征
 
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"特征值:%@", characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            self.writeCharacteristic = characteristic;
            Byte bytes[12] = {0x01, 0x5A, 0x81, 0x08, 0x55, 0xAA, 0x11, 0x22, 0x64, 0x18, 0x90, 0x99};
            NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [self writeDateToPeripherial:data];
            [self endCommand];
        }
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"])
        {
            // 订阅特征通知
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}
//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
}
/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = characteristic.value;
    NSString *hexString = XJTConvertDataToHexStr(data);
    NSLog(@"%@", hexString);
    if ([hexString isEqualToString:@"015a810100"]) {
        //系统连接完成
        if (self.communicationDelegate && [self.communicationDelegate respondsToSelector:@selector(bleDidReady)]) {
            [self.communicationDelegate bleDidReady];
        }
    } else if ([hexString containsString:@"07038101"]) {
        //返回实时心率数据
        NSString *rateString = [hexString substringFromIndex:hexString.length - 2];
        NSInteger tempInt = XJTNumberWithHexString(rateString);
        NSLog(@"%@", @(tempInt));
        if (self.communicationDelegate && [self.communicationDelegate respondsToSelector:@selector(didReceiveHeartRateData:)]) {
            [self.communicationDelegate didReceiveHeartRateData:tempInt];
        }
    }
}

- (NSMutableArray *)blesArray {
    if (!_blesArray) {
        _blesArray = [[NSMutableArray alloc] init];
    }
    return _blesArray;
}


@end
