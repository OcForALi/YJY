//
//  YJYTimePickerController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYTimePickerController : UIViewController


+ (instancetype)instanceWithStoryBoard;
- (void)showInView:(UIView *)view;
- (void)hidden;
@end
