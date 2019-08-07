//
//  YJYOrderCreateController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

@interface YJYOrderCreateController : YJYViewController


@property (assign, nonatomic) YJYOrderCreateType createType;
@property(nonatomic, readwrite) InsureNOModel *insureModel;
@property(nonatomic, readwrite) NSString *contactPhone;

@end
