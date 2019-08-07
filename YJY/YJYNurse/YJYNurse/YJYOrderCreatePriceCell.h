//
//  YJYOrderCreatePriceCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCreateHeaderH 100
#define kCreateHeaderWithoutSwitchH (kCreateHeaderH - 50)

typedef NS_ENUM(NSInteger, YJYSwitchType) {

    YJYSwitchTypeM2M, //many to many
    YJYSwitchTypeM2O, //many to one
    YJYSwitchTypeO2M,
    YJYSwitchTypeO2O,
    
};

typedef NS_ENUM(NSInteger, YJYPriceType) {
    
    YJYPriceTypeBoth,
    YJYPriceTypeOnlyOne,
    YJYPriceTypeOnlyMany,
};

typedef void(^YJYOrderCreatePriceCellDidSwicthBlock)(NSInteger tag);
typedef void(^YJYOrderCreatePriceCellDidSelectBlock)(uint64_t priceId, NSString *prepayAmount);
typedef void(^YJYOrderCreatePriceCellDidSelectSyncBlock)(id price);


@interface YJYOrderCreatePriceCell : UITableViewCell
@property (copy, nonatomic) YJYOrderCreatePriceCellDidSwicthBlock didSwicthBlock;
@property (copy, nonatomic) YJYOrderCreatePriceCellDidSelectBlock didSelectBlock;
@property (copy, nonatomic) YJYOrderCreatePriceCellDidSelectSyncBlock didSelectSyncBlock;

@property (assign, nonatomic) BOOL isModify;
@property (assign, nonatomic) YJYOrderCreateType createType;
@property (assign, nonatomic) YJYPriceType priceType;
@property(nonatomic, readwrite) uint32_t serviceType;


@property (assign, nonatomic) uint64_t selectedPriceID;
@property (strong, nonatomic) NSArray *priceName;
@property (strong, nonatomic) NSMutableArray *priceArray;
@property (strong, nonatomic) NSMutableArray *selectDictM;


@property (strong, nonatomic) NSString *hospitalPrepayAmount;

@property (weak, nonatomic) IBOutlet YJYTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property (weak, nonatomic) IBOutlet UIButton *pubButton;
@property (weak, nonatomic) IBOutlet UILabel *prePayLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privateWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pubWidth;


@property (weak, nonatomic) IBOutlet UIView *headerLine;


- (CGFloat)cellHeight;
- (YJYSwitchType)swichType;
- (IBAction)toSwitchPackage:(UIButton *)sender;
- (UpdateOrderServeReq *)createReqAdditionArrayAndPriceId:(UpdateOrderServeReq *)req
                                               insureType:(uint32_t)insureType;

@end
