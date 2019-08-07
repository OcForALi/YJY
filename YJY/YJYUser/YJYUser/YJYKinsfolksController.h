//
//  YJYKinsfolksController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KinsfolkVO;

typedef void(^KinsfolksDidSelectBlock)(KinsfolkVO *kinsfolk);

@interface YJYKinsfolksController : YJYViewController<UITableViewDelegate,UITableViewDataSource>
+ (instancetype)instanceWithStoryBoard;
@property (copy, nonatomic) KinsfolksDidSelectBlock kinsfolksDidSelectBlock;
@property(nonatomic, readwrite) uint32_t kinsType;

@end
