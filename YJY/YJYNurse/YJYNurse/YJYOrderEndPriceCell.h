//
//  YJYOrderEndPriceCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/7/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYOrderEndPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (void)setOrderItem:(OrderItemVO2 *)orderItem index:(NSInteger)index;
@end
