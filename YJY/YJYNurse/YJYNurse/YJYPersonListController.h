//
//  YJYPersonListController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"


@class KinsfolkVO;

typedef void(^KinsfolksDidSelectBlock)(KinsfolkVO *kinsfolk);

typedef NS_ENUM(uint32_t ,YJYPersonListKinsType) {
    
    YJYPersonListKinsTypeNormal,
    YJYPersonListKinsTypeApply,
    
};

@interface YJYPersonListController : YJYViewController<UITableViewDelegate,UITableViewDataSource>
+ (instancetype)instanceWithStoryBoard;
@property (copy, nonatomic) KinsfolksDidSelectBlock kinsfolksDidSelectBlock;
@property(nonatomic, readwrite) YJYPersonListKinsType kinsType;

@end
