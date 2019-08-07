//
//  UIStoryboard+Helper.h
//  KateMcKay
//
//  Created by cc on 16/5/30.
//  Copyright © 2016年 XMind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Helper)
+ (UIViewController *)storyboardWithName:(NSString *)name viewControllerIdentifier:(NSString *)identifier;
@end
