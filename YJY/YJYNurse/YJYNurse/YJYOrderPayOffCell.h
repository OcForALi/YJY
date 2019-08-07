//
//  YJYOrderPayOffCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJYOrderPayOffType) {

    YJYOrderPayOffTypeService,
    YJYOrderPayOffTypePayOff,
};

@interface YJYOrderPayOffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<OrderItemVO2*> *orderSettlPayListArray;
@property (assign, nonatomic) YJYOrderPayOffType payOffType;


- (CGFloat)cellHeight;

@end
