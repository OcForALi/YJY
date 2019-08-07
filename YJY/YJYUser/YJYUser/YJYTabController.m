//
//  YJYTabController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTabController.h"
#import "YJYMineController.h"
#import "YJYNavigationController.h"
#import "YJYOrdersController.h"

@interface YJYTabController ()<UITabBarControllerDelegate>

@end

@implementation YJYTabController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYTabController *)[UIStoryboard storyboardWithName:@"Main" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = APPHEXCOLOR;
    self.delegate = self;
    
    for (UITabBarItem * i in self.tabBar.items) {
        i.titlePositionAdjustment = UIOffsetMake(0, -5);
        i.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectOneIndex:) name:kYJYTabBarIndexSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectHomeIndex:) name:kYJYHomeIndexSelectNotification object:nil];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)selectHomeIndex:(NSNotification *)nofi {
    
    self.selectedIndex = 0;
}

- (void)selectOneIndex:(NSNotification *)nofi {

    
    self.selectedIndex = 1;
    

}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    
    if ([viewController isKindOfClass:[YJYNavigationController class]]) {
        
        YJYNavigationController *navVC = (YJYNavigationController *)viewController;
        
        if ([navVC.topViewController isKindOfClass:[YJYMineController class]] || [navVC.topViewController isKindOfClass:[YJYOrdersController class]]) {
            
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
