//
//  YJYOrderHospitalPackageCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderHospitalPackageCell.h"
#import "YJYPackageCell.h"

@interface YJYOrderHospitalPackageCell()<UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) uint32_t adCode;
@property (strong, nonatomic) GetPriceRsp *rsp;
@property (strong, nonatomic) NSMutableArray<CompanyPriceVO*> *familyPriceVolistArray;

@end

@implementation YJYOrderHospitalPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tableView.noShow =YES;
    self.familyPriceVolistArray = [NSMutableArray array];
}

#pragma mark - Network

- (void)setReq:(GetPriceReq *)req {
    
    _req = req;
    
    [YJYNetworkManager requestWithUrlString:APPGetPrice message:req controller:nil command:APP_COMMAND_AppgetPrice success:^(id response) {
        
        //rsp
        self.rsp = [GetPriceRsp parseFromData:response error:nil];
        self.familyPriceVolistArray = self.rsp.familyPriceVolistArray;
        
        if (self.didLoadedBlock) {
            self.didLoadedBlock();
        }
        
        [self.tableView reloadAllData];
        
        
        for (NSInteger i = 0; i < self.familyPriceVolistArray.count; i++) {
            Price *price = [self.familyPriceVolistArray[i] price];
            if (price.defaultStatus == 1) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                if (self.didSelectBlock) {
                    self.didSelectBlock(self.familyPriceVolistArray[i]);
                }
            }
        }
        
       // if (self.tableView.indexPathsForSelectedRows.count == 0 && self.familyPriceVolistArray.count > 0) {
          //  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO /scrollPosition:UITableViewScrollPositionNone];
            
          //  if (self.didSelectBlock) {
           //     self.didSelectBlock(self.familyPriceVolistArray[0]);
           // }
        //}
        
    } failure:^(NSError *error) {
        [self.tableView reloadErrorData];
    }];
}



- (CGFloat)cellHeight {

    return self.familyPriceVolistArray.count * 50 + 50;
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.familyPriceVolistArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YJYPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYPackageCell"];
    
    
    NSArray *arr =  self.familyPriceVolistArray;
    CompanyPriceVO *cPrice = arr[indexPath.row];
    cell.cPrice = cPrice;
    
    
    cell.packageCellDidSelectBlock = ^{
        
        if (self.packageCellDidSelectBlock) {
            self.packageCellDidSelectBlock(cPrice.price);
        }
       
    };
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = APPHEXCOLOR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr =  self.familyPriceVolistArray;
    CompanyPriceVO *cPrice = arr[indexPath.row];
    if (self.didSelectBlock) {
        self.didSelectBlock(cPrice);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 50;
}


@end
