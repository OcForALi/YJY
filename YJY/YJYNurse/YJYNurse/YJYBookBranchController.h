//
//  YJYBookBranchController.h
//  YJYUser
//
//  Created by wusonghe on 2017/8/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYBookBranchDidSelectBlock)(OrgDistanceModel *org,BranchModel *branch);
typedef void(^YJYBookBranchDidMultiSelectBlock)(OrgDistanceModel *org,NSArray<BranchModel *>* branchs);


@interface YJYBookBranchController : YJYViewController
@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (copy, nonatomic) YJYBookBranchDidSelectBlock didSelectBlock;

@property (copy, nonatomic) NSString *orderId;
@property(nonatomic, readwrite) uint64_t orgId;
@property (assign, nonatomic) BOOL isTranfer;

//多选
@property (strong, nonatomic) GPBUInt64Array *branchIdArray;
@property (strong, nonatomic) NSArray *selectedBranchArray;            
@property (assign, nonatomic) BOOL allowMultiSelected;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) YJYBookBranchDidMultiSelectBlock didMultiSelectBlock;


@end
