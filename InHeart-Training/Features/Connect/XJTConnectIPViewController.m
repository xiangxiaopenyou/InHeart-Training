//
//  XJTConnetIPViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTConnectIPViewController.h"
#import "XJTConnectBlueToothViewController.h"

#import "XJTSocketManager.h"

@interface XJTConnectIPViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *inputImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipErrorLabel;

@end

@implementation XJTConnectIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.inputImageView.highlighted = YES;
    textField.font = XJTBoldSystemFont(12);
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputImageView.highlighted = NO;
    textField.font = XJTSystemFont(12);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.tipErrorLabel.hidden = YES;
    [textField resignFirstResponder];
    if (XJTCheckIPAddress(textField.text)) {
        BOOL isSucceed = [[XJTSocketManager sharedXJTSocketManager] connectHost:textField.text port:8885];
        if (isSucceed) {
            self.tipErrorLabel.hidden = YES;
        } else {
            self.tipErrorLabel.hidden = NO;
            self.tipErrorLabel.text = @"请重新输入IP地址!";
        }
        [XJTSocketManager sharedXJTSocketManager].connectBlock = ^{
            XJTConnectBlueToothViewController *blueToothController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJTConnectBlueTooth"];
            [self.navigationController pushViewController:blueToothController animated:YES];
        };
    } else {
        self.tipErrorLabel.hidden = NO;
        self.tipErrorLabel.text = @"请检查IP地址格式!";
    }
    return YES;
}

//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
////    NSData *data = [@"xianglinping" dataUsingEncoding:NSUTF8StringEncoding];
////    for (NSInteger i = 0; i < 1000; i ++) {
////        [_socket writeData:data withTimeout:-1 tag:0];
////        if (i == 999) {
////            [_socket disconnect];
////        }
////    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
