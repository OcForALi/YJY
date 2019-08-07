//
//  YJYActionSheet.h
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYActionSheetDidComfireBlock)(id result);
typedef void(^YJYActionSheetDidDismissBlock)();

@interface YJYActionSheet : UIView

@property (strong, nonatomic) NSMutableArray *datasource;

@property (copy, nonatomic) YJYActionSheetDidComfireBlock didComfireBlock ;
@property (copy, nonatomic) YJYActionSheetDidDismissBlock didDismissBlock ;

+ (instancetype)instancetypeWithXIBWithDatasource:(NSMutableArray *)datasource withTitle:(NSString *)title;
- (void)showInView:(UIView *)view;
- (void)hidden;

@end
