//
//  XJTContentDataViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/3/1.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTContentDataViewController.h"

#import "YSCWaveView.h"

#import "XJTBleManager.h"
#import "XJTSocketManager.h"
#import "XLAlertControllerObject.h"

#import <UIImage+GIF.h>

@interface XJTContentDataViewController () <XJTBleManagerCommunicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateImageView;
@property (nonatomic, strong) YSCWaveView *waveView;
@property (nonatomic, strong) NSMutableArray *heartRateDataArray;

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

    NSString *ratePath = [[NSBundle mainBundle] pathForResource:@"heart_rate" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:ratePath];
    UIImage *rateImage = [UIImage sd_animatedGIFWithData:imageData];
    
    self.rateImageView.image = rateImage;
    
    
    [self.viewOfContent addSubview:self.waveView];
    [self.waveView showWaveViewWithType:YSCWaveTypePulse];
    
    
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
    }];
}

#pragma mark - Ble manager communication delegate
- (void)bleDidReady {
    //给服务器传送初始化完成指令
    NSData *data = [@"initialcomplete" dataUsingEncoding:NSUTF8StringEncoding];
    [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
}
- (void)didReceiveHeartRateData:(NSInteger)rateInt {
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", @(rateInt)];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *dataString = [NSString stringWithFormat:@"%@+%@+@%@@%@", @(rateInt), @(rateInt), @(rateInt), dateString];
    [self.heartRateDataArray addObject:dataString];
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
- (YSCWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[YSCWaveView alloc] initWithFrame:CGRectMake(- 120, 120, CGRectGetWidth(self.viewOfContent.frame) + 120, CGRectGetHeight(self.viewOfContent.frame) - 120)];
        _waveView.backgroundColor = [UIColor whiteColor];
    }
    return _waveView;
}
- (NSMutableArray *)heartRateDataArray {
    if (!_heartRateDataArray) {
        _heartRateDataArray = [[NSMutableArray alloc] init];
    }
    return _heartRateDataArray;
}

@end
