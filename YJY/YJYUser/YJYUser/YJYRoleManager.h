//
//  YJYRoleManager.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJYRoleItem.h"
/// 用户角色 0-无角色 10003-健康经理 10006-督导 10004-护士长  10001-护工 10002-护士 6-其他
// 18435147377  客户经理  12228
// 13000000005  护士长    12182
// 13829044813  护士      11016

typedef NS_ENUM(NSInteger, YJYRoleType) {

    YJYRoleTypeNurse = 10002, //护士 ： 1.长护险评估
    YJYRoleTypeNurseLeader = 10004, //护士长：1.长护险评估
    YJYRoleTypeWorker = 10001, //护工：1.居家（长护险）机构 2.医疗子订单
    YJYRoleTypeHealthManager = 10003, //健康经理 居家（长护险）
    YJYRoleTypeSupervisor = 10006, //督导 机构
    
    YJYRoleTypeCustomManager = 10100 //客户经理 机构
    
};





typedef NS_ENUM(NSInteger, YJYOrderCreateType) {
    
    YJYOrderCreateTypeHome = 0,
    YJYOrderCreateTypeLongNurse = 1,
    YJYOrderCreateTypeHospital = 2
    
};


//服务类型 1-1:1  2-1:N  99-机构附加项目 101-居家照护 102-家庭护士 103-康复护理 104-中医理疗 105-金牌月嫂 106-就医陪护 107-心理慰藉 108-产后恢复 109-育婴幼教 110-临终关怀 199-上门服务附加项 200-长护险服务 180-长护险陪护服务 181-长护险带教服务 182-长护险自照服务
typedef NS_ENUM(NSInteger, YJYWorkerServiceType) {
    
    YJYWorkerServiceTypeOne = 1, //zhuan
    YJYWorkerServiceTypeMany = 2
    
};

///订单类型 1-机构订单 2-居家订单


typedef NS_ENUM(NSInteger, YJYOrderLocationType) {
    
    YJYOrderTypeHospital = 1, //zhuan
    YJYOrderTypeHome = 2
    
};



#pragma mark YJYRoleManager


@interface YJYRoleManager : NSObject

@property (assign, nonatomic) YJYRoleType roleType;
@property (assign, nonatomic) uint32_t hgType;

+ (BOOL)isZizhao;
+ (instancetype)sharedInstance;

- (NSArray<WorkbenchItem *> *)workbenchItemsWithRsp:(GetHgInfoRsp *)rsp;

- (NSArray *)orderListItems;
- (NSArray *)orderInsureListItems;

- (NSArray *)longNurseListItems;
- (NSArray *)insureListItems;
- (NSArray *)calendarsListItems;

//order detail
- (NSArray<OrderMenuItem *> *)orderMenuItemsWithOrderInfoRsp:(GetOrderInfoRsp *)rsp;
;
- (NSArray<LongNurseMenuItem *> *)LongNurseMenuItemsWithInsureNoRsp:(GetInsureDetailRsp *)rsp;
- (NSArray<LongNurseMenuItem *> *)book_LongNurseMenuItemsWithInsureNoRsp:(GetInsureNoRsp *)rsp;



//insure report

- (BOOL)isSupportEditInsurtReport;

@end



