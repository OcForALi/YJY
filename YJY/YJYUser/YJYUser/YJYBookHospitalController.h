//
//  YJYBookHospitalController.h
//  YJYUser
//
//  Created by wusonghe on 2017/8/4.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYBookHospitalController : YJYViewController

@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) HospitalBra *hospitalBra;
@property (strong, nonatomic) NSString *hospitalNumber;
@property (assign, nonatomic) BOOL isHis;
+ (instancetype)instanceWithStoryBoard;
@end
