//
//  YJYQRView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YJYFilterViewDidDoneBlock)(BOOL isCashReturn);

@interface YJYFilterView : UIView

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (copy, nonatomic) YJYFilterViewDidDoneBlock didDoneBlock;


+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;
@end
