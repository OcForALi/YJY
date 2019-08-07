//
//  UIStoryboard+Helper.m
//  KateMcKay
//
//  Created by cc on 16/5/30.
//  Copyright © 2016年 XMind. All rights reserved.
//

#import "UIStoryboard+Helper.h"

@implementation UIStoryboard (Helper)
+ (UIViewController *)storyboardWithName:(NSString *)name viewControllerIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}
@end
