//
//  YJYLongNurseMedicalRecordController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/27.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNurseMedicalRecordController.h"


@interface YJYLongNurseMedicalRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;



@end

@implementation YJYLongNurseMedicalRecordCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
    self.checkImageView.hidden = !selected;
    self.backgroundColor = selected ? APPSaasF4Color : [UIColor whiteColor];
}

@end

@interface YJYLongNurseMedicalRecordContentController : YJYTableViewController


@property (strong, nonatomic) MedicalRsp *rsp;

@property (strong, nonatomic) NSMutableArray<NSString*> *medicalArray;
@property (nonatomic, strong) InsureNOModel *insureModel;
@property (assign, nonatomic) BOOL isEdit;
@property (copy, nonatomic) DidDoneBlock didDoneBlock;



@end

@implementation YJYLongNurseMedicalRecordContentController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.medicalArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData{

    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureMedicalList message:nil controller:nil command:APP_COMMAND_SaasappgetInsureMedicalList success:^(id response) {
        
        self.rsp = [MedicalRsp parseFromData:response error:nil];
        self.medicalArray = self.rsp.medicalArray;
        [self reloadAllData];
        
        [self reloadInsureModel];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
    
    
}
- (void)reloadInsureModel {
    
    self.tableView.allowsSelection = self.isEdit;
    for (NSInteger i = 0; i < self.insureModel.medicalListArray.count; i ++) {
        
        NSInteger j = [self.medicalArray indexOfObject:self.insureModel.medicalListArray[i]];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:j inSection:0];
        [self.tableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        
    }
    
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.medicalArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYLongNurseMedicalRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYLongNurseMedicalRecordCell"];
    cell.titleLabel.text = self.medicalArray[indexPath.row];
    return cell;
    
}




- (IBAction)doneAction:(id)sender {

    
    [SYProgressHUD show];
    
    AddInsureAssessMedicalReq *req = [AddInsureAssessMedicalReq new];
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        
        [arrM addObject:self.medicalArray[indexPath.row]];
        
    }
    
    req.medicalListArray = arrM;
    req.insureNo = self.insureModel.insureNo;
    req.isCommit = 1;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssessMedical  message:req controller:self command:APP_COMMAND_SaasappinsureAssessMedical success:^(id response) {
        
        [SYProgressHUD hide];
        if (self.didDoneBlock) {
            self.didDoneBlock(arrM);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}


@end



@interface YJYLongNurseMedicalRecordController ()

@property (strong, nonatomic) YJYLongNurseMedicalRecordContentController *contentVc;
@property (weak, nonatomic) IBOutlet UIButton *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end


@implementation YJYLongNurseMedicalRecordController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.toolView.hidden = !self.isEdit;
    self.bottomConstraint.constant = self.isEdit ? 60 : 0;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"YJYLongNurseMedicalRecordContentController"]) {
        __weak typeof(self) weakSelf = self;
        self.contentVc = (YJYLongNurseMedicalRecordContentController *)segue.destinationViewController;
        self.contentVc.insureModel = self.insureModel;
        self.contentVc.isEdit = self.isEdit;
        self.contentVc.didDoneBlock = ^(NSArray *medicalArray) {
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock(medicalArray);
            }
        };
        
        
    }
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLongNurseMedicalRecordController *)[UIStoryboard storyboardWithName:@"YJYLongNurseDetail" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    [self.contentVc doneAction:nil];

}

- (IBAction)doneAction:(id)sender {
    
    [self.contentVc doneAction:nil];
}

@end
