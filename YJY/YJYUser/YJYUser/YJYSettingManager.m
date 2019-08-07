
//
//  YJYSettingManager.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/25.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYSettingManager.h"

@implementation YJYSettingManager

#define kSettingFileData [kLibDir stringByAppendingPathComponent:@"setting.data"]

MJCodingImplementation

+ (instancetype)sharedInstance
{
    static YJYSettingManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YJYSettingManager alloc] init];
    });
    
    return sharedManager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.banners = [NSMutableArray array];
        self.items = [NSMutableArray array];
        self.citys = [NSMutableArray array];
        self.languageList = [NSMutableArray array];
        self.inforListArray = [NSMutableArray array];
        self.medicareListArray = [NSMutableArray array];
    }
    return self;
}


- (void)saveSettingCache {

    // Encoding
    [NSKeyedArchiver archiveRootObject:self toFile:kSettingFileData];
    
}

- (void)getSettingCache {

    YJYSettingManager *setting = [NSKeyedUnarchiver unarchiveObjectWithFile:kSettingFileData];
    
    
    
    [YJYSettingManager sharedInstance].banners = setting.banners;
    [YJYSettingManager sharedInstance].items = setting.items;
    [YJYSettingManager sharedInstance].citys = setting.citys;
    [YJYSettingManager sharedInstance].inforListArray = setting.inforListArray;
    [YJYSettingManager sharedInstance].languageList = setting.languageList;
    [YJYSettingManager sharedInstance].medicareListArray = setting.medicareListArray;
    
    [YJYSettingManager sharedInstance].insureDescURL = setting.insureDescURL;


}

- (BOOL)isExistSetting {

    YJYSettingManager *setting = [NSKeyedUnarchiver unarchiveObjectWithFile:kSettingFileData];
    return (setting != nil);
}
@end
