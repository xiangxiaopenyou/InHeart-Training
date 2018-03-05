//
//  XJTConnetNavigationController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTConnectNavigationController.h"
#import "XJTConnectIPViewController.h"

@interface XJTConnectNavigationController ()<UINavigationControllerDelegate>

@end

@implementation XJTConnectNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[XJTConnectIPViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
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
