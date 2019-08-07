//
//  YJYSettingManager.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/25.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface YJYSettingManager : NSObject


+ (instancetype)sharedInstance;
@property (strong, nonatomic) NSMutableArray<BannerModel *> *banners;
@property (strong, nonatomic) NSMutableArray<IndexServiceItem *> *items;
@property (strong, nonatomic) NSMutableArray<ServiceCityModel *> *citys;
@property (strong, nonatomic) NSMutableArray<Language *> *languageList;
@property (strong, nonatomic) NSMutableArray<Information*> *inforListArray;
@property (strong, nonatomic) NSMutableArray<MedicareType*> *medicareListArray;
@property (strong, nonatomic) OrgVO *currentOrgVo;
@property (strong, nonatomic) NSString *env;

@property(nonatomic, strong) NSString *insureDescURL;
@property(nonatomic, readwrite) BOOL adcode;
@property (assign, nonatomic) u_int64_t userId;
@property (copy, nonatomic) NSString *urlTypeStr;

@end
