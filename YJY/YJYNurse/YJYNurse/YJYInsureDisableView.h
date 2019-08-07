//
//  YJYInsureDisableView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/11/10.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYInsureDisableViewDidAddImageBlock)();
typedef void(^YJYInsureDisableViewDidSelectBlock)(NSString *imgurl,NSInteger index);


//病例、诊断等图片
// 中重度智能障碍照片 如多张，以逗号隔开

typedef NS_ENUM(NSInteger, YJYInsureImagesType) {
    
    YJYInsureImagesTypeDisable,
    YJYInsureImagesTypeOther,
    YJYInsureImagesTypeNoInsure,

};



@interface YJYInsureDisableView : UIView

@property (strong, nonatomic) NSMutableArray<NSString*> *imageIds;
@property (strong, nonatomic) NSMutableArray<NSString*> *picArray;
@property (strong, nonatomic) NSMutableArray<picUrlId*> *picURLIdArray;
@property (assign, nonatomic) BOOL isAdd;

@property (strong, nonatomic) InsureNOModel *insureNo;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic)  YJYInsureImagesType imagesType;
@property (copy, nonatomic) YJYInsureDisableViewDidAddImageBlock didAddImageBlock;
@property (copy, nonatomic) YJYInsureDisableViewDidSelectBlock didSelectBlock;


- (CGFloat)cellHeight;

@end
