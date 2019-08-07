
#import "SSPhotoPickerManager.h"
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <Photos/Photos.h>

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
    
    if (![self verifyAuth:sourceType]){
        
        return;
    };

    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // Will get here on both iOS 7 & 8 even though camera permissions weren't required
                // until iOS 8. So for iOS 7 permission will always be granted.
                if (granted) {
                    // Permission has been granted. Use dispatch_async for any UI updating
                    // code because this block may be executed in a thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentSourceType:sourceType OnViewController:viewController compled:compled cancel:cancel];
                        
                    });
                } else {
                    // Permission has been denied.
                }
            }];
        } else {
            // We are on iOS <= 6. Just do what we need to do.
            [self verifyAuth:sourceType];
        }
    }else {
    
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                [self presentSourceType:sourceType OnViewController:viewController compled:compled cancel:cancel];
                
                
            }else {
                
                [self verifyAuth:sourceType];
            }
        }];
    
    
    
    }
    
    
    
    
    
    
    
}

- (void)presentSourceType:(UIImagePickerControllerSourceType)sourceType OnViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled cancel:(DidCancelBlock)cancel {

    
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
    imagePickerController.editing = YES;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   [self dismissPickerViewController:picker];
  
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    
}

- (BOOL)verifyAuth:(UIImagePickerControllerSourceType)sourceType {

    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        //相册权限
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status ==AVAuthorizationStatusRestricted ||
            status ==AVAuthorizationStatusDenied){
            
            
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                
                [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请在设置 - 隐私，把相应程序的开关打开" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                }];
                
            }
            
            return NO;
            
        }
        
    }else {
        
        //权限
        
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        
        if (authStatus ==PHAuthorizationStatusRestricted ||
            authStatus ==PHAuthorizationStatusDenied)
        {
            
            
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                
                [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请在设置 - 隐私，把相应程序的开关打开" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
                        
                    }
                }];
                
            }
            
            return NO;
            
        }
    }
    
    
    
    return YES;


}

@end
