//
//  YJYPackageCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Price;

typedef void(^PackageCellDidSelectBlock)();

@interface YJYPackageCell : UITableViewCell

@property (strong, nonatomic) Price *price;
@property (strong, nonatomic) CompanyPriceVO *cPrice;

@property (assign, nonatomic) BOOL cellSelected;
@property (copy, nonatomic) PackageCellDidSelectBlock packageCellDidSelectBlock;

@end
