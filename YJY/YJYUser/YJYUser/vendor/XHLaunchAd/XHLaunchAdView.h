//
//  XHLaunchAdView.h
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 16/12/3.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface XHLaunchAdView : UIImageView

@property(nonatomic,copy) void(^adClick)();

@end

#pragma mark - imageAdView
@interface XHLaunchImageAdView : XHLaunchAdView

@end

#pragma mark - videoAdView
@interface XHLaunchVideoAdView : XHLaunchAdView


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
@property (strong, nonatomic) MPMoviePlayerController *adVideoPlayer;
@property(nonatomic,assign)MPMovieScalingMode adVideoScalingMode;

#pragma clang diagnostic pop


@end
