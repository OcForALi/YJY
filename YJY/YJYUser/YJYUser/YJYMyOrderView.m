//
//  YJYMyOrderView.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/30.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYMyOrderView.h"

@interface YJYMyOrderView()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end

@implementation YJYMyOrderView



+ (instancetype)instancetypeWithXIB {

    CGFloat W = 220;
    CGFloat H = 140;

    
    YJYMyOrderView *orderView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    orderView.frame = CGRectMake(0, 0, W, H);

    return orderView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToDetail:)];
    [self addGestureRecognizer:tap];
}


- (void)setOrder:(OrderCurrent *)order {
    
    _order = order;
    self.locationLabel.text = order.serviceAddr;

    self.packageLabel.text = order.serviceName;
    self.dayLabel.text = [NSString stringWithFormat:@"%@天",@(order.dayNum)] ;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",@(order.totalFee/100)];
    
}
- (IBAction)jumpToDetail:(id)sender {
    
    if (self.orderViewDidSelectBlock) {
        self.orderViewDidSelectBlock(self.order);
    }
}

@end
