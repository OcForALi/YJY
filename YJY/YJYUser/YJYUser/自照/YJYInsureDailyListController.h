//
//  YJYInsureDailyListController.h
//  YJYUser
//
//  Created by wusonghe on 2018/3/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureDailyListController : YJYTableViewController



@property (strong, nonatomic) GetHomeOrderDetailRsp *orderDetailRsp;


@property (strong, nonatomic) GetInsureOrderTendItemRsp *rsp;

@property (weak, nonatomic) IBOutlet UILabel *familyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *serveNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *restNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *absenteeismNumberLabel;

@end
