//
//  XJTTrainingCenterViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTTrainingCenterViewController.h"

#import "XLAlertControllerObject.h"

#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, XJStartTrainingCommandTimes) {
    XJStartTrainingCommandTimesNone = 0,
    XJStartTrainingCommandTimesFirst,
    XJStartTrainingCommandTimesSecond,
    XJStartTrainingCommandTimesThird
};

@interface XJTTrainingCenterViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSMutableArray *bleArray;
@property (nonatomic, assign) XJStartTrainingCommandTimes startCommandTimes;

@end

@implementation XJTTrainingCenterViewController

#pragma mark - View controller cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _startCommandTimes = XJStartTrainingCommandTimesNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)rightItemAction:(id)sender {
    _startCommandTimes = XJStartTrainingCommandTimesFirst;
    [self startCommand];
}
- (IBAction)leftItemAction:(id)sender {
    Byte bytes[5] = {0x05, 0x00, 0x81, 0x01, 0x00};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self writeDateToPeripherial:_peripheral characteristic:_writeCharacteristic data:data];
}
#pragma mark - Private methods
- (void)startCommand {
    if (_startCommandTimes == XJStartTrainingCommandTimesFirst) {
        NSString *nameString = @"项林平";
        NSString *resultString = XJTHexStringFromString(nameString);
        NSInteger nameLenthHex = XJTHexByDecimal(nameString.length * 3);
        Byte bytes[20] = {0x03, 0x00, 0x01, 0x10, nameLenthHex};
        for (int i = 0; i < 15; i ++) {
            NSString *tempString = [resultString substringWithRange:NSMakeRange(i * 2, 2)];
            NSInteger tempInt = tempString.integerValue;
            bytes[i + 5] = tempInt;
        }
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        [self writeDateToPeripherial:_peripheral characteristic:_writeCharacteristic data:data];
    } else if (_startCommandTimes == XJStartTrainingCommandTimesSecond) {
        NSString *phoneString = @"13732254511";
        Byte bytes[20] = {0x03, 0x00, 0x02, 0x10, 0x01, 0x01, 0x0B};
        for (int i = 0; i < phoneString.length; i ++) {
            NSString *temp = [phoneString substringWithRange:NSMakeRange(i, 1)];
            NSInteger tempHex = XJTHexByDecimal(temp.integerValue);
            bytes[i + 7] = tempHex;
        }
        bytes[18] = 0x00;
        bytes[19] = 0x00;
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        [self writeDateToPeripherial:_peripheral characteristic:_writeCharacteristic data:data];
    } else {
        Byte bytes[8] = {0x03, 0x00, 0x83, 0x04, 0x00, 0x00, 0x20, 0x00};
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        [self writeDateToPeripherial:_peripheral characteristic:_writeCharacteristic data:data];
    }
}
- (void)writeDateToPeripherial:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data {
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - Central manager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (![self.bleArray containsObject:peripheral] && peripheral.name) {
        [self.bleArray addObject:peripheral];
        [self.tableView reloadData];
    }
    
}

/**
 连接失败

 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

/**
 连接成功

 @param central 中心管理者
 @param peripheral 连接的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

/**
 连接断开

 @param central 中心管理者
 @param peripheral 连接的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
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
            _writeCharacteristic = characteristic;
            Byte bytes[12] = {0x01, 0x5A, 0x81, 0x08, 0x55, 0xAA, 0x11, 0x22, 0x64, 0x18, 0x90, 0x99};
            NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [self writeDateToPeripherial:peripheral characteristic:characteristic data:data];
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
    if (_startCommandTimes == XJStartTrainingCommandTimesFirst) {
        _startCommandTimes = XJStartTrainingCommandTimesSecond;
        [self startCommand];
    } else if (_startCommandTimes == XJStartTrainingCommandTimesSecond) {
        _startCommandTimes = XJStartTrainingCommandTimesThird;
        [self startCommand];
    } else if (_startCommandTimes == XJStartTrainingCommandTimesThird) {
        _startCommandTimes = XJStartTrainingCommandTimesNone;
    }
}
/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = characteristic.value;
    NSLog(@"%@", data);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    cell.textLabel.text = tempPeripheral.name;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    [self.manager connectPeripheral:tempPeripheral options:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)bleArray {
    if (!_bleArray) {
        _bleArray = [[NSMutableArray alloc] init];
    }
    return _bleArray;
}


@end
