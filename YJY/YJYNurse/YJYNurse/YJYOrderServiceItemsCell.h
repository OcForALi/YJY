//
//  YJYOrderServiceItemsCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJYOrderItemsExpandView.h"


@interface YJYOrderServiceItemsCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray<NSString*> *priceNameArray;
@property (copy, nonatomic) YJYOrderItemsExpandBlock didExpandBlock;
@property (weak, nonatomic) IBOutlet YJYOrderItemsExpandView *expandView;

- (CGFloat)cellHeight;
@end
