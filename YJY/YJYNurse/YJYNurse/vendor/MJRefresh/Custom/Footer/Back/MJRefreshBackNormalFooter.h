//
//  MJRefreshBackNormalFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  No Comment (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackNormalFooter : MJRefreshBackStateFooter
@property (strong, nonatomic) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
