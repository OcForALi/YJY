//
//  UIBarButtonItem+extension.m
//  ShareParking
//
//  Created by wusonghe on 2016/12/5.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "UIBarButtonItem+extension.h"


@implementation UIBarButtonItem (extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
        [button sizeToFit];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        return [[self alloc] initWithCustomView:button];
    }
}


@end
