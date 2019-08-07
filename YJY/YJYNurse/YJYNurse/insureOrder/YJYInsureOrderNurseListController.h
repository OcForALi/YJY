//
//  YJYInsureOrderNurseListController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"
#import "YJYNurseWorkerController.h"
typedef void(^YJYInsureOrderNurseListDidSelectBlock)(InsureHGListVO *insureHGListVO);

@interface YJYInsureOrderNurseListController : YJYTableViewController

@property (assign, nonatomic) BOOL isGuide;
@property (assign, nonatomic) BOOL isNurse;

@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) InsureNOModel *insureVo;
@property (assign, nonatomic) YJYNurseWorkType nurseWorkType;
@property (copy,nonatomic) NSString *insureNo;
@property (copy,nonatomic) NSString *orderId;
@property (copy,nonatomic) NSString *remark;
@property (copy,nonatomic) NSString *time;
@property (assign,nonatomic) uint64_t priceId;

@property (copy, nonatomic) YJYInsureOrderNurseListDidSelectBlock didSelectBlock;

@end
