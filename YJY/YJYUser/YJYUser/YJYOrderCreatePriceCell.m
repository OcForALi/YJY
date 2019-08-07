//
//  YJYOrderCreatePriceCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderCreatePriceCell.h"


@interface YJYOrderCreateServiceItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) Price *price;
@property (copy, nonatomic) YJYOrderCreateServiceItemCellDidSelectBlock didSelectBlock;

@end

@implementation YJYOrderCreateServiceItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    if (self.userInteractionEnabled) {
        self.titleLabel.textColor = selected ? APPHEXCOLOR : APPDarkGrayCOLOR;
        self.selectImageView.image = [UIImage imageNamed:(selected ? @"app_select_icon": @"app_unselect_icon")];

    }
}


- (void)setPrice:(Price *)price {
    
    _price = price;
    self.titleLabel.text = price.serviceItem;
    self.priceLabel.text = price.priceStr;
}
- (IBAction)toDetail:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock(self.price);
    }
}

@end

@interface YJYOrderCreatePriceCell()<UITableViewDelegate,UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerButtonView;

@property (strong, nonatomic) UIButton *selectedButton;

@end

@implementation YJYOrderCreatePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.noShow =YES;

    self.priceArray = [NSMutableArray array];
    
    self.privateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.pubButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    /// 服务类型 0-居家 1-专陪  2-多陪

    [self toSwitchPackage:self.pubButton];
    
    
}


#define kCreateHeaderH 80

- (CGFloat)cellHeight {

    return self.priceArray.count > 0 ?  kCreateHeaderH + self.priceArray.count * 50 : 0;
}

- (void)setPriceArray:(NSMutableArray *)priceArray {
    
    _priceArray = priceArray;
    [self.tableView reloadAllData];
    
    for (NSInteger i = 0; i < priceArray.count; i++) {
        Price *price = priceArray[i];
        if (price.defaultStatus == 1) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            if (self.didSelectBlock) {
                self.didSelectBlock(price);
            }
        }
    }

}
- (void)setIsSingle:(BOOL)isSingle {
    
    _isSingle = isSingle;
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width,80);
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
}


- (IBAction)toSwitchPackage:(UIButton *)sender {
    
    if (self.priceType != YJYPriceTypeBoth) {
        return;
    }
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.headerLine.frame = CGRectMake(self.headerLine.frame.size.width * sender.tag, self.headerLine.frame.origin.y, self.headerLine.frame.size.width, self.headerLine.frame.size.height);
        
        if (self.didSwitchBlock) {
            self.didSwitchBlock(sender.tag);
        }
    }];
    
    
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.priceArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderCreateServiceItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderCreateServiceItemCell"];
    cell.didSelectBlock = ^(Price *price) {
        if (self.didSelectToDetailBlock) {
            self.didSelectToDetailBlock(price);
        }
    };
    [cell setPrice:self.priceArray[indexPath.row]];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Price *price =  self.priceArray[indexPath.row];
    if (self.didSelectBlock) {
        self.didSelectBlock(price);
    }
}


@end
