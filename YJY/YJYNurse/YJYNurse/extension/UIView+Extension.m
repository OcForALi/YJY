//
//  UIView+Extension.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/31.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)yjy_setBottomShadowWithHeight:(CGFloat)height {

    
    CGFloat paintingWidth = self.frame.size.width;
    CGFloat paintingHeight = 5;
    
    self.layer.shadowColor = [UIColor colorWithHexString:@"#131B33" alpha:0.1].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0,-5);
    
    
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, height)];
    //添加直线
    [path addLineToPoint:CGPointMake(paintingWidth, height)];
    [path addLineToPoint:CGPointMake(paintingWidth, height + paintingHeight)];
    [path addLineToPoint:CGPointMake(0, height + paintingHeight)];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}
- (void)yjy_setBottomShadow {

    [self yjy_setBottomShadowWithHeight:self.frame.size.height];
   
}
- (void)yjy_setTopShadow {
    
    
    CGFloat paintingWidth = self.frame.size.width;
    CGFloat paintingHeight = 5;
    
    self.layer.shadowColor = [UIColor colorWithHexString:@"#131B33" alpha:0.1].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0,-5);
    
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    //添加直线
    [path addLineToPoint:CGPointMake(paintingWidth, 0)];
    [path addLineToPoint:CGPointMake(paintingWidth, paintingHeight)];
    [path addLineToPoint:CGPointMake(0, paintingHeight)];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}

- (void)yjy_setFillShadow {

    CGFloat paintingWidth = self.frame.size.width;
    CGFloat paintingHeight = 5;
    
    self.layer.shadowColor = [UIColor colorWithHexString:@"#131B33" alpha:0.1].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0,-5);
    
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    //添加直线
    [path addLineToPoint:CGPointMake(paintingWidth, 0)];
    [path addLineToPoint:CGPointMake(paintingWidth, paintingHeight)];
    [path addLineToPoint:CGPointMake(0, paintingHeight)];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;

    
}

@end
