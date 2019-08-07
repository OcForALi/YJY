//
//  YJYNetworkManager.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/21.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>

//dev
//test
//www


//#ifdef DEBUG
//#define BasePre @"dev"
//#elses
//#endif

//#define BasePre [YJYSettingManager sharedInstance].env
#define BasePre @"test"
//#define BaseProtocal [YJYSettingManager sharedInstance].urlTypeStr

#define BASEURL [NSString stringWithFormat:@"http://%@.1-1dr.com",BasePre]
#define BaseAPI [NSString stringWithFormat:@"%@/api",BASEURL] 


//url
#define kInsureQuestionURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/test"]
#define kUserAgreement [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/agreement"]

#define kMMSEURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/mmseassess"]

#define kADLURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/adlassess"]
#define kUserassessURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/userassess"]
#define kHomeAssessURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/homeassess"]
#define kInsureserviceintro [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/insureserviceintro"]//长护险服务详情 insureNO=201801041532557212207&priceId=12195
#define kInsurelifesign [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/insurelifesign"]//回访生命体征
#define kInsureqccontent [NSString stringWithFormat:@"%@/%@",BASEURL,@"sass/index.html#/insureqccontent"]//回访质控内容

//pro
#define kUserKnowedURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/userknowing"] //用户知情书 orderId= 44676920452841472
#define kSickURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/illnessdetail"] //病史描述 insureNO = 123
#define kManagerAchieve [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/manageachieve"] //sid
#define kBankFAQURL  [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/bankquestion"] //bankquestion
#define kRolelp [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/rolelp"]

#define kDdservicecount [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/ddservicecount"] //督导服务统计
#define kDdordercount [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/ddordercount"] //督导结算统计
#define kDdassesscount [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/ddassesscount"] // 督导评价统计

#define kHgordercount [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/hgordercount"] //护工结算
#define kInsureskilltrain [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/insureskilltrain"] //orderId&visitId 回访技能培训
#define kInsureteachskill [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/insureteachskill"]

#define kSAASInsurelifesign [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/insurelifesign"]//回访生命体征
#define kSAASInsureqccontent [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/insureqccontent"]//回访质控内容

#define kSAASADLURL [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/adlassess"]

#define kInsureUserKnowing [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/insureUserKnowing"] //长护险知情书
#define kUserKnowing [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/userKnowing"] //知情书

#define kprcorder [NSString stringWithFormat:@"%@/%@",BASEURL,@"roleapp/index.html#/prcorder"] //陪人床





//api

#define PingAPI [NSString stringWithFormat:@"%@/%@",BaseAPI,@"Ping"]
#define GetSMSCode [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetSMSCode"]
#define Login [NSString stringWithFormat:@"%@/%@",BaseAPI,@"Login"]
#define APPGetSettings [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetSettings"]
#define GetSplash [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetSplashScreen"]
#define AppVersionCheck [NSString stringWithFormat:@"%@/%@",BaseAPI,@"AppVersionCheck"]
#define GetRongToken [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetRongToken"]
#define UploadImage @"http://upload.1-1dr.com/fileupload"
#define IDCardRecognize [NSString stringWithFormat:@"%@/%@",BaseAPI,@"IDCardRecognize"]

//current
#define APPIndex [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPIndex"]

//address

#define APPAddUserAddress [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddUserAddress"]
#define APPUpdateUserAddress [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPUpdateUserAddress"]
#define APPDelUserAddress [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPDelUserAddress"]
#define APPListUserAddress [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPListUserAddress"]

#define APPSetDefaultAddress [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPSetDefaultAddress"]


//user
#define APPGetUserInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetUserInfo"] //查看个人资料
#define APPUpdateUserInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPUpdateUserInfo"] //更新资料
#define APPGetUserSystemMessage [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetUserSystemMessage"]
#define APPSetDefaultKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPSetDefaultKinsfolk"]

#define APPGetMsgList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetMsgList"] // GetUserMsgByTypeReq  GetUserMsgByTypeRsp
#define AppGetUserMsgByType [NSString stringWithFormat:@"%@/%@",BaseAPI,@"AppGetUserMsgByType"]
//member

#define APPAddKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddKinsfolk"]
#define APPUpdateKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPUpdateKinsfolk"]
#define APPDelKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPDelKinsfolk"]
#define APPListKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPListKinsfolk"]
#define APPGetKins [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetKins"]

//login
#define SAASAPPScanLogin [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPScanLogin"]
#define Applogout [NSString stringWithFormat:@"%@/%@",BaseAPI,@"Applogout"]
#define APPAddFeedBack [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddFeedBack"]

//pay
#define APPDoPay [NSString stringWithFormat:@"%@/%@",BaseAPI,@"DoPay"]
#define GetDoPay [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetDoPay"]
#define GetRechargeSetting [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetRechargeSetting"]
#define Appwithdraw [NSString stringWithFormat:@"%@/%@",BaseAPI,@"Appwithdraw"]
#define APPGetUserAccount [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetUserAccount"]


//order


#define APPCreateOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPCreateOrder"]
#define APPPrePayAmountDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPPrePayAmountDetail"] // 支付预交金详情页接口
#define APPGetOrderDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderDetail"]
#define APPSettlPayDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPSettlPayDetail"]


#define APPConfirmOrderFinish [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPConfirmOrderFinish"]//GetOrderReq GetOrderDetailRsp接口
//住院手环识别和入院通知书识别
#define OrgNORecognize [NSString stringWithFormat:@"%@/%@",BaseAPI,@"OrgNORecognize"] // OrgNORecognizeReq OrgNORecognizeRsp

#define APPDoPay [NSString stringWithFormat:@"%@/%@",BaseAPI,@"DoPay"] // DoPayReq idsOrFee 字段传 orderId operation字段 传 PAY_Preamount paytype
#define APPGetPayType [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetPayType"]

#define APPCancelOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPCancelOrder"] //CancelOrderNewReq
#define APPListSettlement [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPListSettlement"] //获取结算列表接口 GetOrderReq ListSettlementRsp
#define APPListOrderItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPListOrderItem"] //获取每日明细列表接口 SettlementReq ListOrderItemRsp
#define APPSaveOrderPraise [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPSaveOrderPraise"]  // 评价接口	SaveOrderPraiseReq
#define APPGetOrderPraise [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderPraise"]  //  获取评价接口	GetOrderPraiseReq
#define APPSettlPayDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPSettlPayDetail"] //中途支付详情页接口 SettlPayDetailReq/Rsp


//hospital

#define APPGetOrgAndBranch [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrgAndBranch"] // 获取机构和科室列表
#define APPGetRoomAndBed [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetRoomAndBed"] // 获取房间和床位列表
#define APPGetPrice [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetPrice"] //	获取科室的定价列表
#define AppgetOrderList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"AppgetOrderList"]
#define APPGetPayDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetPayDetail"]
#define APPGetOrderTime [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTime"]

#define APPGetOrderListNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderListNew"] //GetOrderListReq


//Insure

#define APPAddInsure [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddInsure"] // 申请长护险 AddInsureReq AddInsureRsp
#define APPGetInsureDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureDetail"] // 获取申请详情 GetInsureReq GetInsureRsp
#define APPGetInsureList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureList"] // 获取申请单列表 GetInsureListReq
#define APPGetInsureAccount [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureAccount"] //  获取长护险资格人列表 GetInsureAccountRsp
#define APPGetInsureAccountDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureAccountDetail"] 
//  获取长护险补贴明细 GetInsureAccountDetailReq

#define APPForceSubmitInsure [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPForceSubmitInsure"] // 继续提交 GetInsureReq


//org
#define APPGetOrgList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrgList"] // 获取机构

//bank
#define APPListUserBank [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPListUserBank"] // 用户银行卡列表 ListBankRsp
#define APPAddUserBank   [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddUserBank"] // 添加用户银行卡信息 AddUserBankReq
#define APPUpdateUserBank [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPUpdateUserBank"] // 修改用户银行卡信息 AddUserBankReq

#define APPGetUserInfoByOrgNO [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetUserInfoByOrgNO"] // 通过住院号获取用户信息 GetUserInfoByOrgNOReq GetUserInfoByOrgNORsp


#define APPGetInsureOrderInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureOrderInfo"] //获取长护险下单信息 GetInsureOrderInfoReq GetInsureOrderInfoRsp


#define APPGetInsurePriceList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsurePriceList"]  //获取长护险服务定价 GetInsurePriceListReq GetInsurePriceListRsp

#define APPAddInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPAddInsureOrder"]  //长护险下单 AddInsureOrderReq AddInsureOrderRsp

//照护计划

#define APPGetOrderTendDetail  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTendDetail"]  // 照护计划详情 GetOrderTendDetailReq GetOrderTendDetailRsp
#define APPGetOrderTendList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTendList"]  // 照护计划列表 GetOrderTendListReq GetOrderTendListRsp

#define APPGetReckonSubsidy  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetReckonSubsidy"]  // 获取补贴估算 GetOrderReq GetReckonSubsidyRsp

#define APPGetHomeOrderDetail  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTendDetail"]  // 获取居家长护险订单详情 GetOrderReq GetHomeOrderDetailRsp
#define APPGetInsureOrderTendItemDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTendDetail"] // 获取每日服务详情 GetInsureOrderTendItemDetailReq GetInsureOrderTendItemDetailRsp
#define APPGetHGInfoByOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetHGInfoByOrder"] //GetHGInfoByOrderReq 获取护工或护士信息
#define APPGetOrderTendList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetOrderTendList"] //照护计划列表 GetOrderTendListReq

#define APPGetInsureOrderTendItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureOrderTendItem"] // 获取订单每日明细列表 GetInsureOrderTendItemReq GetInsureOrderTendItemRsp
#define APPGetInsureOrderVisitDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureOrderVisitDetail"] //获取回访详情 DeteleInsureOrderVisitReq GetInsureOrderVisitDetailRsp
#define APPGetInsureOrderVisitList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"APPGetInsureOrderVisitList"] //回访记录列表 GetInsureOrderVisitListReq
#define GetInsureDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetInsureDetail"]


/*========================== 企业端 ========================================*/

#pragma mark -企业端

#define SAASAPPGetSettings [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetSettings"] // 获取Setting
#define SAASAPPGetScheduleList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetScheduleList"] // 获取日程表信息 GetScheduleList
#define SAASAPPGetSchedule  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetSchedule"] // 我的日程 GetScheduleReq GetScheduleRsp
#define SAASAPPScan [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPScan"] // 企业端扫码 ScanReq ScanRsq



//订单

#define SAASAPPGetOrderList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderList"] // 获取订单列表 GetOrderListReq
#define SAASAPPGetOrderInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderInfo"] // GetOrderInfoReq GetOrderInfoRsp order订单详情
#define SAASAPPSaveOrUpdateOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateOrder"] // 更改服务  督导、健康经理、护工开启关闭服务 SaveOrUpdateOrderReq OrderJPushReq SaveOrderItemReq
#define SAASAPPStartOrgOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPStartOrgOrder"] // 督导、护工开启 StartOrgOrderReq
#define SAASAPPGetOrderReceptionTime [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderReceptionTime"] // 获取订单接诊时间 GetOrderInfoReq GetOrderReceptionTimeRsp




#define SAASAPPCancelOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCancelOrder"] //取消关闭订单 GetOrderReq


#define SAASAPPListOrderItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPListOrderItem"] // SettlementReq ListOrderItemRsp 每日明细
#define SAASAPPSaveOrderItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrderItem"] // SaveOrderItemReq 确认服务
#define SAASAPPConfirmOrderItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrderItem"] // SaveOrderItemReq 护工、督导、健康经理服务确认
#define SAASAPPCancelOrderItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCancelOrderItem"] // 取消关闭订单项 CancelOrderReq

#define SAASAPPSettlPayDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSettlPayDetail"] // SettlPayDetailReq SettlPayDetailRsp 健康经理，督导订单支付详情页
#define SAASAPPCreateOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCreateOrder"] // 创建订单Req

#define SAASDoPay [NSString stringWithFormat:@"%@/%@",BaseAPI,@"DoPay"] // DoPayReq
#define SAASGetOrderItemInvertList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASGetOrderItemInvertList"] //附加服务调整明细 GetOrderProcessReq OrderItemInvertRsp

#define SAASAPPRechargePrepayFee [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPRechargePrepayFee"] // 充值预付款 RechargePrepayFeeReq

#define SAASAPPConfirmOrderFinish [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmOrderFinish"] //完成订单 GetOrderReq

//create

#define SAASAPPCreateInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCreateInsureOrder"] // 新增长护险order订单
#define SAASAPPSaveInsureAssess [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveInsureAssess"] // 更新更新订单信息
#define SAASAPPGetOrderTime [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderTime"] // 取消关闭订单项 CancelOrderReq

#define SAASAPPGetOrderPriceInvert [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderPriceInvert"] //获取附加项列表及反显数据 GetOrderInfoReq GetPriceListRsp

#define SAASAPPGetPriceList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetPriceList"] // SaveOrderItemReq GetPriceListRsp 获取长护险和普通附加服务（加服务次数）
#define SAASAPPAddOrderPrice [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddOrderPrice"] // AddOrderPriceReq 添加订单附加服务（医疗、普通服务
#define SAASAPPCreateDiffnoUser [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCreateDiffnoUser"] //  CreateDisffnoUserRsp 生成异号用户

//长护险
#define SAASAPPGetInsureAccountDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddOrderPrice"] // GetInsureAccountDetailReq 获取长护险补贴明细
#define SAASAPPUpdateOrderSignPic [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddOrderPrice"] // UpdateOrderSignPicReq 保存或修改被陪护人order订单签名
#define SAASAPPGetInsureDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureDetail"] // 获取长护险申请单详情 GetInsureDetailReq GetInsureDetailRsp



//变更
#define SAASAPPGetOrderService  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderService"] // 变更服务详情 GetOrderProcessReq GetOrderServiceRsp
#define SAASAPPGetOrderProcessList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderProcessList"] // 变更记录 GetOrderProcessReq
#define SAASAPPUpdateOrderServe  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateOrderServe"] // 督导、健康经理护工 变更服务 UpdateOrderServeReq
#define SAASAPPUpdateOrderServicePrice  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateOrderServicePrice"] //UpdateOrderServeReq UpdateOrderServicePriceRsp

#define SAASAPPGuideStaffNew  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGuideStaffNew"] //指派护士/护工 GuideStaffReq
#define SAASAPPGetAssignList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetAssignList"] //获取护士长指派列表 GetAssignListReq GetAssignListRsp

#define SAASAPPOrderJPush  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPOrderJPush"] // Push
#define SAASAPPAddOrderPriceItemRevise [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddOrderPriceItemRevise"] //修改订单校正服务并关闭服务 AddOrderPriceReviseReq

#define SAASAPPUpdateOrderHG [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateOrderHG"] //变更订单护工（只针对于非承包制普陪订单）UpdateOrderHGReq




//评估

#define SAASAPPGetInsureAssess [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureAssess"] // 评估详情 GetInsureReq
#define SAASAPPInsureAssessMedical [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPInsureAssessMedical"] // 添加病例
#define SAASAPPGetInsureMedicalList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureMedicalList"] // 病史列表
#define SAASAPPInsureAssessFirst [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPInsureAssessFirst"] //  通过 InsureAssessFirstReq
#define SAASAPPInsureAssess [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPInsureAssess"]

#define SAASAPPSkipAssessOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrderItem"] // SaveOrderItemReq 确认服务


#define SAASAPPGetAssessList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetAssessList"] //评估列表  护士、护士长、健康经理申请单列表 添加订单附加服务（医疗、普通服务 GetAssessListReq GetAssessListRsp
#define SAASAPPUpdateInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateInsureOrder"] // 修改申请单预约上门下单时间和设置暂不下单 UpdateInsureOrderReq





//Insure
#define SAASAPPSaveInsureAssess [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveInsureAssess"] // 修改长护险申请单身高。体重等信息


//create 套餐

#define SAASAPPGetOrgAndBranch [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrgAndBranch"] // 获取机构与科室列表 GetOrgAndBranchListRsp
#define SAASAPPGetRoomAndBed [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetRoomAndBed"] // 获取房号床位列表 GetRoomListReq GetRoomListRsp


#define SAASAPPGetPrice [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetPrice"] // 获取套餐
#define SAASAPPAddKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddKinsfolk"] // 添加亲属 KinsfolkReq CreateKinsfolkRsp

#define SAASAPPRechargePrepayFee [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPRechargePrepayFee"] //RechargePrepayFeeReq
//Info

#define SAASAPPGetHgInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHgInfo"] // GetHgInfoRsp 获取护工、护士、护士长、健康经理、督导信息
#define SAASAPPUpdateHgInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateHgInfo"] // UpdateHgInfoReq 更新护工、护士、护士长、健康经理、督导信息
#define SAASAPPGetHGList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHGList"] // 获取护工、护士列表 GetHgReq GetHgRsp


//saas家庭信息
#define SAASAPPGetUserKinsList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetUserKinsList"] // 获取亲属列表 GetUserReq GetUserKinsListRsp
#define SAASAPPGetKins [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetKins"] //获取被陪护人信息 GetKinsfolkReq
#define SAASAPPUpdateKinsfolk [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateKinsfolk"] //更新用户亲属信息 KinsfolkReq AddKinsfolkRsq
#define SAASAPPDelKinsfolk  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPDelKinsfolk"] //删除用户亲属信息 DelKinsfolkReq

//address

#define SAASAPPDelUserAddress  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPDelUserAddress"] //删除用户地址信息 DelUserAddressReq
#define SAASAPPUpdateUserAddress  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateUserAddress"] //修改用户服务地址 UserAddressReq
#define SAASAPPAddUserAddr  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddUserAddr"] //添加服务地址 AddUserAddrReq AddUserAddrRsp
#define SAASAPPGetUserAddrList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetUserAddrList"] // 获取地址列表 GetUserReq GetUserAddrListRsp






//login & sign


#define SAASAPPCheckUserExist  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckUserExist"] //判断手机号用户是否存在 UserExistReq UserExistRsp
#define SAASAPPSignUserInfo [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSignUserInfo"] // SignUserReq 注册用户

#define SAASAPPGetMsgList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetMsgList"] //获取消息列表

#define SAASAPPGetMsgByType [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetMsgByType"] //GetUserMsgByTypeReq


#define SAASAPPGetMessageList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetMessageList"] //获取消息列表 GetSystemMsgReq GetSystemMsgRsp


#define SAASAPPUpdateMessageRead  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateMessageRead"] //标记消息已读 SystemMsgMarkAsReadReq
#define SAASAPPAddFeedBack [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddFeedBack"] //企业端提交意见反馈 FeedBackReq
#define SAASAPPRefundOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPRefundOrder"] //订单已取消后退款 RefundOrderReq
#define SAASAPPAddInsure [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddInsure"] // 企业端添加长护险 AddInsureReq AddInsureRsq
#define SAASAPPGetInsureList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureList"] // 长护险列表 GetInsureListReq GetInsureListFirmRsp
#define SAASAPPGetInsureRecheckList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureRecheckList"] // 长护险列表 GetInsureListReq GetInsureListFirmRsp

#define SAASAPPSaveOrUpdateInsure [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateInsure"]
//长护险申请单添加数据及修改 SaveOrUpdateInsureReq


#define SAASAPPCheckPayState [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckPayState"] //轮询支付状态 ScanLoginReq
#define GetQRCode [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetQRCode"] //获取（二维码） accessToken orderId



//调整
#define SAASAPPGetOrderItemDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderItemDetail"] // 订单服务项详情（修改时） GetOrderProcessReq GetOrderItemRsp
#define SAASAPPGetOrderItemDetailNowInvert [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderItemDetailNowInvert"] // 订单今日陪人床反显 GetOrderProcessReq GetOrderItemRsp
#define SAASAPPUpdateOrderRebate [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateOrderRebate"] //修改订单优惠方式或者优惠金额 AddOrderPriceReviseReq
#define SAASAPPSaveOrUpdateOrderNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateOrderNew"] //督导、健康经理、护工开启关闭服务（新） SaveOrUpdateOrderReq
#define SAASAPPCreateOrUpdateOrderItemPrice [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCreateOrUpdateOrderItemPrice"]  //修改订单服务项详情 AddOrderPriceReviseReq


#define SAASAPPGetOrderItemNightList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderItemNightList"]  //获取订单夜陪服务信息 OrderItemNightReq OrderItemNightRsp

#define SAASAPPSaveOrUpdateOrderItemNight [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateOrderItemNight"]  //  创建修改删除订单夜陪服务 SaveOrUpdateOrderItemNighReq

#define SAASAPPGetStaffList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetStaffList"]  //获取护工列表 GetStaffListReq GetHgRsp
#define SAASAPPUpdateOnduty [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetStaffList"] //UpdateOndutyReq  切换督导的值班状态 是否值班中 0-未值班 1-值班中



#define SAASAPPGetOrderListNew  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderListNew"] // 企业端获取订单列表 GetOrderListNewReq


//照护计划
#define SAASAPPGetMyWorkbench [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetMyWorkbench"]  // 企业端工作台 GetMyWorkbenchRsp

//下单
#define SAASAPPGetInsurePriceList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsurePriceList"] // 获取长护险服务定list
#define SAASGetInsurePriceNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASGetInsurePriceNew"] // 获取长护险服务定价
#define SAASAPPGetInsureOrderInfo  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderInfo"]  // 下单：获取返显信息 GetInsureOrderInfoReq  GetInsureOrderInfoRsp
#define GetHGIdcardByPhone [NSString stringWithFormat:@"%@/%@",BaseAPI,@"GetHGIdcardByPhone"]  // 下单，通过收紧号判断信息

#define SAASAPPAddInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddInsureOrder"] // 下单 AddInsureOrderReq
#define SAASAPPAddInsureOrderTeach [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddInsureOrderTeach"] // 创建长护险带教服务 AddInsureOrderReq

//订单
#define SAASAPPGetOrderListNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderListNew"] //企业端获取订单列表 
#define SAASAPPGetInsureOrderDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderDetail"] //订单详情：GetInsureOrderDetailReq   GetInsureOrderDetailRsp
#define SAASAPPCancelOrderNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCancelOrderNew"] // 企业端取消订单 CancelOrderNewReq
#define SAASAPPAcceptInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAcceptInsureOrder"] // 待接单状态接单并状态扭转到待派工 GetKinsInsureReq
#define SAASAPPGrantInsureOrder  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGrantInsureOrder"] // 发放资质 GetKinsInsureReq
#define SAASAPPSaveOrUpdateInsureOrderRelation [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateInsureOrderRelation"] // 变更陪护家属 SaveOrUpdateInsureOrderRelation
#define SAASAPPOpenInsureOrder   [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPOpenInsureOrder"] // 开启服务
#define SAASAPPFinishInsureOrder   [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPFinishInsureOrder"] // 结束服务
#define SAASAPPInsureOrderJPush [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPInsureOrderJPush"] // 护工申请操作服务 OrderJPushReq
#define SAASAPPUpdateInsureOrderAddr [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateInsureOrderAddr"] // 变更联系方式

#define SAASAPPTransferInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPTransferInsureOrder"] //转出订单

//护士

#define SAASAPPGetHomeStaffList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHomeStaffList"] // 获取护士列 GetHomeStaffListReq GetHomeStaffListRsp
#define SAASAPPAssignInsureHG  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAssignInsureHG"] // 指派or更换护士 AssignInsureHGReq GetinsureHGListRsp
#define SAASAPPGetHGInfoByOrder  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHGInfoByOrder"] // 护士 
#define SAASAPPGuideStaffInsureOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGuideStaffInsureOrder"] //指派护工 GuideStaffReq

//历史回访
#define  SAASAPPDeleteInsureOrderVisit [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPDeleteInsureOrderVisit"] // 删除
#define  SAASAPPUpdateInsureOrderVisit [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateInsureOrderVisit"] // 修改回访记录信息 UpdateInsureOrderVisitReq
#define  SAASAPPAddInsureOrderVisit [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddInsureOrderVisit"] // 新增回访记录信息 AddInsureOrderVisitReq AddInsureOrderVisitRsp


#define SAASAPPGetInsureOrderVisitList  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderVisitList"] //回访记录列表 GetInsureOrderVisitListReq

#define SAASAPPGetInsureOrderVisitDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderVisitDetail"] //获取回访详情 DeteleInsureOrderVisitReq GetInsureOrderVisitDetailRsp

//照护计划
#define SAASAPPGetOrderTendList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderTendList"] //照护计划列表 GetOrderTendListReq
#define SAASAPPGetOrderTendDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderTendDetail"] //照护计划详情 orderId, tendId
#define SAASAPPSaveOrUpdateOrderTendDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateOrderTendDetail"] //保存照护计划明细 SaveOrderTendDetailReq

#define SAASAPPGetOrderTendDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderTendDetail"] //获取照护计划回显 GetOrderTendDetailReq
#define SAASAPPSaveOrderTend [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrderTend"] //新增 SaveOrderTendReq
#define SAASAPPDelOrderTend [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPDelOrderTend"] //删除 DelOrderTendReq
#define SAASAPPGetTendDetailList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetTendDetailList"]  // 列表模板添加 GetTendDetailListReq

#define SAASAPPSubmitOrderTend [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSubmitOrderTend"] //提交照护计划 SubmitOrderTendReq
#define SAASAPPCopyOrderTend [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCopyOrderTend"] //复制照护计划 CopyOrderTendReq CopyOrderTendRsp
#define SAASAPPCheckInsureOrderTend [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckInsureOrderTend"] //通过不通过 CheckInsureOrderTendReq 


//每日明细
#define SAASAPPGetInsureOrderTendItem [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderTendItem"]
#define SAASAPPGetInsureOrderTendItemDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderTendItemDetail"]


//考核
#define SAASAPPGetInsureOrderCheckList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderCheckList"] //订单考核列表 GetKinsInsureReq GetInsureOrderCheckListRsp
#define SAASAPPAddInsureOrderCheck [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddInsureOrderCheck"] //添加添加试用期考核 APPAddInsureOrderCheckReq

//费用
#define SAASAPPGetReckonSubsidy  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetReckonSubsidy"]  // 获取补贴估算 GetOrderReq GetReckonSubsidyRsp

//人员
#define SAASAPPGetHgApply [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHgApply"] //获取自照家属信息 GetKinsInsureReq GetHgAppRsp

#define SAASAPPGetHGInfoByOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHGInfoByOrder"] //GetHGInfoByOrderReq 获取护工或护士信息
#define SAASAPPGetKinsInsure [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetKinsInsure"] //获取长护险被陪护人信息 GetKinsInsureReq GetHgAppRsp

//带教记录
#define SAASAPPGetTeachRecord [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetTeachRecord"] //GetTeachRecordReq
#define SAASAPPGetInusreOrderTeachRecord [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInusreOrderTeachRecord"] //获取带教记录列表 GetOrderReq GetInusreOrderTeachRecordRsp
#define SAASAPPGetTeachRecord [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetTeachRecord"] // 获取带教记录 GetTeachRecordReq
#define SAASAPPAddTeachRecord  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPAddTeachRecord"] //  添加带教记录
//orderId, startTime, endTime, trainTime(培训时长), exerciseTime(练习时长), exerciseContent(练习内容), trainContent(考核内容), selfPraise(带教对象自我评价), hgPraise(带教人员自我评价), remark, pics, selfSign, hgSign
#define SAASAPPGetTeachRecordTmpValue  [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetTeachRecordTmpValue"] //  获取带教记录培训内容和考核内容临时值变量 GetTeachRecordTmpValueReq


//A+
#define SAASAPPConfirmNewOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmNewOrder"] // 转科室时确认新订单信息 ConfirmNewOrderReq ConfirmNewOrderRsp
#define SAASAPPConfirmOrderFinishNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmOrderFinishNew"] //确认订单完成 ConfirmOrderFinishNewReq

//确认服务
#define SAASAPPConfirmInsureOrderTendItemDetail [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmInsureOrderTendItemDetail"] //
//确认长护险订单每日明细 ConfirmInsureOrderTendItemDetailReq ConfirmInsureOrderTendItemAddrRsp
#define SAASAPPConfirmInsureOrderTendItemAddr [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmInsureOrderTendItemAddr"] //ConfirmInsureOrderTendItemAddrReq

#define SAASAPPGetTeachRecordTmpValue [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetTeachRecordTmpValue"] // 获取考核 / 培训内容 GetTeachRecordTmpValueReq


//================//

#define SAASAPPGetOrderAdjustStatus [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderAdjustStatus"] // 获取订单可调整状态和费用 GetOrderInfoReq GetOrderAdjustStatusRsp
#define SAASAPPConfirmOrderAdjustStatus [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmOrderAdjustStatus"] // 确认订单调整信息 GetOrderInfoReq
#define SAASAPPGetOrgAndBranchNew [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrgAndBranchNew"] // 获取机构与科室（新，根据人员列表配置机构科室）GetOrgAndBranchReq GetOrgAndBranchListRsp

//========意见反馈

#define SAASAPPGetFeedBackList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetFeedBackList"] // 获取员工意见反馈列表 GetFeedBackListRsp

#define SAASAPPGetFeedBack [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetFeedBack"] // 获取反馈信息 GetFeedBackReq


//出入院

#define SAASAPPGetUserSituation [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetUserSituation"] // 出入院统计 GetUserSituationReq
#define SAASAPPGetUserSituationList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetUserSituationList"] // 获取出院统计列表 GetUserSituationListReq


//回访列表
#define SAASAPPGetInsureOrderVisitListHS [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetInsureOrderVisitListHS"] // 护士回访列表 GetInsureOrderVisitListHSReq GetInsureOrderVisitListRsp
#define SAASAPPNeglectOrderSignPic [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPNeglectOrderSignPic"] //跳过订单签名 GetOrderReq


//恢复订单
#define SAASAPPSearchAbnormalOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSearchAbnormalOrder"] //异常订单管理搜索订单 SearchAbnormalOrderReq
#define SAASAPPRecoverOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPRecoverOrder"] //恢复订单（把待结算的订单恢复到服务中） OrderItemNightReq


#define SAASAPPSaveOrUpdateHgSign [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPSaveOrUpdateHgSign"] //新增修改员工签名信息 SaveOrUpdateHgSignReq
#define SAASAPPGetHgSign [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetHgSign"] //获取员工签名信息 GetHgSignRsp


//结束订单
#define SAASAPPCheckFinishOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckFinishOrder"] //校验是否可以结束订单 GetOrderInfoReq CheckFinishOrderRsp

//是否重下单
#define SAASAPPGetOrderRepetition [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderRepetition"] //获取订单是否重复下单 OrderRepetitionReq OrderRepetitionRsp
#define SAASAPPCheckFinishOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckFinishOrder"] //校验是否可以结束订单 GetOrderInfoReq CheckFinishOrderRsp
#define SAASAPPGetOrgNOOrderList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrgNOOrderList"] //获取订单住院号有多少待结算 GetOrderReq GetOrgNOOrderListRsp


//批量结算订单

#define SAASAPPBatchSettleOrder [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPBatchSettleOrder"] //批量结算订单

//订单结算前校验当前是否需要合并结算
//GetOrderInfoReq
//CheckOrderSettleRsp
#define SAASAPPCheckOrderSettle [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPCheckOrderSettle"] 

#define SAASAPPConfirmOrderBatchFinish [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPConfirmOrderBatchFinish"] //ConfirmOrderBatchFinishReq

//修改出入院未下单状态
#define SAASAPPUpdateUserSitution [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPUpdateUserSitution"] //UpdateUserSitutionReq
#define SAASAPPGetOrderPRCItemList [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetOrderPRCItemList"] //企业端获取订单陪人床签名列表

#define SAASAPPGetUserInfoByOrgNO [NSString stringWithFormat:@"%@/%@",BaseAPI,@"SAASAPPGetUserInfoByOrgNO"] //通过住院号获取用户信息 GetUserInfoByOrgNOReq GetUserInfoByOrgNORsp 这个接口可以知道用户是否在住院可以下单





//GetVerifyCodeReq
typedef NS_ENUM(NSInteger, YJYPayType) {

    YJYPayTypePocket = 6,
    YJYPayTypeWechat = 1,
    YJYPayTypeAlipay = 3,

};



@interface YJYNetworkManager : NSObject

typedef void(^Success)(id response);
typedef void(^Failure)(NSError *error);
typedef void(^LoginFailure)(NSError *error);

typedef void (^SuccessBlock) (id responder);
typedef void (^ErrorBlock) (id errorCode);

typedef void(^YJYDidDoneBlock)();


+ (void)requestWithUrlString:(NSString *)UrlString
                     message:(id)message
                  controller:(UIViewController *)controller
                     command:(APP_COMMAND)command
                     success:(Success)success
                     failure:(Failure)failure;

+ (void)requestWithUrlString:(NSString *)UrlString
                     message:(id)message
                  controller:(UIViewController *)controller
                     command:(APP_COMMAND)command
                     success:(Success)success
                     failure:(Failure)failure
                 isHiddenError:(BOOL)isHiddenError;


+ (void)uploadImageToServerWithImage:(UIImage *)image
                                type:(NSString *)type
                             success:(Success)success
                             failure:(Failure)failure;

+ (void)uploadImageToServerWithImage:(UIImage *)image
                                type:(NSString *)type
                             success:(Success)success
                             failure:(Failure)failure
                            compress:(CGFloat)compress;

+ (void)CRPOSTUploadtWithRequestUrl:(NSString *)urlStr
                      withParameter:(NSDictionary *)parameter
                     withImageArray:(NSArray <UIImage *>*)imageArray
               WithReturnValueBlock:(SuccessBlock)successBlock
                     errorCodeBlock:(ErrorBlock)errorBlock;

+ (NSString*)GetYUA;

+ (UIImage *)cropImage:(UIImage *)image scale:(CGFloat)scale;
@end
