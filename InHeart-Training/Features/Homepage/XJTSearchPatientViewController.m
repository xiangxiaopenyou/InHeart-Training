//
//  XJTSearchPatientViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTSearchPatientViewController.h"

@interface XJTSearchPatientViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation XJTSearchPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    [self.imageView addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)panAction:(UIPanGestureRecognizer *)pan {
//    CGPoint point = [pan translationInView:self.imageView];
//    
//    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, point.x, point.y);
//    CGRect frame = self.imageView.frame;
//    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
//    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
//    CGFloat heightOfNavigationBar = CGRectGetHeight(self.navigationController.navigationBar.frame);
//    CGFloat heightOfTabBar = CGRectGetHeight(self.tabBarController.tabBar.frame);
//    if (frame.origin.y <= heightOfNavigationBar + 20) {
//        frame.origin.y = heightOfNavigationBar + 20;
//    }
//    if (frame.origin.y >= viewHeight - 50 - heightOfTabBar) {
//        frame.origin.y = viewHeight - 50 - heightOfTabBar;
//    }
//    if (frame.origin.x <= 0) {
//        frame.origin.x = 0;
//    }
//    if (frame.origin.x >= viewWidth - 50) {
//        frame.origin.x = viewWidth - 50;
//    }
//    self.imageView.frame = frame;
//    [pan setTranslation:CGPointZero inView:self.imageView];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 50, 50)];
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

@end
