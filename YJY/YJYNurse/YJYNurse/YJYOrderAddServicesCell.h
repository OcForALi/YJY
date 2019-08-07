//
//  YJYOrderAddServicesCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ServicesCellDidNumberChangeBlock)(NSInteger number);
typedef void(^ServicesCellDidSelectBlock)(BOOL isSelect);
@interface YJYOrderAddServicesCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addSubLabel;



@property (assign, nonatomic) BOOL isSelect;
@property (copy, nonatomic) ServicesCellDidNumberChangeBlock didNumberChangeBlock;

@property (strong, nonatomic) CompanyPriceVO *price;

@end
