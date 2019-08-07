//
//  YJYAddressSearchController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAddressSearchController.h"
#import <AMapSearchKit/AMapSearchKit.h>

#pragma mark - YJYAddressPositionCell

@interface YJYAddressPositionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation YJYAddressPositionCell


@end

@interface YJYAddressSearchController ()<AMapSearchDelegate,UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray <AMapPOI *> *pois; // 保存假数据
@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) AMapLocationManager *locationManager;
@property (copy, nonatomic) NSString *adcode;
@property (strong, nonatomic) UserAddressVO *address;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation YJYAddressSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pois = [NSMutableArray array];
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    [self setup];

    
    self.locationManager =  [[AMapLocationManager alloc]init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error){
                self.adcode = regeocode.adcode;}
        });
        
        
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(search:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}
- (void)setup {

    
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, self.searchTextField.frame.size.height)];
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_search_icon"]];
    leftImageView.center = leftView.center;
    [leftView addSubview:leftImageView];
    
    
    self.searchTextField.layer.cornerRadius = 5;
    self.searchTextField.placeholder = @"请搜索你的小区或大厦，街道名称";
    self.searchTextField.leftView= leftView;
    self.searchTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.pois count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YJYAddressPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAddressPositionCell" forIndexPath:indexPath];
    
    AMapPOI *poi = self.pois[indexPath.row];
    cell.titleLab.text = poi.name;
    cell.desLab.text = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.businessArea];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = self.pois[indexPath.row];
    
    if (!self.address) {
        self.address = [UserAddressVO new];
    }
    self.address = [UserAddressVO new];
    self.address.province = poi.province;
    self.address.city = poi.city;
    self.address.district = poi.district;
    self.address.building = poi.name;
    
//    self.address.addressInfo = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.businessArea];;
    
    self.address.lat = poi.location.latitude;
    self.address.lng = poi.location.longitude;
    
    self.address.adCode = poi.adcode;
    

    if (self.addressDidSearchBlock) {
        self.addressDidSearchBlock(self.address);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
}

#pragma mark - UISearch
- (void)search:(id)nofi {
    
    if ([self.searchTextField isFirstResponder]) {
        [self searchPoiWithText:self.searchTextField.text];
    }else {
        
        [self searchPoiWithText:nil];
        
    }
    
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    if (response.pois.count > 0)
    {
        self.pois = [NSMutableArray arrayWithArray:response.pois];
        [self.tableView reloadData];
        
    }
    
}


- (void)searchPoiWithText:(NSString *)text {
    
    
    if (!text ||text.length == 0 ) {
        self.pois = [NSMutableArray array];
        [self.tableView reloadData];
        return;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = text;
    request.requireExtension    = YES;
    request.requireSubPOIs      = YES;
    request.cityLimit = NO;
    request.city                = self.adcode;
    
    [self.search AMapPOIKeywordsSearch:request];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchTextField resignFirstResponder];
}

@end
