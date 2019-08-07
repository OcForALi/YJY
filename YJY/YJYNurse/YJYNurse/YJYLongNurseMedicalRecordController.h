//
//  YJYLongNurseMedicalRecordController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/27.
//  No Comment © 2017年 samwuu. All rights reserved.
//




typedef void(^DidDoneBlock)(NSArray *medicalArray);


@interface YJYLongNurseMedicalRecordController : YJYViewController



@property(nonatomic, strong) InsureNOModel *insureModel;
@property (copy, nonatomic) DidDoneBlock didDoneBlock;
@property (assign, nonatomic) BOOL isEdit;
@end
