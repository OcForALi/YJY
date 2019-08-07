
#import "YJYHomeController.h"
#import "SRInfiniteCarouselView.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "YJYOrderHospitalNurseController.h"
#import "YJYOrderDetailController.h"
#import "YJYSearchNearController.h"
#import "YJYOrderSettleController.h"

#import "YJYInsureIntroController.h"
#import "YJYInsureListController.h"
#import "YJYNewController.h"
#import "YJYBookTakePhotoController.h"
#import "YJYNearHospitalController.h"

#import "YJYMyOrderView.h"


#define kBannerHeight 230
#define kServiceViewHeight 155

#define kImageAdHeight 144
#define kCategoryHeight 230


#pragma mark - YJYIconCell

@class IndexServiceItem;
@interface YJYIconCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IndexServiceItem *item;

@end

@implementation YJYIconCell

- (void)setItem:(IndexServiceItem *)item  {

    _item = item;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:item.iconURL] placeholderImage:nil];
    
    self.titleLab.font = [UIFont systemFontOfSize:IS_IPHONE_5 ? 11 : 13];
    self.titleLab.text = item.iconDesc;
    
}

@end


#pragma mark - YJYNewCell

@class Information;
@interface YJYNewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) Information *information;

@end

@implementation YJYNewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}

- (void)setInformation:(Information *)information {
    
    _information = information;
    [self.imageView setImageWithURL:[NSURL URLWithString:information.imgURL] placeholderImage:[UIImage imageNamed:@"test"]];
    self.titleLab.text = information.title;

    
    self.desLab.attributedText = [information.sketch attributedStringWithLineSpacing:4];
    [self.desLab sizeToFit];
//    self.desLab.text = information.sketch;

    NSString * timeStampString = [NSString stringWithFormat:@"%@",@(information.createTime)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStampString doubleValue] / 1000];
    
    self.timeLab.text =  [NSDate getRealDateTime:date withFormat:MM_DD];
    

}


@end

#pragma mark - Animation View

@interface YJYAnimationView : UIView



@end

@implementation YJYAnimationView

@end


@interface YJYHomeController ()

<SRImageCarouselViewDelegate,IQActionSheetPickerViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
AMapLocationManagerDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainView;
@property (strong, nonatomic) IBOutlet SRInfiniteCarouselView *bannerView;
@property (strong, nonatomic) CAShapeLayer *bannerShapeLayer;

//orderView
@property (weak, nonatomic) IBOutlet YJYMyOrderView *orderView;
@property (weak, nonatomic) IBOutlet UIImageView *insureBgView;


//home care
@property (weak, nonatomic) IBOutlet UICollectionView *homeCareCollectionView;


//health new
@property (weak, nonatomic) IBOutlet UICollectionView *healthCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;


//data

@property (strong, nonatomic) AMapLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) uint32_t adcode;

@property (assign, nonatomic) BOOL needUpdate;
@property (assign, nonatomic) BOOL isValidCity;
@property (assign, nonatomic) BOOL isHasLogin;
@property (strong, nonatomic) UIImageView *barImageView;

@property (assign, nonatomic) BOOL hasData;
@property (assign, nonatomic) BOOL isUpdateTip;

@property (strong, nonatomic) OrgVO *currentOrgVo;
@property (strong, nonatomic) OrderCurrent *currentOrder;
@property (strong, nonatomic) GetSettingRsp *rsp;


//animation
@property (weak, nonatomic) IBOutlet UIImageView *waterTwoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationToBannerBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterOneLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterOneRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterTwoLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterTwoRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookLeftConstraint;
@end

@implementation YJYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertController * avc = [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"有新版本需要更新" message:@"应用功能需要更新后才可以使用" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1244685890"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }];
    NSArray *subviews =  avc.view.subviews;
    
    
    
    __weak typeof(self) weakSelf = self;

    self.hasData = NO;
    self.noDataTitle = @"重新加载";
    

    self.reloadButton.frame = CGRectMake(0, 0, 100, 40);
    self.reloadButton.center = self.view.center;
    self.reloadButton.layer.cornerRadius = 5;
    self.reloadButton.layer.borderColor = APPDarkGrayCOLOR.CGColor;
    self.reloadButton.layer.borderWidth = 1;
    [self.reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //banner
    
    [self.bannerView setupWithImageArrary:@[[UIImage imageNamed:@"app_place_img"]] describeArray:nil placeholderImage:[UIImage imageNamed:@"app_place_img"] delegate:self];
    self.bannerView.pageControl.hidden = YES;
    
    
   
    
    //locationManager
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
            {
                self.location = location;
                self.adcode = (uint32_t)[regeocode.adcode integerValue];
                [KeychainManager saveWithKey:kAdcode Value:regeocode.adcode];
                
                
            }
            [self loadNetworkData];
        });
       
    }];

    
    

    self.orderView = [YJYMyOrderView instancetypeWithXIB];
    self.orderView.layer.cornerRadius  = 8;
    self.orderView.layer.shadowColor   = [UIColor colorWithHexString:@"#000e08" alpha:0.1].CGColor;
    self.orderView.layer.shadowOffset  = CGSizeMake(3, 3);
    self.orderView.layer.shadowRadius  = 21.5;
    self.orderView.layer.shadowOpacity = 0.2;
    self.orderView.layer.masksToBounds = NO;
    self.orderView.center = CGPointMake(self.tableView.center.x, self.bannerContainView.center.y);

    self.orderView.orderViewDidSelectBlock = ^(OrderCurrent *order) {
        
        
        [weakSelf toOrderDetailWithOrderId:order.orderId];
      
    };
    [self.tableView addSubview:self.orderView];
    
    //setup
    YJYRefreshHeader *header = [YJYRefreshHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 70;
    

    [self.tableView setBackgroundColor:nil];
    [self setCurrentOrder:nil];
    
    
    [SYProgressHUD showToLoadingView:self.view];
    [self loadNetworkData];


}



- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    
    [maskPath moveToPoint:CGPointMake(0, 0)];
    [maskPath addLineToPoint:CGPointMake(self.bannerView.frame.size.width, 0)];
    [maskPath addLineToPoint:CGPointMake(self.bannerView.frame.size.width, self.bannerView.frame.size.height)];
    [maskPath addQuadCurveToPoint:CGPointMake(0, self.bannerView.frame.size.height) controlPoint:CGPointMake(self.bannerView.center.x, self.bannerView.frame.size.height - 30)];

    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bannerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bannerView.layer.mask = maskLayer;
    
    if (IS_IPHONE_5) {
        self.insureBgView.image = [UIImage imageNamed:@"home_insure_apply_5_bg"];
        self.insureBgView.contentMode = UIViewContentModeScaleAspectFit;
    }

    

}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
   
    //backImageView
    UIImage *bg = [UIImage imageNamed:@"app_home_bg"];
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.tableView.bounds];
    [backImageView setImage:bg];
    self.tableView.backgroundView = backImageView;

    [self loadNetworkData];
}

- (void)viewWillDisappear:(BOOL)animated {
    

    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];
   
    

}

#pragma mark - Action

- (void)toOrderDetailWithOrderId:(NSString *)orderId {

    GetOrderReq *req = [GetOrderReq new];
    req.orderId = orderId;
    [SYProgressHUD show];

    [YJYNetworkManager requestWithUrlString:APPPrePayAmountDetail message:req controller:self command:APP_COMMAND_AppprePayAmountDetail success:^(id response) {
        
        GetOrderPayDetailRsp *rsp = [GetOrderPayDetailRsp parseFromData:response error:nil];
        
        OrderVO *order = rsp.order;
        
        if(order.status == OrderStatus_ServiceIng ||
           order.status == OrderStatus_ServiceComplete ||
           order.status == OrderStatus_WaitAppraise||
           order.status == OrderStatus_OrderComplete){
            
            YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
            vc.order = order;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
            vc.order = order;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
    }];
    
   
    
}

- (IBAction)insureApplyAction:(id)sender {
    
    
    if ([self loginIntercept]) {return;}
    
    YJYInsureIntroController *vc = [YJYInsureIntroController instanceWithStoryBoard];
    vc.orderDidFinishBlock = ^(NSString *orderId) {
        
        [self loadNetworkData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tabBarController.selectedIndex = 1;
            
        });
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)insureListAction:(id)sender {
    
    if ([self loginIntercept]) {return;}

    YJYInsureListController *vc = [YJYInsureListController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)nearListHospitalAction:(id)sender {
    
    if (![YJYSettingManager sharedInstance].needOrder) {
        [SYProgressHUD showToCenterText:@"该服务暂未开通"];
        return;
        
    }
    
    YJYNearHospitalController *nears = [YJYNearHospitalController instanceWithStoryBoard];
    nears.isSearch = YES;
    nears.nearHospitalDidSelectBlock = ^(OrgDistanceModel *org) {
        
        self.currentOrgVo = org.orgVo;
        [self.hospitalButton setTitle:self.currentOrgVo.orgName forState:0];
        
    };
    
    [self.navigationController pushViewController:nears animated:YES];
    
}

- (IBAction)nearHospitalAction:(id)sender {
    
    if (![YJYSettingManager sharedInstance].needOrder) {
        [SYProgressHUD showToCenterText:@"该服务暂未开通"];
        return;

    }
    YJYSearchNearController *searchVC = [YJYSearchNearController instanceWithStoryBoard];
    searchVC.hospitalDidSelectBlock = ^(OrgDistanceModel *org) {
        
        self.currentOrgVo = org.orgVo;
        [self.hospitalButton setTitle:self.currentOrgVo.orgName forState:0];

        
    };
    [self.navigationController pushViewController:searchVC animated:YES];
    
}



- (IBAction)bookPublicAction:(UIButton *)sender {

    if (![YJYSettingManager sharedInstance].needOrder) {
        [SYProgressHUD showToCenterText:@"该服务暂未开通"];
        return;
        
    }
    
    if ([self loginIntercept]) {return;}
    
    YJYNearHospitalController *nears = [YJYNearHospitalController instanceWithStoryBoard];
    nears.isBooking = YES;
    nears.currentOrgVo = self.currentOrgVo;
    [self.navigationController pushViewController:nears animated:YES];

}

- (BOOL)loginIntercept {
    
    if (![YJYLoginManager isLogin]) {
        
        YJYLoginController *vc=  [YJYLoginController presentLoginVCWithInVC:self];
        vc.didSuccessLoginComplete = ^(id response) {
            
            [self loadNetworkData];
        };
        return YES;
    }
    
    return NO;

}

- (void)showUpdateAction {

    // 1-更新提醒 2-强制更新
    if (self.rsp.updateFlag == 1) {
        
        [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"有新版本需要更新" message:@"应用功能需要更新后才可以使用" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1244685890"];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }];
        
    }else if (self.rsp.updateFlag == 2) {
        
        [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"有新版本需要更新" message:@"应用功能需要更新后才可以使用" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1244685890"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
            
            
        }];
        
    }
}


#pragma mark - Carousel

- (void)imageCarouselViewDidTapImageAtIndex:(NSInteger)index {

    
    BannerModel *banner = [YJYSettingManager sharedInstance].banners[index];
    if (banner.URL && [banner.URL containsString:@"yjy://"]) {
        
        if ([YJYProtocolManager viewControllerWithProtocol:banner.URL]) {
            id vc = [YJYProtocolManager viewControllerWithProtocol:banner.URL];
//            BOOL isBook = ([vc isKindOfClass:[YJYOrderHospitalNurseController class]] || [vc isKindOfClass:[YJYInsureIntroController class]]);
            if (![YJYLoginManager isLogin]) {
                
                if ([self loginIntercept]) { return;}
                
            }else {
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            
            
        }
        
    }else if (banner.URL && [banner.URL containsString:@"http"]) {
        
        YJYWebController *webVC = [YJYWebController new];
        webVC.urlString = banner.URL;
        [self.navigationController pushViewController:webVC animated:YES];
    }else {
        
        
//        [SYProgressHUD showToCenterText:@"该服务暂未开通"];
    }
}

#pragma mark - data

- (void)reloadButtonAction:(UIButton *)sender {

    
    sender.spinner.color = APPDarkGrayCOLOR;
    [sender updateActivityIndicatorVisibility];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNetworkData];

    });
    //    [self.tableView.mj_header beginRefreshing];
}


- (void)loadNetworkData {
    
    [self loadSettingData];
    [self loadCurrentOrderData];
    
}


- (void)loadCurrentOrderData {

    
    if (![YJYLoginManager isLogin]) {
        self.currentOrder = nil;
        return;
    }
    
    
    [YJYNetworkManager requestWithUrlString:APPIndex message:nil controller:nil command:APP_COMMAND_Appindex success:^(id response) {
        
        
        IndexRsp *rsp = [IndexRsp parseFromData:response error:nil];
        if (rsp.hasOrderCur) {
            self.currentOrder = rsp.orderCur;
        }else {
            self.currentOrder = nil;
        }
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        self.currentOrder = nil;
        [self.tableView reloadData];
    }];
    
    
}

- (void)loadSettingData {


    GetSettingReq *req = [GetSettingReq new];
    req.adcode = self.adcode;
    if (self.location) {
        req.lat = self.location.coordinate.latitude;
        req.lng = self.location.coordinate.longitude;
    }
    
    
    [YJYNetworkManager requestWithUrlString:APPGetSettings message:req controller:self command:APP_COMMAND_AppgetSettings success:^(id response) {
        
        @try {
            GetSettingRsp *rsp = [GetSettingRsp parseFromData:response error:nil];
            self.rsp = rsp;
            
            self.isValidCity = rsp.isValidCity;
            
            [YJYSettingManager sharedInstance].needOrder = rsp.needOrder;
            //banner
            
            [YJYSettingManager sharedInstance].banners = rsp.bannerListArray;
            NSMutableArray *urls = [NSMutableArray array];
            for (NSInteger i = 0; i < [YJYSettingManager sharedInstance].banners.count; i ++) {
                
                BannerModel *banner = [YJYSettingManager sharedInstance].banners[i];
                
                NSString *extension = @".png";
                if ([banner.imgURL containsString:@".jpg"]) {
                    extension = @".jpg";
                }
                
//                NSString *nUrl = [banner.imgURL stringByReplacingOccurrencesOfString:extension withString:@""];
//                nUrl =[nUrl stringByAppendingFormat:@"_%dx%d%@",(int)self.bannerView.frame.size.width,(int)self.bannerView.frame.size.height,extension];
                [urls addObject:banner.imgURL];
            }
            
            [self.bannerView.images removeAllObjects];
            self.bannerView.imageArray = urls;
            [self.bannerView setupSubViews];
            
            //city
            
            [YJYSettingManager sharedInstance].citys = rsp.citysArray;
            
            //items
            
            [YJYSettingManager sharedInstance].items = rsp.itemsArray;
            [self.tableView reloadData];
            [self.homeCareCollectionView reloadData];
            
            //news
            [YJYSettingManager sharedInstance].inforListArray = rsp.inforListArray;
            [self.tableView reloadData];
            [self.healthCollectionView reloadData];
            
            //language
            
            [YJYSettingManager sharedInstance].languageList = rsp.languageListArray;
            
            
            
            
            //hospital
            if (self.currentOrgVo.orgName.length == 0) {
                self.currentOrgVo = rsp.orgVo;
                if (self.currentOrgVo.orgName.length > 0) {
                    [self.hospitalButton setTitle:self.currentOrgVo.orgName forState:0];
                }
            }
            
            
            [YJYSettingManager sharedInstance].currentOrgVo = self.currentOrgVo;
            
            
//            if ([YJYSettingManager sharedInstance].banners.count > 0) {
//
//            }else {
//
//                self.hasData = NO;
//
//            }
            self.hasData = YES;

            //urls
            
            [YJYSettingManager sharedInstance].insureDescURL = rsp.insureDescURL;

            
            //careCard
            [YJYSettingManager sharedInstance].medicareListArray = rsp.medicareListArray;

           
            
            
            [self reloadAllData];
            [[YJYSettingManager sharedInstance]saveSettingCache];
            [SYProgressHUD hide];
            
            if (!self.isUpdateTip) {
                [self showUpdateAction];

            }
            self.isUpdateTip = YES;
        

            
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        if ([[YJYSettingManager sharedInstance]isExistSetting]) {
            [[YJYSettingManager sharedInstance]getSettingCache];
            [self reloadSettingData];
        }else {
        
            self.hasData = NO;
            [self reloadErrorData];
            
        }
        
   
        
        
    }];
    
}




- (void)setCurrentOrder:(OrderCurrent *)currentOrder {

    
    _currentOrder = currentOrder;
    
    BOOL hasOrder = (currentOrder != nil && [YJYSettingManager sharedInstance].needOrder);
    self.orderView.hidden = !hasOrder || ![YJYSettingManager sharedInstance].needOrder;

    CGFloat width = self.tableView.frame.size.width/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.animationToBannerBottomConstraint.constant = (hasOrder ?  -20 : 0);
        
        self.waterTwoView.hidden = !hasOrder;
        
        self.waterOneLeftConstraint.constant = hasOrder ? - width : 0;
        self.waterOneRightConstraint.constant = hasOrder ? width : 0;
        
        self.waterTwoLeftConstraint.constant = hasOrder ? width : 0;
        self.waterTwoRightConstraint.constant = hasOrder ? - width : 0;
        
        
        if (currentOrder) {
            self.orderView.order = currentOrder;

        }
        [self.tableView reloadData];
    }];
}

- (void)reloadSettingData {

    
    self.hasData = YES;
    
    NSMutableArray *urls = [NSMutableArray array];
    for (NSInteger i = 0; i < [YJYSettingManager sharedInstance].banners.count; i ++) {
        
        BannerModel *banner = [YJYSettingManager sharedInstance].banners[i];
        
        NSString *extension = @".png";
        if ([banner.imgURL containsString:@".jpg"]) {
            extension = @".jpg";
        }
        
        NSString *nUrl = [banner.imgURL stringByReplacingOccurrencesOfString:extension withString:@""];
        nUrl =[nUrl stringByAppendingFormat:@"_%dx%d%@",(int)self.bannerView.frame.size.width,(int)self.bannerView.frame.size.height,extension];
        [urls addObject:banner.imgURL];
    }
    
    [self.bannerView.images removeAllObjects];
    self.bannerView.imageArray = urls;
    [self.bannerView setupSubViews];

    [self.tableView reloadData];
    [self.homeCareCollectionView reloadData];
    
    //news
    [self.tableView reloadData];
    [self.healthCollectionView reloadData];
    
    
    [self reloadAllData];


}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        //
        CGFloat height = ([YJYSettingManager sharedInstance].needOrder && self.currentOrder) ? (self.view.frame.size.width/2 - 40) : (self.view.frame.size.width/2 -  40);
        
        return height - (IS_IPHONE_5 ? 0 :0);
        
        
        
    }else if (indexPath.section == 1) {
        return 105 - (IS_IPHONE_5 ? 10 :0);
        
    }else if (indexPath.section == 2) {
        
       
        
        return 237;

        
    }else if (indexPath.section == 3) {
        
        if (self.hasData == NO) {
            return 0;
        }else {
            NSInteger count = [YJYSettingManager sharedInstance].items.count;
            
            NSInteger colunmOfRow = 5;
            NSInteger add = ((count%colunmOfRow > 0) ? 1 : 0);
            return 86 * ((int)count/colunmOfRow + add)  + 38;
        }
        
    }else if (indexPath.section == 4) {
        
        return self.hasData ?  320 : 0;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];

}



#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section    {
    
    
    if (collectionView == self.homeCareCollectionView) {
        
        return [YJYSettingManager sharedInstance].items.count;
        
    }else if (collectionView == self.healthCollectionView) {
    
        return [YJYSettingManager sharedInstance].inforListArray.count;
    }
    return 0;
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.homeCareCollectionView) {
        
        YJYIconCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYIconCell" forIndexPath:indexPath];
        IndexServiceItem *item = [YJYSettingManager sharedInstance].items[indexPath.row];
        cell.item = item;
        return cell;
        
        
    }else if (collectionView == self.healthCollectionView) {
        
        YJYNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYNewCell" forIndexPath:indexPath];
        cell.layer.borderColor = kColorAlpha(0, 0, 0, 0.2).CGColor;
        cell.layer.borderWidth = 0.3;
        cell.information = [YJYSettingManager sharedInstance].inforListArray[indexPath.row];
        return cell;
        
    }

    return nil;
    
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    
    if (collectionView == self.homeCareCollectionView) {
        
        if (![YJYSettingManager sharedInstance].needOrder) {
            [SYProgressHUD showToCenterText:@"该服务暂未开通"];
            return;
            
        }
        IndexServiceItem *item = [YJYSettingManager sharedInstance].items[indexPath.row];
        if (item.state == 0) {
            [UIAlertController showAlertInViewController:self withTitle:@"服务暂时未开通" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:nil];
            return;
        }
        
        if (item.nativeURL && item.nativeURL.length > 0) {
            
            if ([YJYProtocolManager viewControllerWithProtocol:item.nativeURL]) {
                
                id vc = [YJYProtocolManager viewControllerWithProtocol:item.nativeURL];
                if ([vc isKindOfClass:[YJYInsureIntroController class]]) {
                    
                    NSString *st = [(YJYInsureIntroController *)vc st];
                    vc = [YJYOrderHospitalNurseController instanceWithStoryBoard];
                    
                    BOOL isBook = ([vc isKindOfClass:[YJYOrderHospitalNurseController class]] || [vc isKindOfClass:[YJYInsureIntroController class]]);
                    
                    if (isBook && ![YJYLoginManager isLogin]) {
                        
                        if ([self loginIntercept]) { return;}
                        
                    }else {
                        
                    
                        [YJYInterceptManager interceptDidServiceNoExistWithSt:st adcode:self.adcode islti:NO succuss:^(id response) {
                            
                            YJYOrderHospitalNurseController *orderVC = (YJYOrderHospitalNurseController *)vc;
                            
//                            [orderVC setAdCode:(uint32_t)self.adcode];
                            [orderVC setSt:st];
                            orderVC.title = item.iconDesc;
                            orderVC.orderDidFinishBlock = ^(NSString *orderId) {
                                
                                [self loadNetworkData];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    self.tabBarController.selectedIndex = 1;
                                    
                                });
                            };
                            
                            
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        
                        
                        
                    }

                }
            
            }else if (item.URL && item.URL.length > 0) {
                
                YJYNewController *webVC = [YJYNewController instanceWithStoryBoard];
                webVC.urlString = item.URL;
                [self.navigationController pushViewController:webVC animated:YES];
            }else {
            
                
            }
        
        }
    
    }
        
    //healthCollectionView
        
    if (collectionView == self.healthCollectionView) {
        
       
        Information *information = [YJYSettingManager sharedInstance].inforListArray[indexPath.row];
        YJYNewController *vc = [YJYNewController instanceWithStoryBoard];
        vc.information = information;

        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
