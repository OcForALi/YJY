// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: AssessModel.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30001
#error This file was generated by a different version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AssessModelRoot

/// Exposes the extension registry for this file.
///
/// The base class provides:
/// @code
///   + (GPBExtensionRegistry *)extensionRegistry;
/// @endcode
/// which is a @c GPBExtensionRegistry that includes all the extensions defined by
/// this file and all files that it depends on.
@interface AssessModelRoot : GPBRootObject
@end

#pragma mark - InsureAssessResult

typedef GPB_ENUM(InsureAssessResult_FieldNumber) {
  InsureAssessResult_FieldNumber_Id_p = 1,
  InsureAssessResult_FieldNumber_Idcard = 2,
  InsureAssessResult_FieldNumber_Level = 3,
  InsureAssessResult_FieldNumber_AssessType = 4,
  InsureAssessResult_FieldNumber_Relation = 5,
  InsureAssessResult_FieldNumber_AssistIdcard = 6,
  InsureAssessResult_FieldNumber_AssistPhone = 7,
  InsureAssessResult_FieldNumber_EvaluationId = 8,
  InsureAssessResult_FieldNumber_AssessAddr = 9,
  InsureAssessResult_FieldNumber_KinsSignPic = 10,
  InsureAssessResult_FieldNumber_AssessSignPic = 11,
  InsureAssessResult_FieldNumber_AbilityLevel = 12,
  InsureAssessResult_FieldNumber_NurseLevel = 13,
  InsureAssessResult_FieldNumber_IllLevel = 14,
  InsureAssessResult_FieldNumber_SsrsLevel = 15,
  InsureAssessResult_FieldNumber_TendType = 16,
  InsureAssessResult_FieldNumber_SuggestServiceType = 17,
  InsureAssessResult_FieldNumber_SuggestServiceContentArray = 18,
  InsureAssessResult_FieldNumber_SuggestServiceContentOther = 19,
  InsureAssessResult_FieldNumber_SuggestServiceTime = 20,
  InsureAssessResult_FieldNumber_SpecialRemark = 21,
  InsureAssessResult_FieldNumber_Status = 22,
  InsureAssessResult_FieldNumber_KinsName = 23,
  InsureAssessResult_FieldNumber_Sex = 24,
  InsureAssessResult_FieldNumber_Nation = 25,
  InsureAssessResult_FieldNumber_Birthday = 26,
  InsureAssessResult_FieldNumber_District = 27,
  InsureAssessResult_FieldNumber_Pic = 28,
  InsureAssessResult_FieldNumber_Province = 29,
  InsureAssessResult_FieldNumber_City = 30,
  InsureAssessResult_FieldNumber_Marriage = 31,
  InsureAssessResult_FieldNumber_Dwelling = 32,
  InsureAssessResult_FieldNumber_Education = 33,
  InsureAssessResult_FieldNumber_Religion = 34,
  InsureAssessResult_FieldNumber_ProfessionType = 35,
  InsureAssessResult_FieldNumber_IncomeArray = 36,
  InsureAssessResult_FieldNumber_NurseType = 37,
  InsureAssessResult_FieldNumber_ChildrenStatus1 = 38,
  InsureAssessResult_FieldNumber_ChildrenStatus2 = 39,
  InsureAssessResult_FieldNumber_HousingType = 40,
  InsureAssessResult_FieldNumber_InfoChannelArray = 41,
  InsureAssessResult_FieldNumber_AssessManArray = 42,
  InsureAssessResult_FieldNumber_CreateTime = 43,
  InsureAssessResult_FieldNumber_ConfirmTime = 44,
  InsureAssessResult_FieldNumber_FianlTime = 45,
  InsureAssessResult_FieldNumber_CreateStaffId = 46,
  InsureAssessResult_FieldNumber_CreateStaffName = 47,
  InsureAssessResult_FieldNumber_DynamicDesc = 48,
  InsureAssessResult_FieldNumber_LastTime = 49,
  InsureAssessResult_FieldNumber_KinsId = 50,
  InsureAssessResult_FieldNumber_AssistSignPic = 51,
};

/// 评估报告
@interface InsureAssessResult : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 身份证号
@property(nonatomic, readwrite, copy, null_resettable) NSString *idcard;

/// 评估类型 1-首次评估 2-复核评估 3-动态评估
@property(nonatomic, readwrite) uint32_t assessType;

/// 协助评估人与评估对象的关系（配偶、子女、其他亲属、雇佣照顾者、其他）
@property(nonatomic, readwrite, copy, null_resettable) NSString *relation;

/// 协助评估人身份证号
@property(nonatomic, readwrite, copy, null_resettable) NSString *assistIdcard;

/// 协助评估人联系电话
@property(nonatomic, readwrite, copy, null_resettable) NSString *assistPhone;

/// 评估点id
@property(nonatomic, readwrite) uint64_t evaluationId;

/// 评估地点
@property(nonatomic, readwrite, copy, null_resettable) NSString *assessAddr;

/// 评估对象签名照片id
@property(nonatomic, readwrite, copy, null_resettable) NSString *kinsSignPic;

/// 评估员签名照片id
@property(nonatomic, readwrite, copy, null_resettable) NSString *assessSignPic;

/// 照护需求等级 0-6（0-2适合社区居家 3视情况社区居家或机构养老 4-6宜机构养老）
@property(nonatomic, readwrite) uint32_t level;

/// 能力等级 0-能力完好 1-轻度失能 2-中度失能 3-重度失能
@property(nonatomic, readwrite) uint32_t abilityLevel;

/// 医疗照护分级0（基础正常或轻度，常规和康复正常）-1（基础中度，常规和康复轻度）-2（基础重度，常规和康复重度）-3（常规或康复重度）-4（需接受特殊治疗/护理）
@property(nonatomic, readwrite) uint32_t nurseLevel;

/// 疾病状况等级 0-无一类和二类疾病 1-有1到2种一类疾病 2-有3种及以上一类疾病 3-有二类疾病
@property(nonatomic, readwrite) uint32_t illLevel;

/// 社会支持等级 1级-低水平（≤22分） 2级-中等水平（23-44分） 3级-高水平（≥45分）
@property(nonatomic, readwrite) uint32_t ssrsLevel;

/// 养老意愿 1-家人照护 2-社区居家养老 3-机构养老 4-暂时社区居家，以后考虑机构养老
@property(nonatomic, readwrite) uint32_t tendType;

/// 建议服务类型 2-社区居家养老 3-机构养老
@property(nonatomic, readwrite) uint32_t suggestServiceType;

/// 建议服务内容，内容以英文逗号隔开
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *suggestServiceContentArray;
/// The number of items in @c suggestServiceContentArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger suggestServiceContentArray_Count;

/// 建议服务内容-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *suggestServiceContentOther;

/// 建议照顾时间
@property(nonatomic, readwrite, copy, null_resettable) NSString *suggestServiceTime;

/// 特殊情况描述
@property(nonatomic, readwrite, copy, null_resettable) NSString *specialRemark;

/// 状态 0-待确认 1-评估员已确认 2-评估机构已确认
@property(nonatomic, readwrite) uint32_t status;

/// 姓名
@property(nonatomic, readwrite, copy, null_resettable) NSString *kinsName;

/// 性别 0-未知 1-男 2-女
@property(nonatomic, readwrite) uint32_t sex;

/// 民族
@property(nonatomic, readwrite, copy, null_resettable) NSString *nation;

/// 生日  1982-07-12 格式
@property(nonatomic, readwrite, copy, null_resettable) NSString *birthday;

/// 区/街道
@property(nonatomic, readwrite, copy, null_resettable) NSString *district;

/// 个人照片
@property(nonatomic, readwrite, copy, null_resettable) NSString *pic;

/// 籍贯-省份
@property(nonatomic, readwrite, copy, null_resettable) NSString *province;

/// 籍贯-城市
@property(nonatomic, readwrite, copy, null_resettable) NSString *city;

/// 婚姻状态 0-未知 1-未婚 2-已婚 3-丧偶 4-离异
@property(nonatomic, readwrite) int32_t marriage;

/// 居住状况1-独居 2-与配偶/伴侣居住 3-与子女居住 4-与父母居住 5-与配偶和子女居住 6-与兄弟姐妹居住 7-与其他亲属居住 8-与非亲属关系的人居住 9-养老机构
@property(nonatomic, readwrite) uint32_t dwelling;

/// 教育程度 0-未知 1-文盲  2-小学  3-初中 4-高中 5-技校 6-职高 7-中专 8-大专 9-本科 10-硕士（及以上）
@property(nonatomic, readwrite) uint32_t education;

/// 宗教
@property(nonatomic, readwrite, copy, null_resettable) NSString *religion;

/// 职业类别 1-政府机关人员 2-事业单位人员 3-企业职工 4-个体户 5-自由职业 6-无业
@property(nonatomic, readwrite) uint32_t professionType;

/// 收入来源 机关事业单位离退休金 2-城乡居民养老保险 3-供养人员补贴 4-低保金 5-子女抚养/补贴 6-亲友自助 7-其他
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *incomeArray;
/// The number of items in @c incomeArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger incomeArray_Count;

/// 医疗类别 1-公费医疗 2-职工医保 3-居民医保 4-商业医疗保险 5-自费 6-其他
@property(nonatomic, readwrite) uint32_t nurseType;

/// 子女状况 儿子个数
@property(nonatomic, readwrite) uint32_t childrenStatus1;

/// 子女状况 女儿个数
@property(nonatomic, readwrite) uint32_t childrenStatus2;

/// 住房性质 自有产权房 、租赁住房 、借住 、廉租房 、公租房 、其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *housingType;

/// 信息采集渠道 本人 、家属 、病历 、医院诊断 、健康档案 、其他
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *infoChannelArray;
/// The number of items in @c infoChannelArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger infoChannelArray_Count;

/// 参与评估人员 本人 、子女 、亲属 、朋友 、居委会工作人员 、其他
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *assessManArray;
/// The number of items in @c assessManArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger assessManArray_Count;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 评估员确认时间
@property(nonatomic, readwrite) uint64_t confirmTime;

/// 评估机构确认时间
@property(nonatomic, readwrite) uint64_t fianlTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

/// 动态评估事由
@property(nonatomic, readwrite, copy, null_resettable) NSString *dynamicDesc;

/// 上次评估时间
@property(nonatomic, readwrite) uint64_t lastTime;

/// 评估人id
@property(nonatomic, readwrite) uint64_t kinsId;

/// 协助评估人签名
@property(nonatomic, readwrite, copy, null_resettable) NSString *assistSignPic;

@end

#pragma mark - InsureAssessAbility

typedef GPB_ENUM(InsureAssessAbility_FieldNumber) {
  InsureAssessAbility_FieldNumber_Id_p = 1,
  InsureAssessAbility_FieldNumber_ResultId = 2,
  InsureAssessAbility_FieldNumber_Level = 3,
  InsureAssessAbility_FieldNumber_AdlLevel = 4,
  InsureAssessAbility_FieldNumber_AdlScore = 5,
  InsureAssessAbility_FieldNumber_MindLevel = 6,
  InsureAssessAbility_FieldNumber_MindScore = 7,
  InsureAssessAbility_FieldNumber_CommLevel = 8,
  InsureAssessAbility_FieldNumber_CommScore = 9,
  InsureAssessAbility_FieldNumber_SocialLevel = 10,
  InsureAssessAbility_FieldNumber_SocialScore = 11,
  InsureAssessAbility_FieldNumber_CreateTime = 12,
  InsureAssessAbility_FieldNumber_CreateStaffId = 13,
  InsureAssessAbility_FieldNumber_CreateStaffName = 14,
};

/// 老年人能力评估
@interface InsureAssessAbility : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 能力等级 0-能力完好 1-轻度失能 2-中度失能 3-重度失能
@property(nonatomic, readwrite) uint32_t level;

/// 生活能力等级
@property(nonatomic, readwrite) uint32_t adlLevel;

/// 生活能力分数
@property(nonatomic, readwrite) uint32_t adlScore;

/// 精神状态等级
@property(nonatomic, readwrite) uint32_t mindLevel;

/// 精神状态分数
@property(nonatomic, readwrite) uint32_t mindScore;

/// 感知觉与沟通等级
@property(nonatomic, readwrite) uint32_t commLevel;

/// 感知觉与沟通分数
@property(nonatomic, readwrite) uint32_t commScore;

/// 社会参与等级
@property(nonatomic, readwrite) uint32_t socialLevel;

/// 社会参与分数
@property(nonatomic, readwrite) uint32_t socialScore;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessAbilityADL

typedef GPB_ENUM(InsureAssessAbilityADL_FieldNumber) {
  InsureAssessAbilityADL_FieldNumber_Id_p = 1,
  InsureAssessAbilityADL_FieldNumber_ResultId = 2,
  InsureAssessAbilityADL_FieldNumber_Score = 3,
  InsureAssessAbilityADL_FieldNumber_Level = 4,
  InsureAssessAbilityADL_FieldNumber_Eat = 5,
  InsureAssessAbilityADL_FieldNumber_Water = 6,
  InsureAssessAbilityADL_FieldNumber_Face = 7,
  InsureAssessAbilityADL_FieldNumber_Wear = 8,
  InsureAssessAbilityADL_FieldNumber_Faec = 9,
  InsureAssessAbilityADL_FieldNumber_Pee = 10,
  InsureAssessAbilityADL_FieldNumber_Toilet = 11,
  InsureAssessAbilityADL_FieldNumber_Carry = 12,
  InsureAssessAbilityADL_FieldNumber_Walk = 13,
  InsureAssessAbilityADL_FieldNumber_Stair = 14,
  InsureAssessAbilityADL_FieldNumber_CreateTime = 15,
  InsureAssessAbilityADL_FieldNumber_CreateStaffId = 16,
  InsureAssessAbilityADL_FieldNumber_CreateStaffName = 17,
};

/// 老年人能力评估-生活能力
@interface InsureAssessAbilityADL : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 评估分数
@property(nonatomic, readwrite) uint32_t score;

/// 0级-100分 1级-65至95分 2级-45至60分 3级-小于40分
@property(nonatomic, readwrite) uint32_t level;

/// 进食 10-可独立进食 5-需部分帮助 0-需极大帮助
@property(nonatomic, readwrite) uint32_t eat;

/// 洗澡 5-可独立洗澡 0-需帮助
@property(nonatomic, readwrite) uint32_t water;

/// 修饰 5-可独立完成 0-需帮助
@property(nonatomic, readwrite) uint32_t face;

/// 穿衣 10-可独立完成 5-需部分帮助 0-需极大帮助
@property(nonatomic, readwrite) uint32_t wear;

/// 大便控制 10-可控制大便 5-偶尔失控 0-完全失控
@property(nonatomic, readwrite) uint32_t faec;

/// 小便控制 10-可控制大便 5-偶尔失控 0-完全失控
@property(nonatomic, readwrite) uint32_t pee;

/// 如厕 10-可独立完成 5-需部分帮助 0-需极大帮助
@property(nonatomic, readwrite) uint32_t toilet;

/// 床椅转移 15-可独立完成 10-需部分帮助 5-需极大帮助 0-完全依赖
@property(nonatomic, readwrite) uint32_t carry;

/// 平地行走 15-可独立行走 10-需部分帮助 5-需极大帮助 0-完全依赖
@property(nonatomic, readwrite) uint32_t walk;

/// 上下楼梯10-可独立完成 5-需部分帮助 0-需极大帮助
@property(nonatomic, readwrite) uint32_t stair;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessAbilityMind

typedef GPB_ENUM(InsureAssessAbilityMind_FieldNumber) {
  InsureAssessAbilityMind_FieldNumber_Id_p = 1,
  InsureAssessAbilityMind_FieldNumber_ResultId = 2,
  InsureAssessAbilityMind_FieldNumber_Score = 3,
  InsureAssessAbilityMind_FieldNumber_Level = 4,
  InsureAssessAbilityMind_FieldNumber_Cognitive = 5,
  InsureAssessAbilityMind_FieldNumber_Attack = 6,
  InsureAssessAbilityMind_FieldNumber_Depressed = 7,
  InsureAssessAbilityMind_FieldNumber_CreateTime = 8,
  InsureAssessAbilityMind_FieldNumber_CreateStaffId = 9,
  InsureAssessAbilityMind_FieldNumber_CreateStaffName = 10,
};

/// 老年人能力评估-精神状态
@interface InsureAssessAbilityMind : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 评估分数
@property(nonatomic, readwrite) uint32_t score;

/// 0级-0分 1级-1分 2级-2至3分 3-4至6分
@property(nonatomic, readwrite) uint32_t level;

/// 认知功能得分
@property(nonatomic, readwrite) uint32_t cognitive;

/// 攻击行为得分
@property(nonatomic, readwrite) uint32_t attack;

/// 抑郁症状得分
@property(nonatomic, readwrite) uint32_t depressed;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessAbilityComm

typedef GPB_ENUM(InsureAssessAbilityComm_FieldNumber) {
  InsureAssessAbilityComm_FieldNumber_Id_p = 1,
  InsureAssessAbilityComm_FieldNumber_ResultId = 2,
  InsureAssessAbilityComm_FieldNumber_Score = 3,
  InsureAssessAbilityComm_FieldNumber_Level = 4,
  InsureAssessAbilityComm_FieldNumber_Mentality = 5,
  InsureAssessAbilityComm_FieldNumber_Vision = 6,
  InsureAssessAbilityComm_FieldNumber_Hearing = 7,
  InsureAssessAbilityComm_FieldNumber_Communication = 8,
  InsureAssessAbilityComm_FieldNumber_CreateTime = 9,
  InsureAssessAbilityComm_FieldNumber_CreateStaffId = 10,
  InsureAssessAbilityComm_FieldNumber_CreateStaffName = 11,
};

/// 老年人能力评估-感知觉与沟通
@interface InsureAssessAbilityComm : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 评估分数
@property(nonatomic, readwrite) uint32_t score;

/// 感知觉与沟通分级（根据每个选项得出） 0-能力完好 1-轻度受损 2-中度受损 3-重度受损
@property(nonatomic, readwrite) uint32_t level;

/// 意识水平
@property(nonatomic, readwrite) uint32_t mentality;

/// 视力
@property(nonatomic, readwrite) uint32_t vision;

/// 听力
@property(nonatomic, readwrite) uint32_t hearing;

/// 沟通交流
@property(nonatomic, readwrite) uint32_t communication;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessAbilitySocial

typedef GPB_ENUM(InsureAssessAbilitySocial_FieldNumber) {
  InsureAssessAbilitySocial_FieldNumber_Id_p = 1,
  InsureAssessAbilitySocial_FieldNumber_ResultId = 2,
  InsureAssessAbilitySocial_FieldNumber_Score = 3,
  InsureAssessAbilitySocial_FieldNumber_Level = 4,
  InsureAssessAbilitySocial_FieldNumber_Viability = 5,
  InsureAssessAbilitySocial_FieldNumber_WorkAbility = 6,
  InsureAssessAbilitySocial_FieldNumber_TimeSpace = 7,
  InsureAssessAbilitySocial_FieldNumber_Personal = 8,
  InsureAssessAbilitySocial_FieldNumber_SocialSkills = 9,
  InsureAssessAbilitySocial_FieldNumber_CreateTime = 10,
  InsureAssessAbilitySocial_FieldNumber_CreateStaffId = 11,
  InsureAssessAbilitySocial_FieldNumber_CreateStaffName = 12,
};

/// 老年人能力评估-社会参与
@interface InsureAssessAbilitySocial : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 评估分数
@property(nonatomic, readwrite) uint32_t score;

/// 社会参与等级 0-0至2分 1-3至7分 2-8至13分 3-14至20分
@property(nonatomic, readwrite) uint32_t level;

/// 生活能力
@property(nonatomic, readwrite) uint32_t viability;

/// 工作能力
@property(nonatomic, readwrite) uint32_t workAbility;

/// 时间/空间定向
@property(nonatomic, readwrite) uint32_t timeSpace;

/// 人物定向
@property(nonatomic, readwrite) uint32_t personal;

/// 社会交往能力
@property(nonatomic, readwrite) uint32_t socialSkills;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessNurse

typedef GPB_ENUM(InsureAssessNurse_FieldNumber) {
  InsureAssessNurse_FieldNumber_Id_p = 1,
  InsureAssessNurse_FieldNumber_ResultId = 2,
  InsureAssessNurse_FieldNumber_Level = 3,
  InsureAssessNurse_FieldNumber_BaseNurse = 4,
  InsureAssessNurse_FieldNumber_CommonNurse = 5,
  InsureAssessNurse_FieldNumber_RehaNurse = 6,
  InsureAssessNurse_FieldNumber_SpecialNurseArray = 7,
  InsureAssessNurse_FieldNumber_CreateTime = 8,
  InsureAssessNurse_FieldNumber_CreateStaffId = 9,
  InsureAssessNurse_FieldNumber_CreateStaffName = 10,
};

/// 医疗照护评估
@interface InsureAssessNurse : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 医疗照护分级0（基础正常或轻度，常规和康复正常）-1（基础中度，常规和康复轻度）-2（基础重度，常规和康复重度）-3（常规或康复重度）-4（需接受特殊治疗/护理）
@property(nonatomic, readwrite) uint32_t level;

/// 基础护理 1-正常 2-轻度依赖 3-中度依赖 4-重度依赖
@property(nonatomic, readwrite) uint32_t baseNurse;

/// 常规治疗护理 1-正常 2-轻度依赖 3-中度依赖 4-重度依赖
@property(nonatomic, readwrite) uint32_t commonNurse;

/// 康复护理 1-正常 2-轻度依赖 3-中度依赖 4-重度依赖
@property(nonatomic, readwrite) uint32_t rehaNurse;

/// 特殊治疗/护理（多选） 放射治疗、化学治疗、持续吸氧/吸痰、处于造口适应期、使用监护仪、人工呼吸机、压疮Ⅲ级、频繁伤口换药（大换药/特大换药）、静脉营养、气管切开处理、严重皮肤溃疡
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *specialNurseArray;
/// The number of items in @c specialNurseArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger specialNurseArray_Count;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessIll

typedef GPB_ENUM(InsureAssessIll_FieldNumber) {
  InsureAssessIll_FieldNumber_Id_p = 1,
  InsureAssessIll_FieldNumber_ResultId = 2,
  InsureAssessIll_FieldNumber_Level = 3,
  InsureAssessIll_FieldNumber_AngiocarpyArray = 4,
  InsureAssessIll_FieldNumber_AngiocarpyOther = 5,
  InsureAssessIll_FieldNumber_BreatheArray = 6,
  InsureAssessIll_FieldNumber_BreatheOther = 7,
  InsureAssessIll_FieldNumber_MetabolismArray = 8,
  InsureAssessIll_FieldNumber_MetabolismOther = 9,
  InsureAssessIll_FieldNumber_DigestionArray = 10,
  InsureAssessIll_FieldNumber_DigestionOther = 11,
  InsureAssessIll_FieldNumber_JointArray = 12,
  InsureAssessIll_FieldNumber_JointOther = 13,
  InsureAssessIll_FieldNumber_NerveArray = 14,
  InsureAssessIll_FieldNumber_NerveOther = 15,
  InsureAssessIll_FieldNumber_UrinaryArray = 16,
  InsureAssessIll_FieldNumber_UrinaryOther = 17,
  InsureAssessIll_FieldNumber_BloodArray = 18,
  InsureAssessIll_FieldNumber_BloodOther = 19,
  InsureAssessIll_FieldNumber_OtherArray = 20,
  InsureAssessIll_FieldNumber_SecondIllArray = 21,
  InsureAssessIll_FieldNumber_SecondIllOther = 22,
  InsureAssessIll_FieldNumber_CreateTime = 23,
  InsureAssessIll_FieldNumber_CreateStaffId = 24,
  InsureAssessIll_FieldNumber_CreateStaffName = 25,
};

/// 疾病状况评估
@interface InsureAssessIll : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 疾病状况等级 0-无一类和二类疾病 1-有1到2种一类疾病 2-有3种及以上一类疾病 3-有二类疾病
@property(nonatomic, readwrite) uint32_t level;

/// 心血管系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *angiocarpyArray;
/// The number of items in @c angiocarpyArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger angiocarpyArray_Count;

/// 心血管系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *angiocarpyOther;

/// 呼吸系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *breatheArray;
/// The number of items in @c breatheArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger breatheArray_Count;

/// 呼吸系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *breatheOther;

/// 代谢和内分泌系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *metabolismArray;
/// The number of items in @c metabolismArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger metabolismArray_Count;

/// 代谢和内分泌系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *metabolismOther;

/// 消化系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *digestionArray;
/// The number of items in @c digestionArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger digestionArray_Count;

/// 消化系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *digestionOther;

/// 骨/关节/脊柱
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *jointArray;
/// The number of items in @c jointArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger jointArray_Count;

/// 骨/关节/脊柱-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *jointOther;

/// 神经系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *nerveArray;
/// The number of items in @c nerveArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger nerveArray_Count;

/// 神经系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *nerveOther;

/// 泌尿生殖系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *urinaryArray;
/// The number of items in @c urinaryArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger urinaryArray_Count;

/// 泌尿生殖系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *urinaryOther;

/// 血液系统
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *bloodArray;
/// The number of items in @c bloodArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger bloodArray_Count;

/// 血液系统-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *bloodOther;

/// 其他
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *otherArray;
/// The number of items in @c otherArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger otherArray_Count;

/// 二类疾病
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *secondIllArray;
/// The number of items in @c secondIllArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger secondIllArray_Count;

/// 二类疾病-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *secondIllOther;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessSSRS

typedef GPB_ENUM(InsureAssessSSRS_FieldNumber) {
  InsureAssessSSRS_FieldNumber_Id_p = 1,
  InsureAssessSSRS_FieldNumber_ResultId = 2,
  InsureAssessSSRS_FieldNumber_Score = 3,
  InsureAssessSSRS_FieldNumber_Level = 4,
  InsureAssessSSRS_FieldNumber_Friends = 5,
  InsureAssessSSRS_FieldNumber_LiveStatus = 6,
  InsureAssessSSRS_FieldNumber_Neighbor = 7,
  InsureAssessSSRS_FieldNumber_Colleague = 8,
  InsureAssessSSRS_FieldNumber_FamilySpouse = 9,
  InsureAssessSSRS_FieldNumber_FamilyParent = 10,
  InsureAssessSSRS_FieldNumber_FamilyChild = 11,
  InsureAssessSSRS_FieldNumber_FamilySibling = 12,
  InsureAssessSSRS_FieldNumber_FamilyOther = 13,
  InsureAssessSSRS_FieldNumber_HelpChannelArray = 14,
  InsureAssessSSRS_FieldNumber_HelpChannelOther = 15,
  InsureAssessSSRS_FieldNumber_CareChannelArray = 16,
  InsureAssessSSRS_FieldNumber_CareChannelOther = 17,
  InsureAssessSSRS_FieldNumber_PourWay = 18,
  InsureAssessSSRS_FieldNumber_HelpWay = 19,
  InsureAssessSSRS_FieldNumber_PublicActivity = 20,
  InsureAssessSSRS_FieldNumber_CreateTime = 21,
  InsureAssessSSRS_FieldNumber_CreateStaffId = 22,
  InsureAssessSSRS_FieldNumber_CreateStaffName = 23,
};

/// 社会支持评定量
@interface InsureAssessSSRS : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 得分
@property(nonatomic, readwrite) uint32_t score;

/// 社会支持等级 1级-低水平（≤22分） 2级-中等水平（23-44分） 3级-高水平（≥45分）
@property(nonatomic, readwrite) uint32_t level;

/// 关系密切的朋友数量
@property(nonatomic, readwrite) uint32_t friends;

/// 居住情况
@property(nonatomic, readwrite) uint32_t liveStatus;

/// 与邻居交往情况
@property(nonatomic, readwrite) uint32_t neighbor;

/// 与同事交往情况
@property(nonatomic, readwrite) uint32_t colleague;

/// 与夫妻/恋人交往情况
@property(nonatomic, readwrite) uint32_t familySpouse;

/// 与父母交往情况
@property(nonatomic, readwrite) uint32_t familyParent;

/// 与儿女交往情况
@property(nonatomic, readwrite) uint32_t familyChild;

/// 与兄弟姐妹交往情况
@property(nonatomic, readwrite) uint32_t familySibling;

/// 与其家属交往情况
@property(nonatomic, readwrite) uint32_t familyOther;

/// 帮助来源
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *helpChannelArray;
/// The number of items in @c helpChannelArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger helpChannelArray_Count;

/// 帮助来源-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *helpChannelOther;

/// 安慰和关心来源
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *careChannelArray;
/// The number of items in @c careChannelArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger careChannelArray_Count;

/// 安慰和关心来源-其他
@property(nonatomic, readwrite, copy, null_resettable) NSString *careChannelOther;

/// 倾述方式
@property(nonatomic, readwrite) uint32_t pourWay;

/// 求助方式
@property(nonatomic, readwrite) uint32_t helpWay;

/// 参加社会活动
@property(nonatomic, readwrite) uint32_t publicActivity;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - InsureAssessTend

typedef GPB_ENUM(InsureAssessTend_FieldNumber) {
  InsureAssessTend_FieldNumber_Id_p = 1,
  InsureAssessTend_FieldNumber_ResultId = 2,
  InsureAssessTend_FieldNumber_DesireChannel = 3,
  InsureAssessTend_FieldNumber_TendType = 4,
  InsureAssessTend_FieldNumber_CreateTime = 5,
  InsureAssessTend_FieldNumber_CreateStaffId = 6,
  InsureAssessTend_FieldNumber_CreateStaffName = 7,
};

/// 养老意愿评估
@interface InsureAssessTend : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 报告id
@property(nonatomic, readwrite) uint64_t resultId;

/// 意愿来源 1-个人意愿 2-法定监护人意愿
@property(nonatomic, readwrite) uint32_t desireChannel;

/// 养老意愿 1-家人照护 2-社区居家养老 3-机构养老 4-暂时社区居家，以后考虑机构养老
@property(nonatomic, readwrite) uint32_t tendType;

/// 本次评估时间
@property(nonatomic, readwrite) uint64_t createTime;

/// 操作员工ID
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 评估人员
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

#pragma mark - EvaluationModel

typedef GPB_ENUM(EvaluationModel_FieldNumber) {
  EvaluationModel_FieldNumber_Id_p = 1,
  EvaluationModel_FieldNumber_EvalName = 2,
  EvaluationModel_FieldNumber_CompanyId = 3,
  EvaluationModel_FieldNumber_Province = 4,
  EvaluationModel_FieldNumber_City = 5,
  EvaluationModel_FieldNumber_CityCode = 6,
  EvaluationModel_FieldNumber_District = 7,
  EvaluationModel_FieldNumber_AdCode = 8,
  EvaluationModel_FieldNumber_Street = 9,
  EvaluationModel_FieldNumber_Building = 10,
  EvaluationModel_FieldNumber_AddrDetail = 11,
  EvaluationModel_FieldNumber_GpsType = 12,
  EvaluationModel_FieldNumber_Lng = 13,
  EvaluationModel_FieldNumber_Lat = 14,
  EvaluationModel_FieldNumber_CreateTime = 15,
  EvaluationModel_FieldNumber_CreateStaffId = 16,
  EvaluationModel_FieldNumber_CreateStaffName = 17,
};

/// 评估点
@interface EvaluationModel : GPBMessage

@property(nonatomic, readwrite) uint64_t id_p;

/// 评估点名
@property(nonatomic, readwrite, copy, null_resettable) NSString *evalName;

/// 公司id
@property(nonatomic, readwrite) uint64_t companyId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *province;

@property(nonatomic, readwrite, copy, null_resettable) NSString *city;

/// 城市编码
@property(nonatomic, readwrite, copy, null_resettable) NSString *cityCode;

/// 区
@property(nonatomic, readwrite, copy, null_resettable) NSString *district;

/// 高德城市编码
@property(nonatomic, readwrite, copy, null_resettable) NSString *adCode;

@property(nonatomic, readwrite, copy, null_resettable) NSString *street;

/// 小区
@property(nonatomic, readwrite, copy, null_resettable) NSString *building;

/// 详细地址
@property(nonatomic, readwrite, copy, null_resettable) NSString *addrDetail;

/// 经纬度类型 1-百度 2-高德
@property(nonatomic, readwrite) uint32_t gpsType;

@property(nonatomic, readwrite) double lng;

@property(nonatomic, readwrite) double lat;

@property(nonatomic, readwrite) uint64_t createTime;

/// 操作人id
@property(nonatomic, readwrite) uint64_t createStaffId;

/// 操作人
@property(nonatomic, readwrite, copy, null_resettable) NSString *createStaffName;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
