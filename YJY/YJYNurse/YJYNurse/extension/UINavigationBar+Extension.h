//
//  UINavigationBar+Extension.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/7.
//  No Comment © 2017年 samwuu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UINavigationBar (Extension)

@property (nonatomic, assign, setter=setAx_showShadowView:) BOOL ax_showShadowView;

- (void)ax_setBlurBackgroundAlpha:(CGFloat)alpha;

- (void)ax_setBackgroundColor:(UIColor *)aColor;

- (void)ax_setBackgroundColorAlpha:(CGFloat)alpha;

- (void)ax_setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics;

- (void)ax_clearBackgroundImage;

- (void)ax_setBackgroundImageBackgroundColor:(UIColor *)aColor;

- (void)ax_setBackgroundImageBackgroundColorAlpha:(CGFloat)alpha;

- (void)ax_setLeftViewsAlpha:(CGFloat)alpha;

- (void)ax_setRightViewsAlpha:(CGFloat)alpha;

- (void)ax_setTitleViewAlpha:(CGFloat)alpha;

- (void)ax_setBackIndicatorViewAlpha:(CGFloat)alpha;

- (void)ax_selfOffCenteringOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

@end
