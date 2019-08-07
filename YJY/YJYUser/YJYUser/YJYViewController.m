//
//  YJYViewController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/11.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
@interface YJYViewController ()

@end

@implementation YJYViewController

+ (instancetype)instanceWithStoryBoard {
    
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title = @"";
    self.navigationItem.backBarButtonItem = backIetm;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self navigationBarNotAlphaWithBlackTint];


}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
