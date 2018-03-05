//
//  XJTContentDataViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/3/1.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTContentDataViewController.h"

#import "XJTBleManager.h"
#import "XJTSocketManager.h"
#import "XLAlertControllerObject.h"

@interface XJTContentDataViewController () <XJTBleManagerCommunicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;

@end

@implementation XJTContentDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewOfContent.layer.borderColor = XJTHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    NSString *ipString = [[NSUserDefaults standardUserDefaults] stringForKey:@"XJTIPAddress"];
    self.ipLabel.text = [NSString stringWithFormat:@"IP地址：%@", ipString];
    [XJTBleManager sharedBleManager].communicationDelegate = self;
    [[XJTBleManager sharedBleManager] readyForStart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)logoutAction:(id)sender {
    [XLAlertControllerObject showWithTitle:@"确定要注销吗？" message:nil cancelTitle:@"取消" ensureTitle:@"注销" ensureBlock:^{
        Byte stopBytes[5] = {0x04, 0x00, 0x81, 0x01, 0x00};
        NSData *stopData = [NSData dataWithBytes:stopBytes length:sizeof(stopBytes)];
        [[XJTBleManager sharedBleManager] writeDateToPeripherial:stopData];
        Byte bytes[5] = {0x84, 0x00, 0x81, 0x01, 0x00};
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        [[XJTBleManager sharedBleManager] writeDateToPeripherial:data];
//        Byte bytesRecovery[5] = {0x84, 0x00, 0x81, 0x01, 0x00};
//        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
//        [[XJTBleManager sharedBleManager] writeDateToPeripherial:data];
    }];
}

#pragma mark - Ble manager communication delegate
- (void)bleDidReady {
    //给服务器传送初始化完成指令
    NSData *data = [@"initialcomplete" dataUsingEncoding:NSUTF8StringEncoding];
    [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
