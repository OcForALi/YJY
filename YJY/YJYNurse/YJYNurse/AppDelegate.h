//
//  AppDelegate.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/18.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic)NSTimer *mTimer;

- (void)networkFailureRequest;

- (void)timeAction;

@end

