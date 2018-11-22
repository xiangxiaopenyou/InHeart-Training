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
#import "XJTOrderModel.h"

#import <UIImage+GIF.h>
#import <UIImageView+WebCache.h>

@interface XJTContentDataViewController () <XJTBleManagerCommunicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) YSCWaveView *waveView;
@property (nonatomic, strong) NSMutableArray *heartRateDataArray;
@property (nonatomic, strong) XJTOrderModel *model;
@property (nonatomic, copy) NSString *startTimeString;
//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XJTContentDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    self.viewOfContent.layer.borderColor = XJTHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    NSString *ipString = [[NSUserDefaults standardUserDefaults] stringForKey:@"XJTIPAddress"];
    self.ipLabel.text = [NSString stringWithFormat:@"IP地址：%@", ipString];
    [XJTBleManager sharedBleManager].communicationDelegate = self;
    [[XJTBleManager sharedBleManager] readyForStart];

    NSString *ratePath = [[NSBundle mainBundle] pathForResource:@"heart_rate" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:ratePath];
    UIImage *rateImage = [UIImage sd_animatedGIFWithData:imageData];
    self.rateImageView.image = rateImage;
    
    [XJTSocketManager sharedXJTSocketManager].receivedBlock = ^(NSDictionary *dictionary) {
        if (dictionary[@"type"]) {
            NSInteger type = [dictionary[@"type"] integerValue];
            switch (type) {
                case 1: { //开始指令
                    if (dictionary[@"data"]) {
                        NSString *tempString = dictionary[@"data"];
                        NSArray *tempArray = [tempString componentsSeparatedByString:@","];
                        if (tempArray.count == 6) {
                            XJTOrderModel *model = [[XJTOrderModel alloc] init];
                            model.name = tempArray[0];
                            model.mobile = tempArray[1];
                            model.age = [NSNumber numberWithInteger:[tempArray[2] integerValue]];
                            model.recordId = tempArray[3];
                            model.sceneName = tempArray[4];
                            model.sceneImageUrl = tempArray[5];
                            [self startRecord:model];
                        }
                    }
                }
                    break;
                case 2: { //结束指令
                    [self endRecord];
                }
                    break;
                case 3: { //错误指令
                    [self socketDidDisconnect];
                }
                    break;
                default:
                    break;
            }
        }
    };
//    [XJTSocketManager sharedXJTSocketManager].disconnectedBlock = ^{
//        [self socketDidDisconnect];
//    };
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.timer invalidate];
//    self.timer = nil;
    [[XJTSocketManager sharedXJTSocketManager] disconnect];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)logoutAction:(id)sender {
    [XLAlertControllerObject showWithTitle:@"确定要注销吗？" message:nil cancelTitle:@"取消" ensureTitle:@"注销" ensureBlock:^{
        [[XJTBleManager sharedBleManager] endCommand];
        [[XJTSocketManager sharedXJTSocketManager] disconnect];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}
#pragma mark - Private method
- (void)setupContentData:(XJTOrderModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sceneImageView sd_setImageWithURL:[NSURL URLWithString:model.sceneImageUrl]];
        self.sceneNameLabel.text = model.sceneName;
        self.nameLabel.text = model.name;
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        dateString = [dateString substringToIndex:19];
        self.beginTimeLabel.text = dateString;
    });
}
- (void)socketDidDisconnect {
//    self.connectStatusLabel.text = @"连接已断开";
//    self.statusImage.hidden = YES;
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"连接已经断开，请重新连接" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [[XJTBleManager sharedBleManager] endCommand];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }];
//    [alert addAction:comfirmAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
}

//开始测试
- (void)startRecord:(XJTOrderModel *)orderModel
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.startTimeString = [dateFormatter stringFromDate:currentDate];
    [self.heartRateDataArray removeAllObjects];
    [[XJTBleManager sharedBleManager] startCommand:orderModel];
    [self setupContentData:orderModel];
    self.model = orderModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewOfContent addSubview:self.waveView];
        [self.waveView showWaveViewWithType:YSCWaveTypePulse];
    });
}
//结束测试
- (void)endRecord
{
//    [self.timer invalidate];
//    self.timer = nil;
    [[XJTBleManager sharedBleManager] endCommand];
    if (self.heartRateDataArray.count > 0) { //向服务端发送心率数据
        NSArray *tempRateDataArray = [self.heartRateDataArray copy];
        NSInteger temp = tempRateDataArray.count / 100;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSInteger i = 0; i <= temp; i ++) {
                NSArray *array = [NSArray array];
                if (i == temp) {
                    array = [tempRateDataArray subarrayWithRange:NSMakeRange(i * 100, tempRateDataArray.count - i * 100)];
                } else {
                    array = [tempRateDataArray subarrayWithRange:NSMakeRange(i * 100, 100)];
                }
                 NSString *dataString = [array componentsJoinedByString:@","];
                if (i == 0) {
                    NSString *sendString = [NSString stringWithFormat:@"DATA %@+%@+%@\r\n", self.model.recordId, self.startTimeString, dataString];
                    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
                    [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
                } else {
                    NSString *sendString = [NSString stringWithFormat:@"LAST %@+%@\r\n", self.model.recordId, dataString];
                    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
                    [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *data = [@"END\r\n" dataUsingEncoding:NSUTF8StringEncoding];
                [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
            });
        });
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.waveView removeFromParentView];
        XJTShowHUDTip(YES, @"测试完成");
    });
}

#pragma mark - Ble manager communication delegate
- (void)bleDidReady {
    //给服务器传送初始化完成指令
//    NSData *data = [@"initialcomplete" dataUsingEncoding:NSUTF8StringEncoding];
//    [[XJTSocketManager sharedXJTSocketManager] writeDataToService:data];
}
- (void)didReceiveHeartRateData:(NSInteger)rateInt {
    NSString *dataString = [NSString stringWithFormat:@"%@", @(rateInt)];
    self.heartRateLabel.text = dataString;
    [self.heartRateDataArray addObject:dataString];
    self.numberLabel.text = [NSString stringWithFormat:@"数据数量：%@", @(self.heartRateDataArray.count)];
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
