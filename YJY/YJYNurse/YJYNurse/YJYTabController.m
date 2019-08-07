//
//  YJYTabController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTabController.h"
#import "YJYMineViewController.h"
#import "YJYOrdersController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>


#import "YJYOfflineWorkbenchController.h"
#import "YJYNavigationController.h"

@interface YJYTabController ()<UITabBarControllerDelegate>
//data

@end

@implementation YJYTabController

+ (instancetype)instanceWithStoryBoard {
    
    if ([YJYRoleManager isZizhao]) {
        
        return (YJYTabController *)[UIStoryboard storyboardWithName:@"ZZMain" viewControllerIdentifier:NSStringFromClass(self)];

    }else {
        
        return (YJYTabController *)[UIStoryboard storyboardWithName:@"Main" viewControllerIdentifier:NSStringFromClass(self)];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = APPHEXCOLOR;
    self.delegate = self;
    
    for (UITabBarItem * i in self.tabBar.items) {
        i.titlePositionAdjustment = UIOffsetMake(0, -5);
        i.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    }
    
}




- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    
    if ([viewController isKindOfClass:[YJYNavigationController class]]) {
        
        YJYNavigationController *navVC = (YJYNavigationController *)viewController;
        
        if ([navVC.topViewController isKindOfClass:[YJYMineViewController class]] || [navVC.topViewController isKindOfClass:[YJYOrdersController class]]) {
            
            if (![YJYLoginManager isLogin]) {
                YJYNavigationController *navi = [[YJYNavigationController alloc]initWithRootViewController:[YJYLoginController instanceWithStoryBoard]];
                [self presentViewController:navi animated:YES completion:nil];
                return NO;
            }
        }
        
    }
    
    return YES;
}





@end
