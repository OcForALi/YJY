//
//  YJYOrderCreatePriceCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderCreatePriceCell.h"


@interface YJYOrderCreateServiceItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) id price;

@end

@implementation YJYOrderCreateServiceItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    if (self.userInteractionEnabled) {
        self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseGrayCOLOR;
        self.selectImageView.image = [UIImage imageNamed:(selected ? @"app_select_icon": @"app_unselect_icon")];

    }
}

- (void)setPrice:(id)price createType:(YJYOrderCreateType)createType index:(NSInteger)index {
    
    if (createType == YJYOrderCreateTypeLongNurse) {
        if (index == 0) {
            self.titleLabel.textColor = APPNurseGray30COLOR;
            self.titleLabel.text = @"基础服务（必选项）";
            self.selectImageView.image = [UIImage imageNamed:@"app_disable_icon"];
            self.userInteractionEnabled = NO;
        }
    }
    [self setPrice:price];

}

- (void)setPrice:(id)price {
    
    _price = price;
    
    if ([price isKindOfClass:[Price class]]) {
        
        self.titleLabel.text = [(Price *)price serviceItem];
        self.priceLabel.text = [(Price *)price priceStr];
        
    }else if ([price isKindOfClass:[CompanyPriceVO class]]) {
        
        self.titleLabel.text = [[(CompanyPriceVO *)price price] serviceItem];
        self.priceLabel.text = [[(CompanyPriceVO *)price price] priceStr];
        
        
    }
}

@end

@interface YJYOrderCreatePriceCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *switchHeaderView;

/// 服务类型 0-居家 1-专陪  2-多陪
@property(nonatomic, readwrite) uint32_t lastServiceType;

@property (strong, nonatomic) UIButton *selectedButton;


@end

@implementation YJYOrderCreatePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.privateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.pubButton.titleLabel.textAlignment = NSTextAlignmentCenter;
   
    self.priceArray = [NSMutableArray array];

   

}
-(void)setPriceType:(YJYPriceType)priceType {
    
    _priceType = priceType;
    if (priceType == YJYPriceTypeOnlyOne) {
        
        
        self.privateWidth.constant = kScreenW;
        self.privateButton.selected = YES;
        
        self.privateButton.hidden = NO;
        self.pubButton.hidden = YES;
        
        
    }else if (priceType == YJYPriceTypeOnlyMany) {
        
        self.pubWidth.constant = kScreenW;
        self.pubButton.selected = YES;
        
        self.privateButton.hidden = YES;
        self.pubButton.hidden = NO;
        
    }else {
        
        self.privateWidth.constant = kScreenW/2;
        self.pubWidth.constant = kScreenW/2;
        self.privateButton.hidden = NO;
        self.pubButton.hidden = NO;
        
    }
    self.headerLine.hidden = (priceType != YJYPriceTypeBoth);
}



- (void)setCreateType:(YJYOrderCreateType)createType {
    _createType = createType;
    self.tableView.allowsMultipleSelection = (createType == YJYOrderCreateTypeLongNurse);
    
    BOOL isHideHeader = self.createType != YJYOrderCreateTypeHospital;
    
    self.switchHeaderView.hidden = isHideHeader;
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, isHideHeader ? kCreateHeaderWithoutSwitchH : kCreateHeaderH);
   
}

- (CGFloat)cellHeight {

    BOOL isHideHeader = self.createType != YJYOrderCreateTypeHospital;

    CGFloat headerH = isHideHeader ? kCreateHeaderWithoutSwitchH: kCreateHeaderH;
    
    return self.priceArray.count > 0 ?  headerH + self.priceArray.count * 50 : 0;
}

- (YJYSwitchType)swichType {
    
    if (self.serviceType == YJYWorkerServiceTypeMany && self.lastServiceType == YJYWorkerServiceTypeMany) {
        return YJYSwitchTypeM2M;
    }else if (self.serviceType == YJYWorkerServiceTypeOne && self.lastServiceType == YJYWorkerServiceTypeMany) {
        return YJYSwitchTypeO2M;
    }else if (self.serviceType == YJYWorkerServiceTypeMany && self.lastServiceType == YJYWorkerServiceTypeOne) {
        return YJYSwitchTypeM2O;
    }else  {
        return YJYSwitchTypeO2O;
    }
    
}

- (void)setPriceArray:(NSMutableArray *)priceArray {
    
    _priceArray = priceArray;
   
    if (self.priceArray.count > 0 && self.createType != YJYOrderCreateTypeHospital) {
        
        id price = self.priceArray.firstObject;
        if ([price isKindOfClass:[CompanyPriceVO class]]) {
            self.prePayLabel.text = [NSString stringWithFormat:@"预付金:%@",[(CompanyPriceVO *)price prepayAmount]];
        }
   
    }
    
    if (self.createType == YJYOrderCreateTypeHospital) {
        
        if (self.hospitalPrepayAmount.length > 0) {
            self.prePayLabel.text = [NSString stringWithFormat:@"预付金:%@",self.hospitalPrepayAmount];
            
        }
        
    }
    
    [self.tableView reloadAllData];
    
    if (!self.isModify) {
        for (NSInteger i = 0; i < priceArray.count; i++) {
            
            id price = priceArray[i];
            
            if ([price isKindOfClass:[CompanyPriceVO class]]) {
                
                if ([(CompanyPriceVO *)price price].defaultStatus == 1) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    if (self.didSelectSyncBlock) {
                        self.didSelectSyncBlock([(CompanyPriceVO *)price price]);
                    }
                    break;
                    
                }
                
                
                
            }else {
                
                
                if ([(Price *)price priceId] == self.selectedPriceID || [(Price *)price defaultStatus] == 1) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    if (self.didSelectSyncBlock) {
                        self.didSelectSyncBlock(price);
                    }
                    break;
                    
                }
                
                
            }
            
            
        }
    }
    
    
 
   
}
- (void)setSelectedPriceID:(uint64_t)selectedPriceID {
    
    _selectedPriceID = selectedPriceID;
//    [self toSelectTableView];

}
- (void)setPriceName:(NSArray *)priceName {
    
    _priceName = priceName;
    [self toSelectTableView];

}

- (UpdateOrderServeReq *)createReqAdditionArrayAndPriceId:(UpdateOrderServeReq *)req
                                               insureType:(uint32_t)insureType{
    
    GPBUInt64Array *additionArray = [GPBUInt64Array array];
    for (NSInteger i = 0; i < self.tableView.indexPathsForSelectedRows.count; i++) {
        
        NSIndexPath *indexPath = self.tableView.indexPathsForSelectedRows[i];
        id price = self.priceArray[indexPath.row];
        uint64_t priceID;
        
        if ([price isKindOfClass:[Price class]]) {
            
            priceID = [(Price *)price priceId];
            
        }else {
            
            priceID = [[(CompanyPriceVO *)price price] priceId];
        }
        
        [additionArray insertValue:priceID atIndex:i];
    }
    
    
    if (additionArray.count > 0) {
        req.priceId  = [additionArray valueAtIndex:0];
        if (insureType == 1) {
            [additionArray removeValueAtIndex:0];
        }
        
    }
    
    req.additionArray = additionArray;
    
    return req;
}

- (void)toSelectTableView {

    
    for (NSInteger i = 0; i < self.priceArray.count ; i++) {
        
        id price = self.priceArray[i];
        NSString *name;
        uint64_t ID = 0;

        if ([price isKindOfClass:[Price class]]) {
        
            name = [(Price *)price serviceItem];
            ID = [(Price *)price priceId];
        }else if ([price isKindOfClass:[CompanyPriceVO class]]) {
            
            name = [[(CompanyPriceVO *)price price] serviceItem];
            ID = [[(CompanyPriceVO *)price price] priceId];
        }
        
        
        if ([self.priceName containsObject:name]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
            
        }else if (self.selectedPriceID == ID) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
            break;
        }
    }
    
   
}


- (IBAction)toSwitchPackage:(UIButton *)sender {
    
    if (self.priceType != YJYPriceTypeBoth) {
        return;
    }
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    self.lastServiceType = sender.tag == 0 ? YJYWorkerServiceTypeOne : YJYWorkerServiceTypeMany;

    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.headerLine.frame = CGRectMake(self.headerLine.frame.size.width * sender.tag, self.headerLine.frame.origin.y, self.headerLine.frame.size.width, self.headerLine.frame.size.height);
        
        if (self.didSwicthBlock) {
            self.didSwicthBlock(self.lastServiceType);
        }
    }];
    
    
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.priceArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderCreateServiceItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderCreateServiceItemCell"];
    
    [cell setPrice:self.priceArray[indexPath.row] createType:self.createType index:indexPath.row];

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.allowsMultipleSelection &&
        [[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;
    }
    return indexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    id price = self.priceArray[indexPath.row];
    if ([price isKindOfClass:[CompanyPriceVO class]]) {
        
        self.prePayLabel.text = [NSString stringWithFormat:@"预付金:%@",[(CompanyPriceVO *)price prepayAmount]];
        
    }
    
    
    
    
    if (self.didSelectBlock) {
        
        
        if ([price isKindOfClass:[Price class]]) {
            
            self.didSelectBlock([price priceId], [price prepayFeeStr]);

            
        }else if ([price isKindOfClass:[CompanyPriceVO class]]) {
            
            self.didSelectBlock([[(CompanyPriceVO *)price price] priceId], [(CompanyPriceVO *)price prepayAmount]);

            
            
        }
        
    }
    
    if (self.didSelectSyncBlock) {
        self.didSelectSyncBlock(price);
    }
    
    
    
}


@end
