//
//  YJYInsureCardPlanModeAddController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/20.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCardPlanModeAddController.h"
#import "YJYFilterView.h"
@interface YJYInsureCardPlanModeAddCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@property (strong, nonatomic) TendDetail *tend;

@end

@implementation YJYInsureCardPlanModeAddCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    NSString *name = selected == YES ?  @"app_select_icon" : @"app_unselect_icon";
    self.selectedImageView.image = [UIImage imageNamed:name];
}
- (void)setTend:(TendDetail *)tend {
    
    _tend = tend;
    self.titleLabel.text = tend.tendDetail;
    
}

@end


@interface YJYInsureCardPlanModeAddContentController :YJYTableViewController
@property (strong, nonatomic) InsureOrderTendDetailBO *insureOrderTendDetailBO;
@property (strong, nonatomic) GetIllnessListRsp *rsp;
@property (nonatomic, readwrite) GPBUInt64Array *illnessIdArray;


@end

@implementation YJYInsureCardPlanModeAddContentController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetTendDetailListReq *req = [GetTendDetailListReq new];
    req.detailTypeId = self.insureOrderTendDetailBO.detailTypeId;
    req.illnessIdArray = self.illnessIdArray;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetTendDetailList message:req controller:self command:APP_COMMAND_SaasappgetTendDetailList success:^(id response) {
        
        self.rsp = [GetIllnessListRsp parseFromData:response error:nil];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureCardPlanModeAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureCardPlanModeAddCell" forIndexPath:indexPath];
    
    
    TendDetail* tendDetail= self.rsp.detailListArray[indexPath.row];
    cell.tend = tendDetail;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TendDetail* tendDetail= self.rsp.detailListArray[indexPath.row];

    CGSize size = [tendDetail.tendDetail boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 34, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    double height = ceil(size.height);
    
    return 70 + (height - 17);
    
}


- (IBAction)toFilterAction:(id)sender {
    
   
}

@end



@interface YJYInsureCardPlanModeAddController ()
@property (strong, nonatomic) YJYInsureCardPlanModeAddContentController *contentVC;
@end

@implementation YJYInsureCardPlanModeAddController

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
    
    if ([segue.identifier isEqualToString:@"YJYInsureCardPlanModeAddContentController"]) {
        
        self.contentVC = (YJYInsureCardPlanModeAddContentController *)segue.destinationViewController;
        self.contentVC.insureOrderTendDetailBO = self.insureOrderTendDetailBO;
    }
    
}
- (IBAction)done:(id)sender {
    
    NSMutableArray *tendDetailsM = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.contentVC.tableView.indexPathsForSelectedRows.count; i++) {
        NSIndexPath *indexPath = self.contentVC.tableView.indexPathsForSelectedRows[i];
        
        TendDetail* tendDetail= self.contentVC.rsp.detailListArray[indexPath.row];
        [tendDetailsM addObject:tendDetail];
    }
    
    if (self.didDoneBlock) {
        self.didDoneBlock(tendDetailsM);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
}
- (IBAction)toFilterAction:(id)sender {
    
    YJYFilterView *vc = [YJYFilterView instancetypeWithXIB];
    vc.frame = [UIApplication sharedApplication].keyWindow.bounds;
    vc.illnessListArray = self.contentVC.rsp.illnessListArray;
    vc.didDoneBlock = ^(NSArray *illnesses) {
        
        
        self.contentVC.illnessIdArray = [GPBUInt64Array array];
        for (Illness *illness in illnesses) {
            
            [self.contentVC.illnessIdArray addValue:illness.id_p];
        }
        [self.contentVC loadNetworkData];
        
    };
    [vc showInView:nil];
}

@end
