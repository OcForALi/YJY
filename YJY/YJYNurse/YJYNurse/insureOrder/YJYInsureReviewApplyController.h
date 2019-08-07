//
//  YJYInsureReviewApplyController.h
//  YJYUser
//
//  Created by wusonghe on 2018/2/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"



@interface YJYInsureReviewApplyController : YJYViewController

@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) NSString *orderId;
@property(nonatomic, readwrite) uint64_t priceId;


@property (strong, nonatomic) InsurePriceVO *insurePriceVO;

@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;

@end
