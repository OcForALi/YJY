//
//  YJYImageShowController.m
//  YJYUser
//
//  Created by wusonghe on 2017/9/16.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYImageShowController.h"
#import "UIImage+XHLaunchAd.h"

#define MRScreenWidth      [UIScreen mainScreen].bounds.size.width
#define MRScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface YJYImageShowController () <UIScrollViewDelegate>
{
    UIScrollView *_srcollView;
    UIImageView *_imageView;
}

@end

@implementation YJYImageShowController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"查看图片";
    
    _srcollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _srcollView.backgroundColor = [UIColor blackColor];
    _srcollView.delegate=self;
   
    [self.view addSubview:_srcollView];

    
    if (self.imgurl) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MRScreenWidth, 200)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_srcollView addSubview:_imageView];
        
        [_imageView xh_setImageWithURL:[NSURL URLWithString:self.imgurl] placeholderImage:nil options:XHLaunchAdImageDefault completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL) {
            
            if (image) {
                _srcollView.contentSize=image.size;
                _imageView.center = _srcollView.center; //CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenHeight * 2.5);
            }
          
            
        }];
       

    }else {
    
        _imageView = [[UIImageView alloc]initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.center = _srcollView.center; //CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenHeight * 2.5);
        [_srcollView addSubview:_imageView];
        _srcollView.contentSize=self.image.size;
       
        
    }
    
   
    
 
    [_srcollView setMinimumZoomScale:0.25f];
    [_srcollView setMaximumZoomScale:3.0f];
    
    
    //right
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(toMoreAction)];



    
    
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    NSLog(@"handleDoubleTap");
    float newScale = _srcollView.zoomScale * 1.5;//zoomScale这个值决定了contents当前扩展的比例
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [_srcollView zoomToRect:zoomRect animated:YES];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}



- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _srcollView.frame.size.height / scale;
    NSLog(@"zoomRect.size.height is %f",zoomRect.size.height);
    NSLog(@"self.frame.size.height is %f",_srcollView.frame.size.height);
    zoomRect.size.width  = _srcollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//当滑动结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [_srcollView setZoomScale:scale animated:NO];
}

#pragma mark - action

- (void)toMoreAction {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                _imageView.image = image;
                _srcollView.contentSize=image.size;

                if (self.didLoadedBlock) {
                    self.didLoadedBlock(image);
                }
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];
    
}

@end
