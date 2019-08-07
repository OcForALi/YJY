//
//  YJYBranchPicker.h
//  YJYNurse
//
//  Created by wusonghe on 2018/6/21.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYBranchPickerDidDoneBlock)(OrgDistanceModel *currentOrgDistanceModel,BranchModel *currentBranch, BOOL isSingle);
typedef void(^YJYBranchPickerDidCancelBlock)();
@interface YJYBranchPicker : UIView

+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;

@property (copy, nonatomic) YJYBranchPickerDidDoneBlock didDoneBlock;
@property (copy, nonatomic) YJYBranchPickerDidCancelBlock didCancelBlock;

@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) BranchModel *currentBranch;


@end
