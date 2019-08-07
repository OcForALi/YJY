//
//  UIBarButtonItem+extension.h
//  ShareParking
//
//  Created by wusonghe on 2016/12/5.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
