//
//  YJYOrderCreatePriceCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^YJYOrderCreatePriceCellDidSelectBlock)(Price *price);
typedef void(^YJYOrderCreatePriceCellDidSwitchBlock)(NSInteger tag);
typedef void(^YJYOrderCreateServiceItemCellDidSelectBlock)(Price *price);

typedef NS_ENUM(NSInteger, YJYPriceType) {
    
    YJYPriceTypeBoth,
    YJYPriceTypeOnlyOne,
    YJYPriceTypeOnlyMany,
};

@interface YJYOrderCreatePriceCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *priceArray;
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerLine;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property (weak, nonatomic) IBOutlet UIButton *pubButton;
@property (assign, nonatomic) BOOL isSingle;
@property (assign, nonatomic) YJYPriceType priceType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pubWidth;


@property (copy, nonatomic) YJYOrderCreatePriceCellDidSelectBlock didSelectBlock;
@property (copy, nonatomic) YJYOrderCreatePriceCellDidSwitchBlock didSwitchBlock;
@property (copy, nonatomic) YJYOrderCreateServiceItemCellDidSelectBlock didSelectToDetailBlock;

- (CGFloat)cellHeight;
- (IBAction)toSwitchPackage:(UIButton *)sender;

@end
