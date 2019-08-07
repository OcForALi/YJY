//
//  YJYInsureQuestionController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"

typedef void(^InsureQuestionDidScoreDoneBlock)(id responseData);
@interface YJYInsureQuestionController : YJYWebController
@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) NSString *idCardNO;
@property (copy, nonatomic) InsureQuestionDidScoreDoneBlock didScoreDone;
@property (assign, nonatomic) BOOL isFromDetail;

@end
