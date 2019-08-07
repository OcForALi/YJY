//
//  YJYShareView.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYShareView.h"

#define kActionViewHeight 260

@interface YJYShareView ()

@property (weak, nonatomic) IBOutlet UIView *actionView;


@end

@implementation YJYShareView



- (void)awakeFromNib {
    
    [super awakeFromNib];
  
//    self.actionView.transform = CGAffineTransformMakeTranslation(0, 180);

    self.actionView.backgroundColor = [UIColor clearColor];
}

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (IBAction)tapAction:(id)sender {
    
    [self hidden];
}


+ (instancetype)createShareViewAndShowInView:(UIView *)view {
    
    YJYShareView *shareView = [YJYShareView instancetypeWithXIB];
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [shareView showInView:view];
    
    return shareView;
    
}

- (IBAction)shareAction:(UIButton *)sender {
    if (self.shareViewDidSelectBlock) {
        self.shareViewDidSelectBlock(sender.tag);
        [self hidden];

    }
}



@end
