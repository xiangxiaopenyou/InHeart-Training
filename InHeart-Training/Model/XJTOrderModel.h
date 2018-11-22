//
//  XJTOrderModel.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/8/13.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJTBaseModel.h"

@interface XJTOrderModel : XJTBaseModel
@property (copy, nonatomic) NSString *recordId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *sceneName;
@property (copy, nonatomic) NSString *sceneImageUrl;
@property (strong, nonatomic) NSNumber *age;

@end
