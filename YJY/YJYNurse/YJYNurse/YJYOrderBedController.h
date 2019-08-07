//
//  YJYOrderBedController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^OrderBedResultBlock)(OrgDistanceModel *currentOrg, BranchModel *branch, RoomModel *room, BedModel *bed);
typedef void(^OrderPricesResultBlock)(NSArray <Price*> *pList12NArray, NSArray <Price*> *pList121Array);

@interface YJYOrderBedController : YJYViewController
+ (instancetype)instanceWithStoryBoard;

@property (strong, nonatomic) OrgDistanceModel *currentOrg;

@property (copy, nonatomic) OrderBedResultBlock orderBedResultBlock;
@property (copy, nonatomic) OrderPricesResultBlock orderPricesResultBlock;
@property (assign, nonatomic) BOOL isBooking; //是否预约流程

@end
