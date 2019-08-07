//
//  YJYHWeightController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYHWeightController.h"
#import "AKPickerView.h"
#import "YJYinfoCell.h"

@interface YJYHWeightController ()<AKPickerViewDelegate,AKPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (strong, nonatomic)IBOutlet AKPickerView *weightPickerView;

@property (weak, nonatomic) IBOutlet AKPickerView *heightPickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTopConstraint;
@end

@implementation YJYHWeightController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYHWeightController *)[UIStoryboard storyboardWithName:@"YJYPerson" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupPicker:self.weightPickerView];
    [self.weightPickerView selectItem:self.weight animated:YES];
    
    [self setupPicker:self.heightPickerView];
    [self.heightPickerView selectItem:self.height animated:YES];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_white_icon" highImage:@"back_white_icon" target:self action:@selector(backAction:)];

    self.heightTopConstraint.constant = IS_IPHONE_5 ? 0 : 100;

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(0, 255, 0, 0)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)setupPicker:(AKPickerView *)picker{


    picker.delegate = self;
    picker.dataSource = self;
    picker.backgroundColor = [UIColor clearColor];
    picker.interitemSpacing = 22.0;
    //    self.pickerView.fisheyeFactor = 0.001;
    picker.pickerViewStyle = AKPickerViewStyleFlat;
    picker.maskDisabled = YES;
    
    [picker reloadData];
    
}
#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    
    if (pickerView == self.weightPickerView) {
        
        self.weight = item;
        self.weightLabel.text = [NSString stringWithFormat:@"%@ KG",@(item)];
    }else if (pickerView == self.heightPickerView) {
        
        self.height = item;
        self.heightLabel.text = [NSString stringWithFormat:@"%@ CM",@(item)];
    }
}

#pragma mark - AKPickerViewDataSource
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {

    return 300;
}

- (UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    YJYinfoCell *cellM = (YJYinfoCell *)cell;
    if (indexPath.row%5 != 0) {
        cellM.numberLabel.hidden = YES;
        cellM.topConstraint.constant = 6;
    }else {
        cellM.numberLabel.hidden = NO;
        cellM.topConstraint.constant = 0;

    }
    
    cellM.numberLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    
    cellM.backgroundColor = [UIColor clearColor];
    return cellM;

}
- (NSString *)registerClass {

    return NSStringFromClass([YJYinfoCell class]);

}

#pragma mark -  backAction

- (IBAction)backAction:(id)sender {
    
    if (self.dismissBlcok) {
        self.dismissBlcok(self.weight, self.height);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
