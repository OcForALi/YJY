//
//  YJYInsureCardPlanManualAddController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/20.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCardPlanManualAddController.h"
#import "YJYInsureCardPlanModeAddController.h"


typedef void(^YJYInsureCardPlanManualAddCellDidSelectBlock)();
typedef void(^YJYInsureCardPlanManualAddCellDidBeginEditBlock)();
typedef void(^YJYInsureCardPlanManualAddCellDidEndEditBlock)(NSString *text);

@interface YJYInsureCardPlanManualAddCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (copy, nonatomic) YJYInsureCardPlanManualAddCellDidSelectBlock didDeleteBlock;
@property (copy, nonatomic) YJYInsureCardPlanManualAddCellDidBeginEditBlock didBeginEditBlock;
@property (copy, nonatomic) YJYInsureCardPlanManualAddCellDidEndEditBlock didEndEditBlock;

@property (strong, nonatomic)  OrderTendDetail *orderTendDetail;

@end

@implementation YJYInsureCardPlanManualAddCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentTextView.delegate = self;
}

- (IBAction)toDelete:(id)sender {
    
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}



- (void)setOrderTendDetail:(OrderTendDetail *)orderTendDetail {
    
    _orderTendDetail = orderTendDetail;
    
    self.contentTextView.text = orderTendDetail.content;

}
#pragma mark - UITextView

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (self.didBeginEditBlock) {
        self.didBeginEditBlock();
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.didEndEditBlock) {
        self.didEndEditBlock(self.contentTextView.text);
    }
}

@end


@interface YJYInsureCardPlanManualAddContentController :YJYTableViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) InsureOrderTendDetailBO *insureOrderTendDetailBO;

@property (strong, nonatomic) NSIndexPath *curIndexPath;

@end

@implementation YJYInsureCardPlanManualAddContentController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.titleLabel.text = self.insureOrderTendDetailBO.detailTypeName;
    [self reloadAllData];
}



#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.insureOrderTendDetailBO.tendDetailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureCardPlanManualAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureCardPlanManualAddCell" forIndexPath:indexPath];
    
    
    OrderTendDetail *orderTendDetail = self.insureOrderTendDetailBO.tendDetailListArray[indexPath.row];
    cell.orderTendDetail = orderTendDetail;
    cell.didDeleteBlock = ^{
        [self toDelete:indexPath];
    };
    cell.didBeginEditBlock = ^{
        self.curIndexPath = indexPath;
    };
    cell.didEndEditBlock = ^(NSString *text) {
    
        self.curIndexPath = nil;
        orderTendDetail.content = text;
        self.insureOrderTendDetailBO.tendDetailListArray[indexPath.row] = orderTendDetail;
        
        
    };
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 170;
}


#pragma mark - Action

- (IBAction)addDetail:(id)sender {

    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"模板添加" otherButtonTitles:@[@"手动添加"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 2) {
            
            OrderTendDetail *orderTendDetail = [OrderTendDetail new];
            orderTendDetail.tendDetailId = -1;
            [self.insureOrderTendDetailBO.tendDetailListArray addObject:orderTendDetail];
            [self.tableView reloadData];
        }else if (buttonIndex == 1) {
            
            
            YJYInsureCardPlanModeAddController *vc = [YJYInsureCardPlanModeAddController instanceWithStoryBoard];
            
            vc.insureOrderTendDetailBO = self.insureOrderTendDetailBO;
            vc.didDoneBlock = ^(NSArray *tendDetailsM) {
                
                //
                NSMutableArray *orderTendDetailM = [NSMutableArray array];
                for (NSInteger i = 0; i < tendDetailsM.count; i++) {
                    
                    TendDetail *tendDetail = tendDetailsM[i];
                    OrderTendDetail *orderTendDetail = [OrderTendDetail new];
                    orderTendDetail.content = [NSString stringWithFormat:@"%@",tendDetail.tendDetail];
                    orderTendDetail.tendDetailId = tendDetail.id_p;
                    [orderTendDetailM addObject:orderTendDetail];
                }
                
                [self.insureOrderTendDetailBO.tendDetailListArray addObjectsFromArray:orderTendDetailM];
                [self reloadAllData];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }];
}

- (void)toDelete:(NSIndexPath *)indexPath {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否删除" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self.insureOrderTendDetailBO.tendDetailListArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];

        }
        
    }];
    
}
@end

@interface YJYInsureCardPlanManualAddController ()
@property (strong, nonatomic) YJYInsureCardPlanManualAddContentController *contentVC;
@end

@implementation YJYInsureCardPlanManualAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureCardPlanAdd" viewControllerIdentifier:className];
    return vc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureCardPlanManualAddContentController"]) {
        
        self.contentVC = (YJYInsureCardPlanManualAddContentController *)segue.destinationViewController;
        self.contentVC.insureOrderTendDetailBO = self.insureOrderTendDetailBO;
    }
    
}
- (IBAction)done:(id)sender {
    
    
    SaveOrderTendDetailReq *req = [SaveOrderTendDetailReq new];
    req.orderTendId = self.tendDetailRsp.orderTendId;
    req.tendDetailTypeId = self.insureOrderTendDetailBO.detailTypeId;
    
    NSMutableArray<OrderTendDetailBO*> *detailListArray = [NSMutableArray array];

    for (NSInteger i=0; i< self.contentVC.insureOrderTendDetailBO.tendDetailListArray.count;i++) {
        
        OrderTendDetail *orderTendDetail = self.contentVC.insureOrderTendDetailBO.tendDetailListArray[i];
        OrderTendDetailBO *orderTendDetailBO = [OrderTendDetailBO new];
        orderTendDetailBO.tendDetailId = orderTendDetail.tendDetailId;
        NSString *noStr;
        if ([orderTendDetail.content hasPrefix:[NSString stringWithFormat:@"%@.",@(i+1)]]) {
            noStr = @"";
        }else {
            noStr = [NSString stringWithFormat:@"%@.",@(i+1)];

        }
        orderTendDetailBO.content = [NSString stringWithFormat:@"%@%@\n",noStr,orderTendDetail.content];
        
        
        [detailListArray addObject:orderTendDetailBO];
    }
 
    req.detailListArray = detailListArray;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrderTendDetail message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrderTendDetail success:^(id response) {
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
   
}

@end
