//
//  YJYNurseWorkerController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/14.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef NS_ENUM(NSInteger, YJYNurseWorkType) {

    YJYNurseWorkTypeNurse,
    YJYNurseWorkTypeWorker,
};

typedef void(^YJYNurseWorkerDidSelectBlock)(HgVO *hg);

@interface YJYNurseWorkerController : UITableViewController

@property (assign, nonatomic) BOOL isToSelect;
@property (assign, nonatomic) BOOL isImmediacy;
@property (assign, nonatomic) BOOL isUpdateHg;


@property(nonatomic, copy) NSString *insureNo;
@property (strong, nonatomic) InsureNOModel *insureVo;

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, readwrite) uint64_t priceId;
@property (assign, nonatomic) YJYNurseWorkType nurseWorkType;

@property (copy, nonatomic) YJYNurseWorkerDidSelectBlock didSelectBlock;
+ (instancetype)instanceWithStoryBoard;
@end
