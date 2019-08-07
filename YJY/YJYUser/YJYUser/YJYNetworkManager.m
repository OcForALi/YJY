//
//  YJYNetworkManager.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/21.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNetworkManager.h"
#import <zlib.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
#import "KeychainManager.h"


#define Kboundary  @"----anycharisok"
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

@interface YJYNetworkManager()


@property (strong, nonatomic) NSString *YUA;

@end

@implementation YJYNetworkManager

+ (void)requestWithUrlString:(NSString *)UrlString
                     message:(id)message
                  controller:(UIViewController *)controller
                     command:(APP_COMMAND)command
                     success:(Success)success
                     failure:(Failure)failure
               isHiddenError:(BOOL)isHiddenError {
    
    if ([YJYSettingManager sharedInstance].urlTypeStr.length > 0) {
        NSString *http = [YJYSettingManager sharedInstance].urlTypeStr;
        UrlString = [UrlString stringByReplacingOccurrencesOfString:@"http" withString:http];
    }
    

    AppRequest *pRequest = [AppRequest new];
    
    //item
    
    RequestItem *item = [RequestItem new];
    item.command = command;
    item.encrypt  = 1;
    item.binBody = [message data];
    [pRequest.reqsArray addObject:item];
    
    //head
    
    ReqHead *head = [ReqHead new];
    head.yua = [YJYNetworkManager GetYUA];
    if ([YJYLoginManager isLogin]) {
        head.sid = [YJYLoginManager getSID];
    }
    
    
    Terminal *terminal = [Terminal new];
    terminal.channelid = @"apple";
    terminal.mac = @"mac";//[UIDevice macaddress];
    terminal.imei = @"IODeviceIMEI";
    head.terminal = terminal;
    
    
    PkgInfo *pkg = [PkgInfo new];
    pkg.pkgName = @"YJY";
    pkg.signInfo = @"YJY_signInfo";
    head.pkginfo = pkg;
    
    
    pRequest.head = head;
    
    
    NSData *requestdata = [pRequest data];
    
    
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:UrlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestdata;
    request.timeoutInterval = 10;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
      
    
        @try
        {
            
            AppResponse *aResponse = [AppResponse new];
            [aResponse mergeFromData:data extensionRegistry:nil];
            
            AppError *appErr;
            if (aResponse.rspsArray.count) {
                appErr = [aResponse.rspsArray[0] err];
            }
            if (appErr.errorCode != APP_ERROR_CODE_AecSuccess) {
                
                NSError *failureError = [NSError errorWithDomain:NSCocoaErrorDomain code:appErr.errorCode userInfo:@{@"msg":appErr.msg}];
                
                if (!isHiddenError) {
                    [SYProgressHUD showFailureText:appErr.msg];

                }
                if (aResponse.errInfo.errorCode == APP_ERROR_CODE_AecUnlogin) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:[YJYLoginController instanceWithStoryBoard]];
                        [controller presentViewController:nav animated:YES completion:nil];
                        
                        if (failure) {
                            failure(failureError);
                        }
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (failure) {
                            failure(failureError);
                        }
                    });
                }
                
            }else {
                
                //save login sid & login mgrsid
                
                if (command == APP_COMMAND_Login && aResponse.head.sid && aResponse.head.sid.length > 0) {
                    [YJYLoginManager loginInAndSaveSID:aResponse.head.sid];
                }
      
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        success([aResponse.rspsArray[0] binBody]);
                    }
                });

                
            }
          
            
        }@catch (NSException * exception) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SYProgressHUD hideToLoadingView:controller.view];
                [SYProgressHUD showFailureText:@"网络异常"];
                
                if (failure) {
                    NSError *exceptionError = [[NSError alloc]initWithDomain:@"YJY" code:600 userInfo:nil];
                    failure(exceptionError);
                }
            });
        }
        @finally {
            // 8
           
        }
        
        
        
        
        
        
        
    }];
    
    [task resume];
    
   

    
}

+ (void)requestWithUrlString:(NSString *)UrlString
                     message:(id)message
                  controller:(UIViewController *)controller
                     command:(APP_COMMAND)command
                     success:(Success)success
                     failure:(Failure)failure{
    
    
    [self requestWithUrlString:UrlString message:message controller:controller command:command success:success failure:failure isHiddenError:NO];
    
    
}




+ (NSString*)GetYUA{
    
    
    NSString *YUA;
    
    NSString *deviceString = [self getMachine];
    
    NSString *appname = @"YJY";
    NSString* appversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* platform = @"iOS";
    NSString* versionname = @"beta";
    
    NSString* OSVersion = [UIDevice currentDevice].systemVersion;
    
    int rate = 2;
    if (DEVICE_WIDTH > 400) {
        rate = 3;
    }
    
    NSString* width = [NSString stringWithFormat:@"%d",(int)DEVICE_WIDTH*rate];
    NSString* height = [NSString stringWithFormat:@"%d",(int)DEVICE_HEIGHT*rate];
    int fontsize = (int)[UIFont systemFontSize];
    NSString* size = [NSString stringWithFormat:@"%@_%@_%d",width,height,fontsize];
    NSString* Channel = @"Channel";
//
    YUA = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@&%@",appname,appversion,build,versionname,platform,OSVersion,size,deviceString,Channel];
        
    return YUA;
}
+ (NSString*)getMachine{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    if( [machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"] ) machine = @"ios_Simulator";
    else if( [machine isEqualToString:@"iPhone1,1"] ) machine = @"iPhone_1G";
    else if( [machine isEqualToString:@"iPhone1,2"] ) machine = @"iPhone_3G";
    else if( [machine isEqualToString:@"iPhone2,1"] ) machine = @"iPhone_3GS";
    else if( [machine isEqualToString:@"iPhone3,1"] ) machine = @"iPhone_4";
    else if( [machine isEqualToString:@"iPod1,1"] ) machine = @"iPod_Touch_1G";
    else if( [machine isEqualToString:@"iPod2,1"] ) machine = @"iPod_Touch_2G";
    else if( [machine isEqualToString:@"iPod3,1"] ) machine = @"iPod_Touch_3G";
    else if( [machine isEqualToString:@"iPod4,1"] ) machine = @"iPod_Touch_4G";
    else if( [machine isEqualToString:@"iPad1,1"] ) machine = @"iPad_1";
    else if( [machine isEqualToString:@"iPad2,1"] ) machine = @"iPad_2";
    else if( [machine isEqualToString:@"iPhone4,1"] ) machine = @"iPhone_4s";
    else if( [machine isEqualToString:@"iPhone5,1"] ) machine = @"iPhone_5";
    else if( [machine isEqualToString:@"iPhone5,2"] ) machine = @"iPhone_5";
    else if( [machine isEqualToString:@"iPhone5,3"] ) machine = @"iPhone_5c";
    else if( [machine isEqualToString:@"iPhone5,4"] ) machine = @"iPhone_5c";
    else if( [machine isEqualToString:@"iPhone6,1"] ) machine = @"iPhone_5s";
    else if( [machine isEqualToString:@"iPhone6,2"] ) machine = @"iPhone_5s";
    else if( [machine isEqualToString:@"iPhone7,1"] ) machine = @"iPhone_6plus";
    else if( [machine isEqualToString:@"iPhone7,2"] ) machine = @"iPhone_6";
    return machine;
}

+ (UIImage *)cropImage:(UIImage *)image scale:(CGFloat)scale
{
    CGSize newSize = CGSizeMake(image.size.width*scale, image.size.height*scale);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)uploadImageToServerWithImage:(UIImage *)image
                                type:(NSString *)type
                             success:(Success)success
                             failure:(Failure)failure
                            compress:(CGFloat)compress {
    
    NSData * data =UIImageJPEGRepresentation(image,1);

    if (compress < 1) {
        UIImage *i = [self cropImage:image scale:compress];
        data =UIImageJPEGRepresentation(i,1);

    }
    
    
    NSString *uploadURL = [NSString stringWithFormat:@"%@?type=%@",UploadImage,type];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    //    json/application
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes= [NSSet setWithObjects:@"text/plain", nil];
    manager.responseSerializer = serializer;
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
            [SYProgressHUD showFailureText:@"上传图片失败，请重试"];
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(responseObject);
                }
                
                
            }
        }
    }];
    
    
    [uploadTask resume];
    
}

+ (void)uploadImageToServerWithImage:(UIImage *)image
                                type:(NSString *)type
                             success:(Success)success
                             failure:(Failure)failure{
    
   
    [self uploadImageToServerWithImage:image type:type success:success failure:failure compress:0.3];
    
    

}
#pragma mark - 多图上传

+ (void)CRPOSTUploadtWithRequestUrl:(NSString *)urlStr
                      withParameter:(NSDictionary *)parameter
                     withImageArray:(NSArray <UIImage *>*)imageArray
               WithReturnValueBlock:(SuccessBlock)successBlock
                     errorCodeBlock:(ErrorBlock)errorBlock {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",Kboundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
    NSData *data = [self getBodyDataWithParameter:parameter WithArray:imageArray];
    NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && response != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (!kDictIsEmpty(dict)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(dict);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
        }
    }];
    [uploadTask resume];
}
+ (NSData *)getBodyDataWithParameter:(NSDictionary *)parameter WithArray:(NSArray <UIImage *>*)imageArray {
    NSMutableData *myData = [NSMutableData data];
    NSMutableString *body=[[NSMutableString alloc]init];
    [body appendFormat:@"--%@\r\n",Kboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n",@"inputStr"];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    NSString *cargos = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    [body appendFormat:@"%@",cargos];
    [body appendFormat:@"\r\n"];
    [myData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < imageArray.count; i++) {
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        [imgbody appendFormat:@"--%@\r\n",Kboundary];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"%@.png\"\r\n",i,@"file"];
        [imgbody appendFormat:@"Content-Type: image/png; charset=utf-8\r\n\r\n"];
        [myData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSData data];
        data = UIImageJPEGRepresentation(imageArray[i], 1.0f);
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        NSData *dataBase64String = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:0];
        [myData appendData:dataBase64String];
        [myData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [myData appendData:[[NSString stringWithFormat:@"--%@--\r\n",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return [myData copy];
}
@end
