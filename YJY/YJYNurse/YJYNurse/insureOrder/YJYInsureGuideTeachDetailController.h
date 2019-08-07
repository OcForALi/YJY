//
//  YJYInsureGuideTeachDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
typedef void(^ YJYInsureGuideTeachDetailDidDoneBlock)();

@interface YJYInsureGuideTeachDetailController : YJYViewController
@property (strong, nonatomic) TeachRecordVO *teachRecordVO;

@property(nonatomic, readwrite) NSString *orderId;

@property (copy, nonatomic) YJYInsureGuideTeachDetailDidDoneBlock didDoneBlock;
@property (weak, nonatomic) IBOutlet UIView *buttonView;


@end
