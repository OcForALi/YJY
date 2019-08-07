//
//  YJYNavigationController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNavigationController.h"

@interface YJYNavigationController ()

@end

@implementation YJYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        self.navigationBar.prefersLargeTitles = YES;
        
    }
    // Do any additional setup after loading the view.
    
    
    [self navigationBarNotAlphaWithBlackTint];
    [self configureBackButton];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
  
    
}
- (void)configureBackButton {
    
    //title
    
    [[UIBarButtonItem appearance]setTintColor:APPHEXCOLOR];
  
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
   
   
}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}

@end
