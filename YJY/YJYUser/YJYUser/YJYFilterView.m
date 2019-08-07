//
//  YJYQRView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYFilterView.h"
#import "UIImage+XHLaunchAd.h"


@interface YJYFilterView()

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;

@property (assign, nonatomic) BOOL isCashReturn;

@end

@implementation YJYFilterView


+ (instancetype)instancetypeWithXIB {
    
    id obj = [[[NSBundle mainBundle]loadNibNamed:@"YJYFilterOtherView" owner:nil options:nil]firstObject];
    
    return obj;
}

- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.3);
    self.actionView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
self.actionView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (IBAction)tapAction:(id)sender {
    
    [self hidden];
}
- (IBAction)selectAction:(UIButton *)sender {
    
    self.oneImageView.image = [UIImage imageNamed:@"app_unselect_icon"];
     self.twoImageView.image = [UIImage imageNamed:@"app_unselect_icon"];
    
    if (sender.tag == 0) {
        self.oneImageView.image = [UIImage imageNamed:@"app_select_icon"];
        self.titleLabel.text = @"退至余额请到钱包提现";
    }else {
        self.twoImageView.image = [UIImage imageNamed:@"app_select_icon"];
        self.titleLabel.text = @"现金退款请到收费处结算";

        
    }
    
    self.isCashReturn = sender.tag == 0;
}
- (IBAction)done:(id)sender {
    
   
    
    if (self.didDoneBlock) {
        self.didDoneBlock(self.isCashReturn);
        [self hidden];
    }
    
    
}
- (IBAction)close:(id)sender {
    
    [self hidden];

}

@end
