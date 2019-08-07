//
//  YJYQRView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYQRView.h"
#import "UIImage+XHLaunchAd.h"

@interface YJYQRView()
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;

@end

@implementation YJYQRView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setImgUrl:(NSString *)imgUrl {

    _imgUrl = imgUrl;
    [self.scanImageView xh_setImageWithURL:[NSURL URLWithString:imgUrl]];

}

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
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

- (IBAction)tapAction:(id)sender {
    
    [self hidden];
}

@end
