//
//  YJYPaymentAdjustController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/18.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYPaymentAdjustDidDismissBlock)();
@interface YJYPaymentAdjustController : YJYViewController


@property (copy, nonatomic) NSString *orderId;
@property (nonatomic, strong) NSMutableArray<NSString*> *monthsArray;
//来自调整
@property (assign, nonatomic) BOOL isAdjustPage;
@property (assign, nonatomic) YJYOrderPaymentAdjustType jumpType;
//YJYOrderPaymentAdjustTypeServingPayoffEnding



@property (copy, nonatomic) YJYPaymentAdjustDidDismissBlock didDismissBlock;
@property (copy, nonatomic) YJYPaymentAdjustDidDismissBlock didDoneBlock;
@property (copy, nonatomic) YJYPaymentAdjustDidDismissBlock didToListBlock;


@property (weak, nonatomic) IBOutlet UILabel *workerPriceLabel;
@property (assign, nonatomic) YJYWorkerServiceType workerServiceType;
@end
