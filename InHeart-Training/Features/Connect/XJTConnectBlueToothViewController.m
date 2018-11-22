//
//  XJTConnectBlueToothViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTConnectBlueToothViewController.h"
#import "XJTContentDataViewController.h"
#import "XJTBlueToothCell.h"
#import "XLAlertControllerObject.h"
#import "XJTBleManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface XJTConnectBlueToothViewController ()<UITableViewDataSource, UITableViewDelegate, CBPeripheralDelegate, XJTBleManagerConnectDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfBlueTooth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) CBCentralManager *manager;
//@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *bleArray;

@end

@implementation XJTConnectBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewOfBlueTooth.layer.borderColor = XJTHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    //_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [XJTBleManager sharedBleManager].connectDelegate = self;
    [[XJTBleManager sharedBleManager].manager scanForPeripheralsWithServices:nil options:nil];
    if (self.bleArray.count == 0) {
        self.bleArray = [[XJTBleManager sharedBleManager].blesArray mutableCopy];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ble manager connect delegate
- (void)didDiscoverUsefulPeripheral:(NSArray *)peripheralsArray {
    self.bleArray = [peripheralsArray mutableCopy];
    [self.tableView reloadData];
}
- (void)didReceiveConnectResult:(XJTBleConnectStatus)connectStatus {
    if (connectStatus == XJTBleConnectStatusSuccess) {
        XJTContentDataViewController *contentDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJTContentData"];
        [self.navigationController pushViewController:contentDataController animated:YES];
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
            _writeCharacteristic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
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
    NSLog(@"%@", data);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJTBlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJTBlueToothCell" forIndexPath:indexPath];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    cell.nameLabel.text = tempPeripheral.name;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    [XLAlertControllerObject showWithTitle:[NSString stringWithFormat:@"连接%@吗？", tempPeripheral.name] message:nil cancelTitle:@"取消" ensureTitle:@"连接" ensureBlock:^{
        [[XJTBleManager sharedBleManager] connectPeripheral:tempPeripheral];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (NSMutableArray *)bleArray {
    if (!_bleArray) {
        _bleArray = [[NSMutableArray alloc] init];
    }
    return _bleArray;
}

@end
