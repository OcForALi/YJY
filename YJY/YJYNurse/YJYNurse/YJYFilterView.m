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

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *illnesses;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;

@end

@implementation YJYFilterView
- (void)setIllnessListArray:(NSMutableArray<Illness *> *)illnessListArray {
    
    _illnessListArray = illnessListArray;
    self.buttonsView.backgroundColor = [UIColor clearColor];
    self.buttons = [NSMutableArray array];
    self.illnesses = [NSMutableArray array];
    
    CGFloat width = self.frame.size.width/2 - 30;
    CGFloat height = 45;
    
    for (NSInteger i =0; i < self.illnessListArray.count; i++) {
        
        Illness *ill = self.illnessListArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger index = i + 1;
        NSInteger rows = index / 2 + (index%2==0?0:1);
        BOOL isEven = index%2==0;
        CGFloat X = isEven ? width + 20 : 0;
        CGFloat Y = (rows-1) * (height + 10) + 20;
        button.frame = CGRectMake(X,Y, width, height);
        button.layer.cornerRadius = 10;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = APPHEXCOLOR.CGColor;
        button.layer.borderWidth = 1;
        
        
        [button setTitleColor:APPHEXCOLOR forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:ill.illnessName forState:0];
        [self.buttons addObject:button];
        
        [self.buttonsView addSubview:button];
        
    }
    self.containViewH.constant = [self buttonsViewH];
    
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
   
    
}
- (CGFloat)buttonsViewH {
    
    NSInteger rows = self.illnessListArray.count / 2 + (self.illnessListArray.count%2==0?0:1);
    CGFloat H = rows * 50  + 70 + 130;
    return H;

    
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
    self.actionView.transform = CGAffineTransformMakeTranslation(0, -[self buttonsViewH]);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, -[self buttonsViewH]);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (IBAction)tapAction:(id)sender {
    
    [self hidden];
}
- (IBAction)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [sender setBackgroundColor:sender.selected ? APPHEXCOLOR : [UIColor whiteColor]];
}
- (IBAction)done:(id)sender {
    
    self.illnesses = [NSMutableArray array];
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        if (button.selected) {
            Illness* illness =  self.illnessListArray[i];
            [self.illnesses addObject:illness];
        }
    }
    
    
    if (self.didDoneBlock) {
        self.didDoneBlock(self.illnesses);
        [self hidden];
    }
    
    
}

@end
