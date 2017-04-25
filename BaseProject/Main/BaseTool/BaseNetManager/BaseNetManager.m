//
//  BaseNetManager.m
//  BaseProject
//
//  Created by tyl on 2017/4/25.
//  Copyright © 2017年 tyl. All rights reserved.
//

#import "BaseNetManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

/*! 系统相册 */
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSMutableArray *tasks;


@implementation BaseNetManager
/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类BANetManager单例
 */
+ (BaseNetManager *)sharedBANetManager
{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedBANetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBANetManager = [[super allocWithZone:NULL] init];
    });
    return sharedBANetManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedBANetManager];
}

- (id)copy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedBANetManager];
}

+ (AFHTTPSessionManager *)sharedAFManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 30;
        
        /*! 打开状态栏的等待菊花 */
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        /*! 设置相应的缓存策略：此处选择不用加载也可以使用自动缓存【注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad】 */
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        /*! 设置返回数据类型为 json, 分别设置请求以及相应的序列化器 */
        /*!
         根据服务器的设定不同还可以设置：
         json：[AFJSONResponseSerializer serializer](常用)
         http：[AFHTTPResponseSerializer serializer]
         */
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        /*! 这里是去掉了键值对里空对象的键值 */
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        
        /* 设置请求服务器数类型式为 json */
        /*! 根据服务器的设定不同还可以设置 [AFJSONRequestSerializer serializer](常用) */
        AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
        manager.requestSerializer = request;
        
        /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
        //        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*! 设置响应数据的基本类型 */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        
        /*! https 参数配置 */
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
        //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //        securityPolicy.allowInvalidCertificates = YES;
        //        securityPolicy.validatesDomainName = NO;
        //        manager.securityPolicy = securityPolicy;
        
        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;
        
        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;
    });
    
    return manager;
}

+ (NSMutableArray *)tasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
+ (BAURLSessionTask *)ba_requestWithType:(BAHttpRequestType)type
                               urlString:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                            successBlock:(BAResponseSuccess)successBlock
                            failureBlock:(BAResponseFail)failureBlock
                                progress:(BADownloadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    
    BAWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"Get";
            break;
        case 1:
            requestType = @"Post";
            break;
        case 2:
            requestType = @"Put";
            break;
        case 3:
            requestType = @"Delete";
            break;
            
        default:
            break;
    }
    
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedAFManager].requestSerializer.HTTPRequestHeaders, requestType, URLString, parameters);
    NSLog(@"********************************************************");
    
    BAURLSessionTask *sessionTask = nil;
    
    if (type == BAHttpRequestTypeGet)
    {
        sessionTask = [[self sharedAFManager] GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /****************************************************/
            // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [URLString hash]];
            // 存储的沙盒路径
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 归档
            [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
            //        [self writeInfoWithDict:(NSDictionary *)responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
        
    }
    else if (type == BAHttpRequestTypePost)
    {
        sessionTask = [[self sharedAFManager] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* ************************************************** */
            // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [URLString hash]];
            // 存储的沙盒路径
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 归档
            [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
                NSLog(@"错误信息：%@",error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == BAHttpRequestTypePut)
    {
        sessionTask = [[self sharedAFManager] PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* ************************************************** */
            // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [URLString hash]];
            // 存储的沙盒路径
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 归档
            [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
            //        [self writeInfoWithDict:(NSDictionary *)responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    else if (type == BAHttpRequestTypeDelete)
    {
        sessionTask = [[self sharedAFManager] DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* ************************************************** */
            // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [URLString hash]];
            // 存储的沙盒路径
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 归档
            [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            [[weakSelf tasks] removeObject:sessionTask];
            
            //        [self writeInfoWithDict:(NSDictionary *)responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask)
    {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

/*!
 *  上传图片(多图)
 *
 *  @param parameters   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @param fileName     上传的图片数组fileName
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */
+ (BAURLSessionTask *)ba_uploadImageWithUrlString:(NSString *)urlString
                                       parameters:(NSDictionary *)parameters
                                       imageArray:(NSArray *)imageArray
                                         fileName:(NSString *)fileName
                                     successBlock:(BAResponseSuccess)successBlock
                                      failurBlock:(BAResponseFail)failureBlock
                                   upLoadProgress:(BAUploadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    
    BAWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedAFManager].requestSerializer.HTTPRequestHeaders, @"POST",URLString, parameters);
    NSLog(@"******************************************************");
    
    
    BAURLSessionTask *sessionTask = nil;
    sessionTask = [[self sharedAFManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*! 出于性能考虑,将上传图片进行压缩 */
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /*! image的压缩方法 */
            UIImage *resizedImage;
            /*! 此处是使用原生系统相册 */
            if([obj isKindOfClass:[ALAsset class]])
            {
                // 用ALAsset获取Asset URL  转化为image
                ALAssetRepresentation *assetRep = [obj defaultRepresentation];
                
                CGImageRef imgRef = [assetRep fullResolutionImage];
                resizedImage = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0
                                             orientation:(UIImageOrientation)assetRep.orientation];
                //                imageWithImage
                NSLog(@"1111-----size : %@",NSStringFromCGSize(resizedImage.size));
                
                resizedImage = [weakSelf imageWithImage:resizedImage scaledToSize:resizedImage.size];
                NSLog(@"2222-----size : %@",NSStringFromCGSize(resizedImage.size));
            }
            else
            {
                /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
            }
            
            /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
            NSData *imgData = UIImageJPEGRepresentation(resizedImage, 0.8);
            
            /*! 拼接data */
            if (imgData != nil)
            {   // 图片数据不为空才传递 fileName
                //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
                
                [formData appendPartWithFileData:imgData
                                            name:[NSString stringWithFormat:@"picflie%ld",(long)idx]
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
                
            }
            
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        if (progress)
        {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传图片成功 = %@",responseObject);
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock)
        {
            failureBlock(error);
        }
        [[weakSelf tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask)
    {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

/*!
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+ (void)ba_uploadVideoWithUrlString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                          videoPath:(NSString *)videoPath
                       successBlock:(BAResponseSuccess)successBlock
                       failureBlock:(BAResponseFail)failureBlock
                     uploadProgress:(BAUploadProgress)progress
{
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoPath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [[self sharedAFManager] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    if (progress)
                    {
                        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传视频成功 = %@",responseObject);
                    if (successBlock)
                    {
                        successBlock(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传视频失败 = %@", error);
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - ***** 文件下载
/*!
 *  文件下载
 *
 *  @param parameters   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */
+ (BAURLSessionTask *)ba_downLoadFileWithUrlString:(NSString *)urlString
                                        parameters:(NSDictionary *)parameters
                                          savaPath:(NSString *)savePath
                                      successBlock:(BAResponseSuccess)successBlock
                                      failureBlock:(BAResponseFail)failureBlock
                                  downLoadProgress:(BADownloadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"******************** 请求参数 ***************************");
    NSLog(@"请求头: %@\n请求方式: %@\n请求URL: %@\n请求param: %@\n\n",[self sharedAFManager].requestSerializer.HTTPRequestHeaders, @"download",urlString, parameters);
    NSLog(@"******************************************************");
    
    
    BAURLSessionTask *sessionTask = nil;
    
    sessionTask = [[self sharedAFManager] downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.2lld%%",100 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (progress)
            {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!savePath)
        {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        else
        {
            return [NSURL fileURLWithPath:savePath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self tasks] removeObject:sessionTask];
        
        NSLog(@"下载文件成功");
        if (error == nil)
        {
            if (successBlock)
            {
                /*! 返回完整路径 */
                successBlock([filePath path]);
            }
            else
            {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

#pragma mark - 网络状态监测
/*!
 *  开启网络监测
 */
+ (void)ba_startNetWorkMonitoringWithBlock:(BANetworkStatusBlock)networkStatus
{
    /*! 1.获得网络监控的管理者 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*! 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 2.设置网络状态改变后的处理 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*! 当网络状态改变了, 就会调用这个block */
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                networkStatus ? networkStatus(BANetworkStatusUnknown) : nil;
                BANetManagerShare.netWorkStatu = BANetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                networkStatus ? networkStatus(BANetworkStatusNotReachable) : nil;
                BANetManagerShare.netWorkStatu = BANetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                networkStatus ? networkStatus(BANetworkStatusReachableViaWWAN) : nil;
                BANetManagerShare.netWorkStatu = BANetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi 网络");
                networkStatus ? networkStatus(BANetworkStatusReachableViaWiFi) : nil;
                BANetManagerShare.netWorkStatu = BANetworkStatusUnknown;
                break;
        }
    }];
    [manager startMonitoring];
}

/*!
 *  是否有网
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)ba_isHaveNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

/*!
 *  是否是手机网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)ba_is3GOr4GNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

/*!
 *  是否是 WiFi 网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)ba_isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ba_cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ba_cancelRequestWithURL:(NSString *)URL
{
    if (!URL)
    {
        return;
    }
    @synchronized (self)
    {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL])
            {
                [task cancel];
                [[self tasks] removeObject:task];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - 压缩图片尺寸
/*! 对图片尺寸进行压缩 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if (newSize.height > 375/newSize.width*newSize.height)
    {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375)
    {
        newSize.width = 375;
    }
    
    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
    return newImage;
}

#pragma mark - url 中文格式化
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else
    {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}


@end
