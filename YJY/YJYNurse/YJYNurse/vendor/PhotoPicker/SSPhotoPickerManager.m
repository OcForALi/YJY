
#import "SSPhotoPickerManager.h"
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import<AVFoundation/AVCaptureDevice.h>

#define WEAKSELF __weak typeof(self) weakSelf = self

// block self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
@interface SSPhotoPickerManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) DidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;

@end

@implementation SSPhotoPickerManager
single_implementation(SSPhotoPickerManager) // 此处的单例宏定义不懂其含义，需要去了解
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled cancel:(DidCancelBlock)cancel{
    
    if (![self verifyAuth]) {
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return;
    }
    self.didCancelBlock = cancel;
    [viewController.view endEditing:YES];
    self.didFinishTakeMediaCompled = compled;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    
    //1.外貌
    UIBarButtonItem *item =
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
    // 设置文字颜色
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    //2.可编辑
    imagePickerController.delegate = self;
//    imagePickerController.editing = YES;
//    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    WEAKSELF;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishTakeMediaCompled = nil;

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(image, nil);
    }
    [self dismissPickerViewController:picker];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    if (self.didFinishTakeMediaCompled) {
//        self.didFinishTakeMediaCompled(nil, info);
//    }
//    [self dismissPickerViewController:picker];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    
}

- (BOOL)verifyAuth {

    
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        
        
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
      
            [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请开启相机权限" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication]openURL:url];
                    
                }
            }];
            
        }
        
        return NO;

        
       
       
    }
    
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
       
        
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请开启相机权限" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication]openURL:url];
                    
                }
            }];
            
        }
        
        return NO;

    }
    
    return YES;


}

@end
