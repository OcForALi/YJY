//
//  YJYOrderNightCell.m
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOrderNightCell.h"

#define YJYOrderNightCellHeader 44
#define YJYOrderNightAddServiceCellH 70
#define YJYOrderNightServiceRecordCellH 110

#pragma mark - YJYOrderNightAddServiceCell

typedef void(^YJYOrderNightAddServiceCellDidAdd)();


@interface YJYOrderNightAddServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (copy, nonatomic) YJYOrderNightAddServiceCellDidAdd didAddBlock;

@property (strong, nonatomic) PriceVO *priceVo;

@end

@implementation YJYOrderNightAddServiceCell
- (IBAction)addAction:(id)sender {
    
    if (self.didAddBlock) {
        self.didAddBlock();
    }
}
- (void)setPriceVo:(PriceVO *)priceVo {
    
    _priceVo = priceVo;
    self.nameLabel.text = priceVo.serviceItem;
    self.priceLabel.text = priceVo.priceDesc;
    
}

@end

#pragma mark - YJYOrderNightServiceRecordCell


typedef void(^YJYOrderNightServiceRecordCellDidDel)();
typedef void(^YJYOrderNightServiceRecordCellDidGuide)();

@interface YJYOrderNightServiceRecordCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidTipLabel;

@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;

//@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@property (copy, nonatomic) YJYOrderNightServiceRecordCellDidDel didDelBlock;
@property (copy, nonatomic) YJYOrderNightServiceRecordCellDidGuide didGuideBlock;

@property (strong, nonatomic) OrderItemNightVO *orderItemNightVO;

@end

@implementation YJYOrderNightServiceRecordCell
- (IBAction)delAction:(id)sender {

    if (self.didDelBlock) {
        self.didDelBlock();
    }
}

- (IBAction)guideAction:(id)sender {
    
    if (self.didGuideBlock) {
        self.didGuideBlock();
    }
}

- (void)setOrderItemNightVO:(OrderItemNightVO *)orderItemNightVO {
    
    _orderItemNightVO = orderItemNightVO;
    self.nameLabel.text = orderItemNightVO.serviceItem;
    self.timeLabel.text = orderItemNightVO.createTimeStr;
    self.priceLabel.text = orderItemNightVO.priceDesc;
    
    self.serviceNameLabel.text = orderItemNightVO.hgName;
    
    self.delButton.hidden = (orderItemNightVO.status == 1);
    self.guideButton.hidden = (orderItemNightVO.status == 1);
    self.paidTipLabel.hidden = (orderItemNightVO.status == 0);
    self.paidTipLabel.text = @"已支付，不可调整";
    
}


@end

#pragma mark - YJYOrderNightCell

@interface YJYOrderNightCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet YJYTableView *tableView;

@end


@implementation YJYOrderNightCell

- (void)awakeFromNib {
    [super awakeFromNib];
   

    
}

- (void)setPriceVolistArray:(NSMutableArray<PriceVO *> *)priceVolistArray {
    
    _priceVolistArray = priceVolistArray;
    self.tableView.noDataTitle = @"暂无夜陪服务";
    [self.tableView reloadAllData];
}

- (void)setOrderItemNightVolistArray:(NSMutableArray<OrderItemNightVO *> *)orderItemNightVolistArray {
    
    _orderItemNightVolistArray = orderItemNightVolistArray;
    self.tableView.noDataTitle = @"暂无夜陪服务";
    [self.tableView reloadAllData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.nightCellType == YJYOrderNightCellTypeAddService) {
        
        return self.priceVolistArray.count;

    }else {
        return self.orderItemNightVolistArray.count;

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nightCellType == YJYOrderNightCellTypeAddService) {
        
        YJYOrderNightAddServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderNightAddServiceCell"];
        PriceVO *priceVo = self.priceVolistArray[indexPath.row];
        cell.priceVo = priceVo;
        cell.didAddBlock = ^{
            if (self.didAddBlock) {
                self.didAddBlock(priceVo);
            }
        };
        return cell;
    }else {
        
        YJYOrderNightServiceRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderNightServiceRecordCell"];
        OrderItemNightVO *orderItemNightVO = self.orderItemNightVolistArray[indexPath.row];
        cell.orderItemNightVO = orderItemNightVO;
        
        cell.didDelBlock = ^{
            if (self.didDelBlock) {
                self.didDelBlock(orderItemNightVO);
            }
            
        };
        cell.didGuideBlock = ^{
            if (self.didGuideBlock) {
                self.didGuideBlock(orderItemNightVO);
            }
        };

        return cell;
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return self.nightCellType == YJYOrderNightCellTypeAddService ? YJYOrderNightAddServiceCellH : YJYOrderNightServiceRecordCellH;
}

#pragma mark - height

- (CGFloat)cellHeight {
    
    CGFloat cellH = self.nightCellType == YJYOrderNightCellTypeAddService ? YJYOrderNightAddServiceCellH : YJYOrderNightServiceRecordCellH;
    BOOL isHeader = (self.nightCellType == YJYOrderNightCellTypeAddService) ? self.priceVolistArray.count  > 0 : self.orderItemNightVolistArray.count  > 0;
    
    
    CGFloat count = 0;
    if (self.nightCellType == YJYOrderNightCellTypeAddService) {
        
        count = self.priceVolistArray.count;
        
    }else {
        count = self.orderItemNightVolistArray.count;
        
    }
    
    return (isHeader ? 50 : 0) + count * cellH;

}


@end
