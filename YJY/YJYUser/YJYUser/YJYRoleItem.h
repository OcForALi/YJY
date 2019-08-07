//
//  YJYRoleItem.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/14.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 0-全部 1-待指派 2-待服务 3-服务中 4-待结算 5-已完成 6-待支付
/// 0 - 全部 1 - 进行中 2 - 已完成
/// 长护险（全部--1 丨 待接单-0 丨 待支付-1 丨 待指派-2 丨待服务-3 丨 服务中-4 丨 待评价-6 丨 已完成-7 ）  、机构（0-全部 1-待指派 2-待服务 3-服务中  4-待结算 5-已完成 6-待支付）

typedef NS_ENUM(NSInteger, YJYOrderType) {
    
    YJYOrderTypeAll = 0,
    YJYOrderTypeWaitGuide = 1,
    YJYOrderTypeWaitServe = 2,
    YJYOrderTypeServing = 3,
    YJYOrderTypeWaitPayOff = 4,//(待结算)
    YJYOrderTypeDone = 5,
    YJYOrderTypeWaitPayDone= 6,
    
    //
    YJYOrderInsureTypeAll = 8,
    YJYOrderInsureTypeReceive = 0,
    YJYOrderInsureTypeWaitPay = 1,
    YJYOrderInsureTypeWaitGuide = 2,
    YJYOrderInsureTypeWaitServe = 3,
    YJYOrderInsureTypeServing = 4,
    YJYOrderInsureTypeWaitReview  = 6,
    YJYOrderInsureTypeDone= 7,
    
    YJYOrderInsureTypeCancel = -1,

    
};
/// 1-开启订单 2-续费订单 3-确认服务 4-申请评估 5-服务回访 6-照护计划制定

typedef NS_ENUM(NSInteger, YJYCalendarType) {
    
    YJYCalendarTypeOpenOrder = 1,
    YJYCalendarTypeContinueOrder = 2,
    YJYCalendarTypeComfireOrder = 3,
    YJYCalendarTypeApplyReview = 4,
    YJYCalendarTypeServiceBack = 5,
    YJYCalendarTypeCarePlan = 6,
    
};

///-1-已取消 0-待付款预交金（待付款 健康经理）,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成

typedef NS_ENUM(NSInteger, YJYOrderState) {
    
    YJYOrderStateCancel = -1,
    YJYOrderStateWaitPay = 0,
    YJYOrderStateWaitGuide = 1,//(待评估，待派工)
    YJYOrderStateWaitServe = 2,
    YJYOrderStateServing = 3,
    YJYOrderStateWaitPayOff = 4,//(待结算)
    YJYOrderStateWaitReview= 5,
    YJYOrderStateDone = 6,
    
};
/// 评估状态 0-待评估 1-已评估 2-跳过评估
typedef NS_ENUM(NSInteger, YJYOrderPgState) {
    
    YJYOrderPgStateWait = 0,
    YJYOrderPgStateDone = 1,
    YJYOrderPgStateSkip = 2,
    
};
//@property(nonatomic, readwrite) uint32_t pgStatus;

typedef NS_ENUM(NSInteger, YJYInsureType) {
    /// 状态状态 -1-全部 0-客服审核 1-护士初审 2-等待提交复审 3-等待复审 4-复审通过 5-复审中 6-申请中 7-申请驳回 50-客服驳回 51-初审驳回 52-复审驳回 53-已关闭
  

    YJYInsureTypeStateAll = -1,
    YJYInsureTypeStateCSReviewing = 0, //0-客服审核
    YJYInsureTypeStateFirstReview = 1, // 1-护士评估
    YJYInsureTypeStateWaitReSubmitReview = 2, //2-等待提交复审/等待提交评估机构
    YJYInsureTypeStateWaitReReview = 3, //3-等待复审/等待专家现场评估
    YJYInsureTypeStateReReviewPass = 4, //4-复审通过/评审通过
    YJYInsureTypeStateReReviewing = 5, //5-复审中/现场评估中
    YJYInsureTypeStateApplying = 6, //6-申请中
    YJYInsureTypeStateApplyingRefuse = 7, //7-申请驳回
    YJYInsureTypeStateCSRefuse = 50,//50-客服驳回
    YJYInsureTypeStateFirstReviewRefuse = 51, //51-初评驳回
    YJYInsureTypeStateReReviewRefuse = 52, //52-复审驳回/评审驳回
    YJYInsureTypeStateClose = 53, //53-已关闭
    
};

typedef NS_ENUM(NSInteger, YJYLongNurseType) {
    /// 0：全部 1：已处理，2：未处理 3：待指派
    YJYLongNurseTypeWaitGuide = 3,
    YJYLongNurseTypeNotReview = 2,
    YJYLongNurseTypeReview = 1,
    YJYLongNurseTypeAll = 0
    
};

typedef NS_ENUM(NSInteger, YJYLongNurseOrderState) {

    /// 订单状态 1:待指派 2：待评估 3：已评估
    
    YJYLongNurseOrderStateWaitGuide = 1,
    YJYLongNurseOrderStateWaitReview = 2,
    YJYLongNurseOrderStateReview = 3,
    
    
//    /// 状态 0-提交申请 1-初审通过 2-复审通过 3-等待提交终审  4-终审通过 50-初审驳回 51-复审驳回 52-终审驳回
//    
//    YJYLongNurseOrderStateSumbit = 0,
//    YJYLongNurseOrderStateFirstPass = 1,
//    YJYLongNurseOrderStateSecondPass = 2,
//    YJYLongNurseOrderStateWaitFinial = 3,
//    YJYLongNurseOrderStateFinialPass = 4,
//    YJYLongNurseOrderStateFirstRefuse = 50,
//    YJYLongNurseOrderStateSecondRefuse = 51,
//    YJYLongNurseOrderStateFinialRefuse = 52
    
};
typedef NS_ENUM(NSInteger, YJYLongNurseActionType) {
    
    YJYLongNurseActionTypeReview,
    YJYLongNurseActionTypeBook,
};


typedef NS_ENUM(NSInteger, YJYLongNurseAgainState) {
    /// 复审评估结果 0:未操作 1:通过 2：不通过
    YJYLongNurseAgainStateNone = 0,
    YJYLongNurseAgainStatePass = 1,
    YJYLongNurseAgainStateNoPass = 2,
    
};

typedef NS_ENUM(NSInteger, YJYWorkbenchType)  {
    
    YJYWorkbenchTypeMyReview,
    YJYWorkbenchTypeMyCalendar,
    YJYWorkbenchTypeMyNurse,
    YJYWorkbenchTypeMyWork,
    YJYWorkbenchTypeMyData,
    YJYWorkbenchTypeCreateOrder,
    YJYWorkbenchTypeBookOrder,
    YJYWorkbenchTypeHomeReview,
    YJYWorkbenchTypeKPI,
    YJYWorkbenchTypeInsureAdd,
    YJYWorkbenchTypeInsureManager,
    YJYWorkbenchTypeSignAgreement,
    
    YJYWorkbenchTypePayoffStatistics,
    YJYWorkbenchTypeServiceStatistics,
    YJYWorkbenchTypeReviewStatistics,
    YJYWorkbenchTypeOutInStatistics,
    
    YJYWorkbenchTypeAbnormalOrder,
    YJYWorkbenchTypeisPRCOrder,

};

typedef NS_ENUM(NSInteger,YJYOrderPaymentAdjustType) {
    
    YJYOrderPaymentAdjustTypeNone,//普通
    
    YJYOrderPaymentAdjustTypeServingModify, //变更
    
    YJYOrderPaymentAdjustTypePayoffPaymentCheck, //机构待结算调整
    YJYOrderPaymentAdjustTypeServingPayoffEnding, //结束服务
    
    YJYOrderPaymentAdjustTypeAdjustSection,//转科

    
};

@interface WorkbenchItem : NSObject

@property (assign, nonatomic) YJYWorkbenchType type;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *des;

@end

@interface OrderMenuItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *func;

@end

@interface LongNurseMenuItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *func;

@end

@interface OrderListItem : NSObject

@property (assign, nonatomic) YJYOrderType type;
@property (copy, nonatomic) NSString *title;

@end

@interface CalendarListItem : NSObject

@property (assign, nonatomic) YJYCalendarType type;
@property (copy, nonatomic) NSString *title;

@end

@interface ReviewListItem : NSObject

@property (assign, nonatomic) YJYLongNurseType type;
@property (copy, nonatomic) NSString *title;

@end

@interface InsureListItem : NSObject

@property (assign, nonatomic) YJYInsureType type;
@property (copy, nonatomic) NSString *title;

@end


@interface YJYRoleItem : NSObject

@end
