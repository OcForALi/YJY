//
//  YJYInsureDisableView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/10.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureDisableView.h"
#import "YJYInsureImagesLayout.h"
#import <AFNetworking/UIButton+AFNetworking.h>

typedef void(^YJYInsureImageCellDidSelectBlock)();

@interface YJYInsureImageCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *imageButton;
@property (strong, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) YJYInsureImageCellDidSelectBlock didSelectBlock;
@end

@implementation YJYInsureImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.contentView.backgroundColor = APPSaasF4Color;
        self.clipsToBounds = YES;
        
        
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageButton.backgroundColor = [UIColor clearColor];
        self.imageButton.frame =  self.contentView.bounds;
        
        self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageButton.backgroundColor = [UIColor whiteColor];
        [self.imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imageButton];
    
        self.imageButton.layer.borderColor = [APPSaasF4Color CGColor];
        self.imageButton.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;

    [self.imageButton setImageForState:0 withURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];

}

- (void)imageButtonAction:(UIButton *)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

@end
@interface YJYInsureDisableView()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation YJYInsureDisableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setup];
    
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    CGFloat w = kScreenW - 65;
    CGFloat h = self.bounds.size.height;
    CGRect f = CGRectMake(0, 0, w, h);
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:f collectionViewLayout:[YJYInsureImagesLayout new]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[YJYInsureImageCell class] forCellWithReuseIdentifier:@"YJYInsureImageCell"];
    [self addSubview:self.collectionView];
    
    self.picArray = [NSMutableArray array];
    self.imageIds = [NSMutableArray array];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = kScreenW - 65;
    CGFloat h = self.bounds.size.height;
    CGRect f = CGRectMake(0, 0, w, h);
    self.collectionView.frame = f;
}
- (void)setInsureNo:(InsureNOModel *)insureNo {
    
    _insureNo = insureNo;
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        (insureNo.status == YJYInsureTypeStateFirstReview || insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
        self.isAdd = YES;

    }else {
        self.isAdd = NO;

    }
    [self.collectionView reloadData];

}

- (void)setPicURLIdArray:(NSMutableArray<picUrlId *> *)picURLIdArray {
    
    self.imageIds = [NSMutableArray array];
    self.picArray = [NSMutableArray array];
    
    _picURLIdArray = picURLIdArray;
    for (picUrlId *urlId in picURLIdArray) {
        [self.picArray addObject:urlId.picURL];
        [self.imageIds addObject:[NSString stringWithFormat:@"%@",@(urlId.picId)]];
    }
    
    [self.collectionView reloadData];

}

- (void)setPicArray:(NSMutableArray<NSString *> *)picArray {
    
    _picArray = picArray;
    [self.collectionView reloadData];
}

- (CGFloat)cellHeight {
    
    CGFloat basicH = 55;
    
    NSInteger picNumber = self.picArray.count + (self.isAdd && self.picArray.count < 9 ? 1: 0);
    NSInteger rows = picNumber / 3;
    CGFloat cellH = 110  - (IS_IPHONE_5 ? 35 : 0)  - (IS_IPHONE_6 ? 10 : 0) ;
    CGFloat H  = (rows + (picNumber % 3 == 0 ? 0 : 1)) * cellH + basicH;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, H);
    self.collectionView.frame = self.bounds;
    [self.collectionView.collectionViewLayout invalidateLayout];

    return H;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger picNumber = self.picArray.count + (self.isAdd && self.picArray.count < 9 ? 1: 0);
    if (picNumber > 9) {
        picNumber = 9;
    }
    return picNumber;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYInsureImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYInsureImageCell" forIndexPath:indexPath];
    if (self.isAdd && self.picArray.count < 9 && indexPath.row == [self.collectionView numberOfItemsInSection:0] - 1) {
        [cell.imageButton setImage:[UIImage imageNamed:@"insure_add_image"] forState:0];
    }else {
        cell.imageUrl = self.picArray[indexPath.row];
    }
    
    cell.didSelectBlock = ^{
        
        
        if (self.isAdd && self.picArray.count < 9 && indexPath.row == [self.collectionView numberOfItemsInSection:0] - 1) {

            if (self.didAddImageBlock) {
                self.didAddImageBlock();
            }
            
        }else {
            if (self.didSelectBlock) {
                self.didSelectBlock(self.picArray[indexPath.row],indexPath.row);
            }
        }
        
    };
    
    
    return cell;
}


@end
