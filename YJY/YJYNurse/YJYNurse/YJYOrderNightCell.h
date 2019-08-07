//
//  YJYOrderNightCell.h
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJYOrderNightCellType)  {
    
    YJYOrderNightCellTypeAddService,
    YJYOrderNightCellTypeServiceRecord,
};

typedef void(^YJYOrderNightCellDidDel)(OrderItemNightVO *orderItemNightVO);
typedef void(^YJYOrderNightCellDidGuide)(OrderItemNightVO *orderItemNightVO);

typedef void(^YJYOrderNightCellDidAdd)(PriceVO *priceVo);


@interface YJYOrderNightCell : UITableViewCell


@property (strong, nonatomic) NSMutableArray<PriceVO*> *priceVolistArray;
@property (strong, nonatomic) NSMutableArray<OrderItemNightVO*> *orderItemNightVolistArray;

@property (assign, nonatomic) YJYOrderNightCellType nightCellType;

@property (copy, nonatomic) YJYOrderNightCellDidDel didDelBlock;
@property (copy, nonatomic) YJYOrderNightCellDidGuide didGuideBlock;
@property (copy, nonatomic) YJYOrderNightCellDidAdd didAddBlock;

- (CGFloat)cellHeight;

@end
