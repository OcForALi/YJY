//
//  YJYPaymentOptionView.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYPaymentOptionView.h"



@interface YJYPaymentOptionView()


@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *pocketButton;


@end

@implementation YJYPaymentOptionView

- (IBAction)paymentAction:(UIButton *)sender {
    
    
    [self hidden];
    if (self.paymentOptionBlock) {
        self.paymentOptionBlock((YJYPaymentOption)sender.tag);
    }
}


- (IBAction)dismissAction:(id)sender {
    
    [self hidden];
}


#pragma mark - Show & Hidden

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib {

    [super awakeFromNib];
    

    

}
- (void)showInView:(UIView *)view {
    
    self.pocketButton.enabled = self.usePurse;
    [self.pocketButton setTitle:[NSString stringWithFormat:@"钱包（剩余金额 %@元）",self.purse] forState:0];
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
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

        self.actionView.transform = CGAffineTransformMakeScale(0.1, 0.1);

    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


@end
