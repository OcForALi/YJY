//
//  UIViewController+Extension.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/23.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)
- (UIViewController *)topMostViewController;
- (BOOL) isPushController;
- (void)navigationBarAlphaWithWhiteTint;
- (void)navigationBarNotAlphaWithBlackTint;
@end
