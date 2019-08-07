//
//  UIButton+Activity.h
//  Scriptive
//
//  Created by Josh Justice on 7/21/14.
//  Copyright (c) 2014 Scriptive. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Activity)
@property (strong ,nonatomic) UIActivityIndicatorView *spinner;

- (void)updateActivityIndicatorVisibility;
- (void)stopActivityIndicatorVisibility;
- (void)stopActivityIndicatorVisibilityWithIsClear:(BOOL)isClear;

@end
