//
//  YJYOrderAddServicesCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderAddServicesCell.h"

@interface YJYOrderAddServicesCell()

@property (assign, nonatomic) u_int32_t originNumber;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@end

@implementation YJYOrderAddServicesCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.oneButton addTarget:self action:@selector(maxAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoButton addTarget:self action:@selector(minAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setPrice:(CompanyPriceVO *)price {
    
    _price = price;
    /// 定价 单位分

    self.titleLabel.text = [NSString stringWithFormat:@"%@(单价%.2f)",price.price.serviceItem,price.price.price*0.01];
    self.priceLabel.text = price.priceFeeStr;
    self.numberLabel.text = [NSString stringWithFormat:@"%@",@(price.number)];
    
    
    if (self.price.price.price >= 0) {
        [self.oneButton setTitle:@"+加" forState:0];
        [self.twoButton setTitle:@"-减" forState:0];
    }else {
        
        [self.twoButton setTitle:@"+加" forState:0];
        [self.oneButton setTitle:@"-减" forState:0];
    }
    
    self.originNumber = price.number;
    [self reloadAddSubLabel];

}


- (IBAction)minAction:(id)sender {
    
    NSInteger number =  [self.numberLabel.text integerValue];
    
    NSInteger nowValue = self.price.payNumber;
    if (self.price.subjoinGroupingType == 3) {
        nowValue = self.originNumber;
    }
    
//    if (number > nowValue) {
//
//    }
    number--;
    if (self.didNumberChangeBlock) {
        self.didNumberChangeBlock(number);
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%@",@(number)];
    [self reloadAddSubLabel];
    
}

- (IBAction)maxAction:(id)sender {
    
    NSInteger number =  [self.numberLabel.text integerValue];
    number++;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@",@(number)];
    if (self.didNumberChangeBlock) {
        self.didNumberChangeBlock(number);
    }
    
    [self reloadAddSubLabel];
}


- (void)reloadAddSubLabel {
    
    
    
    
    NSInteger number =  [self.numberLabel.text integerValue];
    
    NSString *priceStr = [LSLDecimalNumberTool stringWithDecimalNumber:number * self.price.price.price*0.01];
    
    self.priceLabel.text =  [NSString stringWithFormat:@"%@元",priceStr];// [NSString stringWithFormat:@"%.2f元",number * self.price.price.price*0.01];
    
//    self.numberLabel.textColor =  isHighlight ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
//    self.priceLabel.textColor = isHighlight ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
//    self.titleLabel.textColor = isHighlight ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;

    
}
@end
