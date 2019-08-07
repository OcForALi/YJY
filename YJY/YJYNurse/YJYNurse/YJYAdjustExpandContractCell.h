//
//  YJYAdjustExpandContractCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYAdjustExpandContractCellExpandBlock)();
typedef void(^YJYAdjustExpandContractCellDidSelectPriceBlock)(CompanyPriceVO *price);

typedef NS_ENUM(NSInteger, YJYAdjustExpandType) {

    YJYAdjustExpandTypeVoordinary,
    YJYAdjustExpandTypeVoadjust,
    YJYAdjustExpandTypeVoprc,
};


@interface YJYAdjustExpandContractCell : UITableViewCell

@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSMutableArray<CompanyPriceVO *> *priceList;


@property (strong, nonatomic) IBOutlet UILabel *serviceDesLabel;


@property (copy, nonatomic) YJYAdjustExpandContractCellExpandBlock didExpandBlock;
@property (copy, nonatomic) YJYAdjustExpandContractCellDidSelectPriceBlock didSelectPriceBlock;
@property (assign, nonatomic) YJYAdjustExpandType adjustExpandType;

- (CGFloat)cellHeight;

@end
