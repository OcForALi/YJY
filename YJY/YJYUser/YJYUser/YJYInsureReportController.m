//
//  YJYInsureReportController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/13.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureReportController.h"

@interface YJYInsureReportController ()

@end

@implementation YJYInsureReportController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureReportController *)[UIStoryboard storyboardWithName:@"YJYInsureDone" viewControllerIdentifier:NSStringFromClass(self)];
    
}
- (void)viewDidLoad {
    

    [super viewDidLoad];

}

- (void)loadTitle:(NSString *)title {

    self.title = @"复审评估报告";

}

@end
