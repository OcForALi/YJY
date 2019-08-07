
//
//  YJYRoleManager.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYRoleManager.h"





@interface YJYRoleManager ()

@end

@implementation YJYRoleManager

+ (instancetype)sharedInstance
{
    static YJYRoleManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YJYRoleManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}
+ (BOOL)isZizhao {
    /// 护工类型 1-居家 2-机构 3-自照
    /// 护工类型 1-居家 2-机构 3-自照
    
    if ([KeychainManager getValueWithKey:kRoleId]) {
        [YJYRoleManager sharedInstance].roleType =  [[KeychainManager getValueWithKey:kRoleId] integerValue];
        
    }
    
    if ([KeychainManager getValueWithKey:kHgType]) {
        [YJYRoleManager sharedInstance].hgType = (uint32_t)[[KeychainManager getValueWithKey:kHgType] integerValue];
        
    }

    BOOL zizhao = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager ||
                    [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse ||
    [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ||
    ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && ([YJYRoleManager sharedInstance].hgType == 1 || [YJYRoleManager sharedInstance].hgType == 3));
    
    return zizhao;
    
}
- (BOOL)isSupportEditInsurtReport {

    
    return [YJYRoleManager sharedInstance].roleType != YJYRoleTypeWorker;
}
#pragma mark - 首页Items

- (NSArray<WorkbenchItem *> *)workbenchItemsWithRsp:(GetHgInfoRsp *)rsp {
    
    self.roleType = [[KeychainManager getValueWithKey:kRoleId] integerValue];
    
    NSArray *dictS;
    if (self.roleType == YJYRoleTypeNurse) {
        
   
        dictS = @[@{@"type":@(YJYWorkbenchTypeInsureManager),@"title":@"我的评估",@"des":@"点击查看评估"},
                  @{@"type":@(YJYWorkbenchTypeMyCalendar),@"title":@"我的日程",@"des":@"有新的日程安排"},
                  @{@"type":@(YJYWorkbenchTypeAbnormalOrder),@"title":@"异常订单管理",@"des":@"查看详情"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
    
        dictS = @[@{@"type":@(YJYWorkbenchTypeInsureManager),@"title":@"长护险评估",@"des":@"点击查看"},
                  @{@"type":@(YJYWorkbenchTypeMyNurse),@"title":@"我的护士",@"des":@"点击查看"},
                  @{@"type":@(YJYWorkbenchTypeAbnormalOrder),@"title":@"异常订单管理",@"des":@"查看详情"}];
        
    }else if (self.roleType == YJYRoleTypeWorker) {
        
        dictS = @[@{@"type":@(YJYWorkbenchTypeMyCalendar),@"title":@"我的日程",@"des":@"有新的日程安排"},
                  @{@"type":@(YJYWorkbenchTypeMyData),@"title":@"我的资料",@"des":@"点击查看"},
                  @{@"type":@(YJYWorkbenchTypePayoffStatistics),@"title":@"结算统计",@"des":@"已结算订单统计"},
                  @{@"type":@(YJYWorkbenchTypeSignAgreement),@"title":@"知情同意书",@"des":@"补签知情同意书"},
                  @{@"type":@(YJYWorkbenchTypeOutInStatistics),@"title":@"出入院统计",@"des":@"出入院病人"},
                  @{@"type":@(YJYWorkbenchTypeAbnormalOrder),@"title":@"异常订单管理",@"des":@"查看详情"}];
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:dictS];

        /// 是否首页显示出入院统计 1-否 2-是

        if (rsp.isUserSituation != 2) {
            [arrM removeObjectAtIndex:arrM.count-2];
        }

      
        
        dictS = arrM;
        
    }else if (self.roleType == YJYRoleTypeHealthManager) {
        
        
        dictS = @[@{@"type":@(YJYWorkbenchTypeCreateOrder),@"title":@"新增订单",@"des":@"新增服务订单"},
                  @{@"type":@(YJYWorkbenchTypeInsureAdd),@"title":@"新增申请单",@"des":@"新增长护险申请单"},
                  @{@"type":@(YJYWorkbenchTypeInsureManager),@"title":@"长护险申请管理",@"des":@"长护险申请管理"},
                  @{@"type":@(YJYWorkbenchTypeMyCalendar),@"title":@"我的日程",@"des":@"有新的日程安排"},
                  @{@"type":@(YJYWorkbenchTypeMyWork),@"title":@"我的护理员",@"des":@"点击查看护理员"},
                  @{@"type":@(YJYWorkbenchTypeBookOrder),@"title":@"长护险下单预约",@"des":@"新增长护险订单"},
                  @{@"type":@(YJYWorkbenchTypeKPI),@"title":@"我的业绩",@"des":@"点击查看护理员"},
                  @{@"type":@(YJYWorkbenchTypeAbnormalOrder),@"title":@"异常订单管理",@"des":@"查看详情"}];
        
    }else if (self.roleType == YJYRoleTypeSupervisor) {
        
        dictS = @[@{@"type":@(YJYWorkbenchTypeCreateOrder),@"title":@"新增订单",@"des":@"新增服务订单"},
                  @{@"type":@(YJYWorkbenchTypeMyWork),@"title":@"我的护理员",@"des":@"点击查看护理员"},
                  @{@"type":@(YJYWorkbenchTypePayoffStatistics),@"title":@"结算统计",@"des":@"已结算订单统计"},
                  @{@"type":@(YJYWorkbenchTypeServiceStatistics),@"title":@"当前服务统计",@"des":@"服务中订单统计"},
                  @{@"type":@(YJYWorkbenchTypeReviewStatistics),@"title":@"评价统计",@"des":@"点击查看评价"},
                  @{@"type":@(YJYWorkbenchTypeSignAgreement),@"title":@"知情同意书",@"des":@"补签知情同意书"},
                  @{@"type":@(YJYWorkbenchTypeOutInStatistics),@"title":@"出入院统计",@"des":@"出入院病人"},
                  @{@"type":@(YJYWorkbenchTypeAbnormalOrder),@"title":@"异常订单管理",@"des":@"查看详情"}];
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:dictS];

        if (rsp.isUserSituation != 2) {
            [arrM removeObjectAtIndex:arrM.count-2];
        }
        
      
        
        dictS = arrM;
    }
    
    NSArray *items = [WorkbenchItem mj_objectArrayWithKeyValuesArray:dictS];
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:items];
    
    if (rsp.isAbnormalOrder != 2) {
        [arrM removeLastObject];

    }

    
    return arrM;

}

#pragma mark - 列表Items


- (NSArray *)calendarsListItems {
    
    NSArray *listItems;
    
    if (self.roleType == YJYRoleTypeCustomManager) {
        
        
        listItems = @[@{@"type":@(YJYCalendarTypeOpenOrder),@"title":@"开启订单"},
                      @{@"type":@(YJYCalendarTypeContinueOrder),@"title":@"续费订单"}];
        
        
    }else if (self.roleType == YJYRoleTypeWorker) {
        
        listItems = @[@{@"type":@(YJYCalendarTypeComfireOrder),@"title":@"确认服务"},
                      @{@"type":@(YJYCalendarTypeOpenOrder),@"title":@"开启订单"}];
        
    }else if (self.roleType == YJYRoleTypeNurse) {
        
        listItems = @[@{@"type":@(YJYCalendarTypeApplyReview),@"title":@"申请评估"},
                      @{@"type":@(YJYCalendarTypeServiceBack),@"title":@"服务回访"},
                      @{@"type":@(YJYCalendarTypeCarePlan),@"title":@"照护计划制定"}];
        
    }
    
    
    
    NSArray *items = [CalendarListItem mj_objectArrayWithKeyValuesArray:listItems];
    
    return items;
    
}
/// 长护险（全部--1 丨 待接单-0 丨 待支付-1 丨 待指派-2 丨待服务-3 丨 服务中-4 丨 待评价-6 丨 已完成-7 ）  、机构（0-全部 1-待指派 2-待服务 3-服务中  4-待结算 5-已完成 6-待支付）
- (NSArray *)orderInsureListItems {
    
    NSArray *listItems;
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        
        listItems = @[@{@"type":@(YJYOrderInsureTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderInsureTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderInsureTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderInsureTypeWaitReview),@"title":@"待评价"},
                      @{@"type":@(YJYOrderInsureTypeDone),@"title":@"已完成"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        listItems = @[@{@"type":@(YJYOrderInsureTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderInsureTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYOrderInsureTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderInsureTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderInsureTypeDone),@"title":@"已完成"}];
        
    }else if (self.roleType == YJYRoleTypeWorker) {
        
        listItems = @[@{@"type":@(YJYOrderInsureTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderInsureTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderInsureTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderInsureTypeWaitReview),@"title":@"待评价"},
                      @{@"type":@(YJYOrderInsureTypeDone),@"title":@"已完成"}];
        
    }else if (self.roleType == YJYRoleTypeCustomManager) {
        
        
        listItems = @[@{@"type":@(YJYOrderInsureTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderInsureTypeReceive),@"title":@"待接单"},
                      @{@"type":@(YJYOrderInsureTypeWaitPay),@"title":@"待支付"},
                      @{@"type":@(YJYOrderInsureTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYOrderInsureTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderInsureTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderInsureTypeWaitReview),@"title":@"待评价"},
                      @{@"type":@(YJYOrderInsureTypeDone),@"title":@"已完成"}];
        
        
        
    }
    
    
    
    NSArray *items = [OrderListItem mj_objectArrayWithKeyValuesArray:listItems];
    
    return items;
    
}
- (NSArray *)orderListItems {

    NSArray *listItems;
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        
        listItems = @[@{@"type":@(YJYOrderTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderTypeDone),@"title":@"已完成"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        listItems = @[@{@"type":@(YJYOrderTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYOrderTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderTypeDone),@"title":@"已完成"}];
        
    }else if (self.roleType == YJYRoleTypeWorker) {
        
        listItems = @[@{@"type":@(YJYOrderTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderTypeWaitPayOff),@"title":@"待结算"},
                      @{@"type":@(YJYOrderTypeDone),@"title":@"已完成"}];
        
    }else if (self.roleType == YJYRoleTypeHealthManager) {
        
        listItems = @[@{@"type":@(YJYOrderTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderTypeWaitPayDone),@"title":@"待支付"},
                      @{@"type":@(YJYOrderTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYOrderTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderTypeWaitPayOff),@"title":@"待结算"},
                      @{@"type":@(YJYOrderTypeDone),@"title":@"已完成"}];
        
    }else if (self.roleType == YJYRoleTypeSupervisor) {
        
        listItems = @[@{@"type":@(YJYOrderTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYOrderTypeWaitPayDone),@"title":@"待支付"},
                      @{@"type":@(YJYOrderTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYOrderTypeWaitServe),@"title":@"待服务"},
                      @{@"type":@(YJYOrderTypeServing),@"title":@"服务中"},
                      @{@"type":@(YJYOrderTypeWaitPayOff),@"title":@"待结算"},
                      @{@"type":@(YJYOrderTypeDone),@"title":@"已完成"}];
    }
    
    
    
    NSArray *items = [OrderListItem mj_objectArrayWithKeyValuesArray:listItems];
    
    return items;

}

- (NSArray *)insureListItems {
    /// 0：全部 1：已处理，2：未处理 3：待指派
    
    NSArray *listItems;
    
    if (self.roleType == YJYRoleTypeHealthManager) {
        
        listItems = @[@{@"type":@(YJYInsureTypeStateAll),@"title":@"全部"},
                      @{@"type":@(YJYInsureTypeStateApplying),@"title":@"申请中"},
                      @{@"type":@(YJYInsureTypeStateReReviewPass),@"title":@"资质通过"},
                      @{@"type":@(YJYInsureTypeStateApplyingRefuse),@"title":@"申请驳回"},
                      @{@"type":@(YJYInsureTypeStateClose),@"title":@"已关闭"}];
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        
        listItems = @[@{@"type":@(YJYInsureTypeStateAll),@"title":@"全部"},
                      @{@"type":@(YJYInsureTypeStateFirstReview),@"title":@"护士初评"},
                      @{@"type":@(YJYInsureTypeStateReReviewing),@"title":@"现场评估"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeNurse) {
        
        
        listItems = @[@{@"type":@(YJYInsureTypeStateAll),@"title":@"全部"},
                      @{@"type":@(YJYInsureTypeStateFirstReview),@"title":@"我的初评"},
                      @{@"type":@(YJYInsureTypeStateFirstReviewRefuse),@"title":@"我的驳回"},
                      @{@"type":@(YJYInsureTypeStateReReviewing),@"title":@"现场评估"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeCustomManager) {
        
        
        listItems = @[@{@"type":@(0),@"title":@"全部"},
                      @{@"type":@(1),@"title":@"未下单"},
                      @{@"type":@(2),@"title":@"已下单"}];
        
    }
    
    NSArray *items = [InsureListItem mj_objectArrayWithKeyValuesArray:listItems];
    
    return items;
}

- (NSArray *)longNurseListItems {
    /// 0：全部 1：已处理，2：未处理 3：待指派

    NSArray *listItems;
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        
        listItems = @[@{@"type":@(YJYLongNurseTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYLongNurseTypeNotReview),@"title":@"未评估"},
                      @{@"type":@(YJYLongNurseTypeReview),@"title":@"已评估"}];
        
        
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        listItems = @[@{@"type":@(YJYLongNurseTypeAll),@"title":@"全部"},
                      @{@"type":@(YJYLongNurseTypeWaitGuide),@"title":@"待指派"},
                      @{@"type":@(YJYLongNurseTypeNotReview),@"title":@"未评估"},
                      @{@"type":@(YJYLongNurseTypeReview),@"title":@"已评估"}];
        
    }else if (self.roleType == YJYRoleTypeHealthManager) {
        
        listItems = @[@{@"type":@(YJYLongNurseTypeNotReview),@"title":@"待处理"},
                      @{@"type":@(YJYLongNurseTypeReview),@"title":@"已处理"}];
        
    }
    
    NSArray *items = [ReviewListItem mj_objectArrayWithKeyValuesArray:listItems];
    
    return items;
}
- (NSArray<OrderMenuItem *> *)orderMenuItemsWithOrderInfoRsp:(GetOrderInfoRsp *)rsp {

    
    NSArray *dictS;
    
    OrderVO * orderVo = rsp.orderVo;
    YJYOrderState state = orderVo.status;
    YJYOrderPgState pgState = orderVo.pgStatus;
    BOOL isLongInsure = (orderVo.insureNo.length > 0);
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        return nil;
        
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        
        return nil;
        
    }else if (self.roleType == YJYRoleTypeWorker) {
        
        //护工
        if (state == YJYOrderStateWaitServe) {
            
            dictS = @[@{@"title":@"变更服务",@"func":@"toModifyAction"},
                      @{@"title":@"开启",@"func":@"toStartUpOrderAction"},
                      @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}
            ];
            
        }else if (state == YJYOrderStateServing) {
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"结束订单",@"func":@"toFinishOrderAction"},
                                                                      @{@"title":@"变更服务",@"func":@"toModifyAction"},
                                                        @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}
            ]];
           
            
            if (isLongInsure) {
                [itemsM insertObject:@{@"title":@"添加医疗服务",@"func":@"toAddServiceAction"} atIndex:0];
                
            }
            if (rsp.orderVo.serviceType == YJYWorkerServiceTypeMany) {
                //[itemsM addObject:@{@"title":@"收款",@"func":@"toReceivedMoneyAction"}];
            }else if (rsp.orderVo.serviceType == YJYWorkerServiceTypeOne) {
//                [itemsM addObject:@{@"title":@"协助收款",@"func":@"toHelpGatheringAction"}];

            }else if (rsp.orderVo.orderType == YJYOrderTypeHome) {
                [itemsM insertObject:@{@"title":@"协助收款",@"func":@"toHelpGatheringAction"} atIndex:0];
            }
            
            dictS = itemsM;
            
            
        }else if (state == YJYOrderStateWaitPayOff) {
        
            NSMutableArray *itemsM = [NSMutableArray array];
            if (rsp.orderVo.serviceType == YJYWorkerServiceTypeMany) {
                
                
                // 服务项确认状态 0-未确认 1-已确认
                if (rsp.orderVo.settleItemStatus == 1) {
//                    [itemsM addObject:@{@"title":@"查看结算单",@"func":@"toCheckPayOffAction"}];
                    [itemsM addObject:@{@"title":@"结算",@"func":@"toPayOffAction"}];
                }else {
                    
                    [itemsM addObject:@{@"title":@"请核对账单费用",@"func":@"toCheckPayOffAction"}];

                }
                
                
            }else {
                
//                [itemsM addObject:@{@"title":@"结算",@"func":@"toPayOffAction"}];
                [itemsM addObject:@{@"title":@"收款",@"func":@"toHgReceivedMoneyAction"}];


            }
            dictS = itemsM;

        }
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }else if (self.roleType == YJYRoleTypeHealthManager) {
        
        //健康经理
        
        
        
        if (state == YJYOrderStateWaitPay) {
            
           
            dictS = @[@{@"title":@"变更服务",@"func":@"toModifyAction"},
                      @{@"title":@"现金收款",@"func":@"toReceivedCashAction"}];

            //
            
            
        }else if (state == YJYOrderStateWaitGuide) {
            //(待评估，待派工)
            
            if (orderVo.insureType == 2) {
                
             
                if ([orderVo.statusStr containsString:@"评估"]) {
                    dictS = @[@{@"title":@"跳过评估",@"func":@"toSkipReviewAction"}];
                }else {
                
                    dictS = @[@{@"title":@"关闭订单",@"func":@"toCloseCancelOrderAction"},
                              @{@"title":@"变更服务",@"func":@"toModifyAction"},
                              @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}];
                }
            }

            
            
        }else if (state == YJYOrderStateWaitServe) {
            
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"关闭订单",@"func":@"toCloseCancelOrderAction"},
                                                                      @{@"title":@"变更服务",@"func":@"toModifyAction"},
                                                                      @{@"title":@"开启",@"func":@"toStartUpOrderAction"},
                                                                      @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}]];
            

            
            dictS = itemsM;

            
        }else if (state == YJYOrderStateServing) {
            
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"结束订单",@"func":@"toFinishOrderAction"},
                                                                      @{@"title":@"变更服务",@"func":@"toModifyAction"},
                                                                      @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}]];
      
            
            [itemsM addObject:@{@"title":@"收款",@"func":@"toReceivedMoneyAction"}];


            
            dictS = itemsM;
            
        }else if (state == YJYOrderStateWaitPayOff) {
            
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"收款",@"func":@"toPayOffAction"}]];
            dictS = itemsM;

        }else if (state == YJYOrderStateCancel) {
            
        }
        
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
        //督导
    }else if (self.roleType == YJYRoleTypeSupervisor) {
    
        
        
        if (state == YJYOrderStateWaitPay) {
            
            
            //督导
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
                NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"变更服务",@"func":@"toModifyAction"}]];
                if (rsp.dudaoChargeConfig) {
                    [itemsM addObject:@{@"title":@"收款",@"func":@"toReceivedCashAction"}];
                }
                
                
                dictS = itemsM;
                
                
            }
            
            
        }else if (state == YJYOrderStateWaitGuide) {
            //(待评估，待派工)
            
            
          
            
            dictS = @[@{@"title":@"关闭订单",@"func":@"toCloseCancelOrderAction"},
                      @{@"title":@"变更服务",@"func":@"toModifyAction"},
                      @{@"title":@"指派护工",@"func":@"toGuideAction"},
                      @{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}];
            
            
        }else if (state == YJYOrderStateWaitServe) {
            
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"关闭订单",@"func":@"toCloseCancelOrderAction"},
                                                                      @{@"title":@"变更服务",@"func":@"toModifyAction"},
                                                                      @{@"title":@"开启",@"func":@"toStartUpOrderAction"}]];
            [itemsM addObject:@{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}];
            dictS = itemsM;
            
            
        }else if (state == YJYOrderStateServing) {
            
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"结束订单",@"func":@"toFinishOrderAction"},
                                                                      @{@"title":@"变更服务",@"func":@"toModifyAction"}]];
            
//            if (rsp.dudaoChargeConfig) {
//                [itemsM addObject:@{@"title":@"收款",@"func":@"toReceivedMoneyAction"}];
//                
//            }
            [itemsM addObject:@{@"title":@"预付款充值",@"func":@"toChargePrePayAction"}];

            
            dictS = itemsM;
            
        }else if (state == YJYOrderStateWaitPayOff) {
            NSMutableArray *itemsM = [NSMutableArray array];
            // 服务项确认状态 0-未确认 1-已确认
            if (rsp.orderVo.settleItemStatus == 1) {
                //                    [itemsM addObject:@{@"title":@"查看结算单",@"func":@"toCheckPayOffAction"}];
                [itemsM addObject:@{@"title":@"结算",@"func":@"toPayOffAction"}];
            }else {
                
                [itemsM addObject:@{@"title":@"请核对账单费用",@"func":@"toCheckPayOffAction"}];
                
            }

            
            dictS = itemsM;
            
        }else if (state == YJYOrderStateCancel) {
            
            if ((rsp.needRefundExtra || rsp.needRefundPrepay)) {
                NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"退款",@"func":@"toRefundPrepayAction"}]];
                dictS = itemsM;
                
            }
        }else if (state == YJYOrderStateWaitReview) {
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"再下一单",@"func":@"toAgainOrderAction"}]];
            dictS = itemsM;
        }else if (state == YJYOrderStateDone) {
            
            NSMutableArray *itemsM = [NSMutableArray arrayWithArray:@[@{@"title":@"再下一单",@"func":@"toAgainOrderAction"}]];
            dictS = itemsM;
        }
        
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
    }
    
    return nil;

}


- (NSArray<LongNurseMenuItem *> *)LongNurseMenuItemsWithInsureNoRsp:(GetInsureDetailRsp *)rsp {
    
    NSArray *dictS;
    
    YJYInsureType state = rsp.insureNo.status;
    
     //护士
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        if (state == YJYInsureTypeStateFirstReview) {
            dictS = @[@{@"title":@"通过",@"func":@"toPass"},
                      @{@"title":@"不通过",@"func":@"toRejuct"}];
            
        }else if (state == YJYInsureTypeStateFirstReviewRefuse) {
            dictS = @[@{@"title":@"通过",@"func":@"toPass"},
                      @{@"title":@"保存",@"func":@"toSave"}];
            
        }else if (state == YJYInsureTypeStateReReviewing) {
            if (rsp.hsOperationStatus) {
                dictS = @[@{@"title":@"保存",@"func":@"toSave"}];

            }
            
        }
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
        //护士长
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        if (state == YJYInsureTypeStateFirstReview) {
            
            if (rsp.insureNo.nurseId <= 0) {
                dictS = @[@{@"title":@"指派护士",@"func":@"toGuideAction"}];
            }else {
                dictS = @[@{@"title":@"更换护士",@"func":@"toGuideAction"}];

            }
            
        }else if (state == YJYInsureTypeStateReReviewing) {
            
            if (rsp.insureNo.loseNurseId <= 0) {
                dictS = @[@{@"title":@"指派现场评估护士",@"func":@"toGuideAction"}];
            }else {
                dictS = @[@{@"title":@"更换指派",@"func":@"toGuideAction"}];
                
            }
        }
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }else if (self.roleType == YJYRoleTypeCustomManager) {
        dictS = @[@{@"title":@"预约服务",@"func":@"toBookServerAction"}];

        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }
    
    return nil;
    
    
}

- (NSArray<LongNurseMenuItem *> *)book_LongNurseMenuItemsWithInsureNoRsp:(GetInsureNoRsp *)rsp {
    
    NSArray *dictS;
    
    YJYLongNurseAgainState againStatus = rsp.againStatus;
    YJYLongNurseOrderState state = rsp.insureStatus;
    
    if (self.roleType == YJYRoleTypeNurse) {
        
        if (state == YJYLongNurseOrderStateWaitReview && againStatus == YJYLongNurseAgainStateNone) {
            dictS = @[@{@"title":@"不通过",@"func":@"toRejuct"},
                      @{@"title":@"通过",@"func":@"toPass"}];
            
        }
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }else if (self.roleType == YJYRoleTypeNurseLeader) {
        
        if (state == YJYLongNurseOrderStateWaitGuide && againStatus == YJYLongNurseAgainStateNone && rsp.insureModel.nurseId <= 0) {
            
            dictS = @[@{@"title":@"指派护士",@"func":@"toGuideAction"}];
            
        }else if (state == YJYLongNurseOrderStateWaitReview && againStatus == YJYLongNurseAgainStateNone) {
            
            dictS = @[@{@"title":@"更换护士",@"func":@"toGuideAction"}];
        }
        NSArray *items = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }else if (self.roleType == YJYRoleTypeHealthManager) {
        
        /// 下单意愿 0-未联系 1-暂不下单 2-等待下单 3-已下单

        if (rsp.insureModel.orderStatus == 0 || rsp.insureModel.orderStatus == 2) {
            
            dictS = @[@{@"title":@"暂不下单",@"func":@"toNotPlaceOrder"},
                      @{@"title":@"下单",@"func":@"toPlaceOrder"}];
        }
        NSArray *items = [LongNurseMenuItem mj_objectArrayWithKeyValuesArray:dictS];
        
        
        return items;
        
    }
    
    return nil;
    
    
}

@end
