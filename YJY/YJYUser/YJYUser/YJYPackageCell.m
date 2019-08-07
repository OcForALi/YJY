//
//  YJYPackageCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYPackageCell.h"

@interface YJYPackageCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YJYPackageCell

- (void)setCPrice:(CompanyPriceVO *)cPrice {
    
    _cPrice = cPrice;
    Price *price = cPrice.price;
    
    self.priceLab.text = price.priceStr;
    self.nameLab.text = price.serviceItem;

}

- (void)setPrice:(Price *)price {

    _price = price;
    
    self.nameLab.text = [price serviceItem];
    self.priceLab.text = price.priceStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    
    if (selected) {
        
        self.selectImageView.image = [UIImage imageNamed:@"app_select_icon"];
        self.nameLab.textColor = APPHEXCOLOR;
        self.priceLab.textColor = APPHEXCOLOR;
        
        self.nameLab.font = [UIFont systemFontOfSize:17];
        self.priceLab.font = [UIFont systemFontOfSize:17];
        
    }else {
        
        
        //book_white_go_icon
        self.selectImageView.image = [UIImage imageNamed:@"app_unselect_icon"];

        self.nameLab.textColor = APPDarkCOLOR;
        self.priceLab.textColor = APPDarkCOLOR;
        self.nameLab.font = [UIFont systemFontOfSize:15];
        self.priceLab.font = [UIFont systemFontOfSize:15];

    }
    
    [super setSelected:selected animated:animated];


}
- (IBAction)detailAction:(id)sender {
    
    if (self.packageCellDidSelectBlock) {
        self.packageCellDidSelectBlock();
    }
    
}

@end
