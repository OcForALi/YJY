//
//  YJYSearchNearController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/1.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYSearchNearController.h"
#import "YJYNearHospitalController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface YJYSearchNearController ()<CAAnimationDelegate>


@property (weak, nonatomic) IBOutlet UIView *loopsView;
@property (weak, nonatomic) IBOutlet UIImageView *greenLoopView;
@property (weak, nonatomic) IBOutlet UIImageView *yellowLoopView;
@property (weak, nonatomic) IBOutlet UIImageView *blueLoopView;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *nearestLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *searchingButton;

//data
@property (strong, nonatomic) AMapLocationManager *locationManager;
@property(nonatomic, strong) NSMutableArray<OrgDistanceModel*> *orgListArray;
@property (strong, nonatomic) OrgDistanceModel *nearestOrg;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) uint32_t adcode;

#define kAnimationDefaultTop 63
#define kAnimationStopTop 63
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationTopConstraint;

@end

@implementation YJYSearchNearController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYSearchNearController *)[UIStoryboard storyboardWithName:@"YJYNormal" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orgListArray = [NSMutableArray array];
    
    self.infoView.hidden = YES;
    
    self.animationTopConstraint.constant = kAnimationDefaultTop;

    [self startAnimation];
    
    self.locationManager =  [[AMapLocationManager alloc]init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
            {
                self.location = location;
                self.adcode = (uint32_t)[regeocode.adcode integerValue];
                
                
            }
             [self loadNetworkData];
        });
       
        
    }];
}

- (void)loadNetworkData {


    
    GetOrgListReq *req = [GetOrgListReq new];
    
    if (self.location) {
        req.lat = self.location.coordinate.latitude;
        req.lng = self.location.coordinate.longitude;
    }
    
     req.adcode = self.adcode;

    
    [YJYNetworkManager requestWithUrlString:APPGetOrgList message:req controller:self command:APP_COMMAND_AppgetOrgList success:^(id response) {
        
        GetOrgListRsp *rsp = [GetOrgListRsp parseFromData:response error:nil];
        self.orgListArray = rsp.orgListArray;
        self.nearestOrg = self.orgListArray.firstObject;
        
        [self reloadView];
       
        
       [self stopAnimation];
        
    } failure:^(NSError *error) {
        
        [self stopAnimation];
    }];
}


- (void)reloadView {

    self.nearestLabel.text = self.nearestOrg.orgVo.orgName;
    self.numberLabel.text = [NSString stringWithFormat:@"附近有%d家相关医院机构", (int)self.orgListArray.count];

}


#pragma mark - Action

- (IBAction)searchAction:(id)sender {
    
    [self startAnimation];
    [self loadNetworkData];

//    [self loadLocation];
}
- (IBAction)nearestClickAction:(id)sender {
    
    if (self.hospitalDidSelectBlock) {
        self.hospitalDidSelectBlock(self.nearestOrg);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)nearClickAction:(id)sender {
    
    YJYNearHospitalController *nears = [YJYNearHospitalController instanceWithStoryBoard];
    nears.orgListArray = [NSMutableArray arrayWithArray:self.orgListArray];
    nears.isSearch = YES;
    nears.nearHospitalDidSelectBlock = ^(OrgDistanceModel *org) {
        
        if (self.hospitalDidSelectBlock) {
            self.hospitalDidSelectBlock(org);
        }
        
    };
    
    [self.navigationController pushViewController:nears animated:YES];
    
}

#pragma mark - Animation

- (void)startAnimation {

    
    if (self.blueLoopView.layer.animationKeys.count) {
        [self resumeLayer:self.blueLoopView.layer];
        [self resumeLayer:self.yellowLoopView.layer];
        [self resumeLayer:self.greenLoopView.layer];

    }else {
    
        [self addAnimationWithView:self.blueLoopView];
        [self addAnimationWithView:self.yellowLoopView];
        [self addAnimationWithView:self.greenLoopView];
    }
   
   
    
    self.searchingButton.enabled = NO;
    

    [UIView animateWithDuration:0.3 animations:^{
        
//        self.animationTopConstraint.constant = kAnimationDefaultTop;
        self.infoView.hidden = YES;
//        [self.view layoutIfNeeded];

        
    }];
}

- (void)stopAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        self.searchingButton.enabled = YES;
        
        
        
        [UIView animateWithDuration:0.6 animations:^{
            
            
            
            self.infoView.hidden = NO;

            
        }completion:^(BOOL finished) {
            
            
            [self removeAnimationWithView:self.blueLoopView];
            [self removeAnimationWithView:self.yellowLoopView];
            [self removeAnimationWithView:self.greenLoopView];
        

            
        }];
    });
    
   
      
        
   
    
   
}


- (void)addAnimationWithView:(UIView *)view {
    
    
    [view.layer removeAllAnimations];
    
    [CATransaction begin];
    
    CAKeyframeAnimation* rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    if (view == self.yellowLoopView) {
     
        rotationAnimation.values = @[@0,@(-M_PI* 2.0)];

    }else {
        rotationAnimation.values = @[@0,@(M_PI* 2.0)];


    }
    rotationAnimation.duration = 1.5;
    rotationAnimation.repeatCount = NSIntegerMax;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [CATransaction commit];

}

- (void)removeAnimationWithView:(UIView *)view {

    
    [self pauseLayer:view.layer];
   

}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    
    
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}




@end
