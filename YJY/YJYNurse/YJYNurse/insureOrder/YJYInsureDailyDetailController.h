//
//  YJYInsureDailyDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureDailyDetailController : YJYViewController

@property (strong, nonatomic) InsureOrderTendItemVO *insureOrderTendItemVO;
@property (strong, nonatomic) NSString *orderId;

@property (assign, nonatomic) BOOL toComfire;
@end
