//
//  YJYOrderHospitalPackageCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/8/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

typedef void(^YJYOrderHospitalPackageCellDidSelectBlock)(CompanyPriceVO *price);
typedef void(^YJYOrderHospitalPackageCellDidLoadedBlock)();
typedef void(^HospitalPackageCellDidSelectBlock)(Price *price);

#import <UIKit/UIKit.h>
#import "YJYPackageCell.h"


@interface YJYOrderHospitalPackageCell : UITableViewCell

@property (strong, nonatomic) GetPriceReq *req;

@property (weak, nonatomic) IBOutlet YJYTableView *tableView;

@property (copy, nonatomic) YJYOrderHospitalPackageCellDidSelectBlock didSelectBlock;
@property (copy, nonatomic) YJYOrderHospitalPackageCellDidLoadedBlock didLoadedBlock;
@property (copy, nonatomic) HospitalPackageCellDidSelectBlock packageCellDidSelectBlock;


- (CGFloat)cellHeight;
@end
