//
//  YJYNearHospitalController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/31.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NearHospitalDidSelectBlock)(OrgDistanceModel *org);
typedef void(^NearHospitalBedResultBlock)(OrgDistanceModel *currentOrg, BranchModel *branch, RoomModel *room, BedModel *bed);

@interface YJYNearHospitalController : YJYTableViewController


@property(nonatomic, strong) NSMutableArray<OrgDistanceModel*> *orgListArray;
@property (copy, nonatomic) NearHospitalDidSelectBlock nearHospitalDidSelectBlock;
@property (copy, nonatomic) NearHospitalBedResultBlock nearHospitalBedResultBlock;
@property (assign, nonatomic) BOOL isSearch;
@property (assign, nonatomic) BOOL isBooking; //是否预约流程
@property (strong, nonatomic) OrgVO *currentOrgVo;
+ (instancetype)instanceWithStoryBoard;

@end
