//
//  YJYAdjustRebateView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureTimeChooseView.h"

@interface YJYInsureTimeChooseView()

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (assign, nonatomic) NSInteger priceType;


@end

@implementation YJYInsureTimeChooseView

+ (instancetype)instancetypeWithXIB {
    
    NSArray *a = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    
    return a.firstObject;
}
- (void)setReceptionDay:(NSString *)receptionDay {
    _receptionDay = receptionDay;
    self.oneLabel.text = receptionDay;
    self.twoLabel.text = self.today;
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
   
}

- (IBAction)oneButtonAction:(UIButton *)sender {
    
    self.oneImageView.image = [UIImage imageNamed:@"app_select_icon"];
    self.twoImageView.image = [UIImage imageNamed:@"app_unselect_icon"];
    
    self.priceType = 1;


}
- (IBAction)twoButtonAction:(UIButton *)sender {
    
    self.oneImageView.image = [UIImage imageNamed:@"app_unselect_icon"];
    self.twoImageView.image = [UIImage imageNamed:@"app_select_icon"];
    
    self.priceType = 2;
    
    
    
}


- (IBAction)comfireAction:(id)sender {
    
    
    if (self.priceType == 0) {
        [SYProgressHUD showInfoText:@"请选择计费起点"];
        return;
    }
    
    if (self.didComfireBlock) {
        self.didComfireBlock(@(self.priceType));
    }
    [self hidden];
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    [self hidden];

}

#pragma mark - show & hide

- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.3);
    self.actionView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeScale(0.000000000001, 0.0000000000001);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}



@end
