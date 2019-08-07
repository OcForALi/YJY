//
//  YJYInsureDailyComfireController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/4/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureDailyComfireController.h"

@interface YJYInsureDailyComfireController ()
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation YJYInsureDailyComfireController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todayLabel.text = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    self.dataShowType = NoDataShowTypeDesButton;
    self.noDataTitle = @"今日休假";
    [self reloadAllData];
}



+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureDailyComfire" viewControllerIdentifier:className];
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self navigationBarNotAlphaWithBlackTint];
}




@end
