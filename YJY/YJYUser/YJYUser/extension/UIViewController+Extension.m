//
//  UIViewController+Extension.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil)
    {
        return self;
    }
    else if ([self.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    return [presentedViewController topMostViewController];
}

- (BOOL) isPushController {
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1)
    {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self)
        {
            //push方式
            
            return YES;
        }
        return YES;
        
    }
    else
    {
        //present方式
        return NO;
    }
}
#pragma mark - helper

- (void)navigationBarAlphaWithWhiteTint {
    
    
    
    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(255, 255, 255, 0)];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)navigationBarNotAlphaWithBlackTint {
    
    
    
    [self.navigationController.navigationBar lt_reset];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(255, 255, 255, 1)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]}];
    
    
}
@end

