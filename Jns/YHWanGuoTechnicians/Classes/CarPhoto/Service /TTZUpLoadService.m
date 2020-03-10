//
//  TTZUpLoadService.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/14.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "TTZUpLoadService.h"
#import "YHBackgroundService.h"
#import "ApiService.h"
#import "NSObject+BGModel.h"
#import "YHPhotoManger.h"

#import "TTZDBModel.h"

#import <AFNetworking.h>

#import "UIAlertController+Blocks.h"

typedef void(^Complete)(void);

@interface TTZUpLoadService()
@property (nonatomic, strong) NSMutableArray<TTZDBModel *> *uploadTasks;
@end

@implementation TTZUpLoadService
DEFINE_SINGLETON_FOR_CLASS(TTZUpLoadService);


+ (void)load{
    
    TTZUpLoadService.sharedTTZUpLoadService.isAllowWWAN = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAllowWWAN"] boolValue];

    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
                //AFNetworkReachabilityStatusReachableViaWiFi
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                [[self sharedTTZUpLoadService] upLoad];
                break;
            }
                //AFNetworkReachabilityStatusReachableViaWWAN
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                //[[YHBackgroundService sharedYHBackgroundService] stop];
                if(TTZUpLoadService.sharedTTZUpLoadService.isAllowWWAN) [[self sharedTTZUpLoadService] upLoad];
                
                break;
            }
            default:
                break;
        }
        
        NSLog(@"网络状态数字返回：%@",@(status));
        NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
        NSLog(@"isReachable: %@",@([AFNetworkReachabilityManager sharedManager].isReachable));
        NSLog(@"isReachableViaWWAN: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN));
        NSLog(@"isReachableViaWiFi: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi));
        
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    
}

- (void)setIsAllowWWAN:(BOOL)isAllowWWAN{
    _isAllowWWAN = isAllowWWAN;
    [[NSUserDefaults standardUserDefaults] setObject:@(isAllowWWAN) forKey:@"isAllowWWAN"];
    if (_isAllowWWAN) {
        [self  upLoad];
    }
}

- (void)uploadOrder:(NSString *)billid
          didHandle:(void (^)(void))complete{
    
    NSArray <TTZDBModel *>*orders =  [TTZDBModel findWhere:[NSString stringWithFormat:@"where billId ='%@' and   isUpLoad = %d",billid,YES]];
    if (orders.count) {
        [self uploadDidHandle:complete];
        return;
    }
    
    !(complete)? : complete();
    [self upLoad];

}

- (void)uploadDidHandle:(void (^)(void))complete{
//- (void)uploadWithAlert{
    
    //if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN && self.isAllowWWAN) {
    if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN) {

        [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"非WIFI网络状态下提交，会使用手机流量上传" message:nil cancelButtonTitle:@"使用WiFi上传" destructiveButtonTitle:nil otherButtonTitles:@[@"使用手机流量"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            !(complete)? : complete();
            if (controller.cancelButtonIndex == buttonIndex) {
                self.isAllowWWAN = NO;
                return;
            }
            self.isAllowWWAN = YES;
            [self upLoad];
        }];
    }else{
        !(complete)? : complete();
        [self upLoad];
    }
}

- (void)upLoad{
    
    if(self.isUpLoad) return;
    
    NSArray <TTZDBModel *>*bds =  [TTZDBModel findWhere:[NSString stringWithFormat:@"where isUpLoad = %d",YES]];
    self.uploadTasks = bds.mutableCopy;
#if 0
    NSMutableArray *tems = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%li.png",(long)i];
        
        TTZDBModel *model = [TTZDBModel new];
        model.file = fileName;
        model.code = fileName;
        model.billId = fileName;
        model.image = [UIImage imageNamed:@"仪表盘1"];
        [tems addObject:model];
    }
    self.uploadTasks = tems;
#endif
    
    NSLog(@"%s---还有%lu个上传任务", __func__,(unsigned long)self.uploadTasks.count);
    //[self upLoadTask];
    [self upLoadAllTask];
    
}


//- (void)upLoadTask{
//
//    if(![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) return;
//    NSLog(@"%s --- Wifi环境", __func__);
//
//    TTZDBModel *model = self.uploadTasks.lastObject;
//    if (model) {
//        self.isUpLoad = YES;
//        [self upLoadForDB:model didComplete:^{
//
//            TTZDBModel *lmodel = self.uploadTasks.lastObject;
//            [self.uploadTasks removeObject: lmodel];
//            if (self.uploadTasks.count) {
//                [self upLoadTask];
//            }else{
//                self.isUpLoad = NO;
//                NSLog(@"%s---所有上传任务上传完毕", __func__);
//            }
//        }];
//        return;
//    }
//
//    NSLog(@"%s---没有上传任务", __func__);
//
//}


- (void)upLoadAllTask{
    
    if(![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi && !self.isAllowWWAN) return;
    NSLog(@"%s --- Wifi环境", __func__);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.uploadTasks.count) {
            
            __weak typeof(self) weakSelf = self;
            [self.uploadTasks enumerateObjectsUsingBlock:^(TTZDBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                weakSelf.isUpLoad = YES;
                [weakSelf upLoadForDB:obj didComplete:^{
                    //                    [weakSelf.uploadTasks removeObject:obj];
                    //                    weakSelf.isUpLoad = weakSelf.uploadTasks.count;
                    //                    if (!weakSelf.uploadTasks.count) {
                    //                        NSLog(@"%s---所有上传任务上传完毕", __func__);
                    //                    }
                    
                }];
                
            }];
            
            NSLog(@"%s---所有任务请求完毕", __func__);
            
        }else {
            NSLog(@"%s---没有上传任务", __func__);
        }
    });
    
}


- (void)upLoadForDB:(TTZDBModel *)db
        didComplete:(Complete)complete{
    
    __weak typeof(self) weakSelf = self;
#warning 测试用的
#if 0
    //NSString *serviceKey = @"smfile";
    //NSString *serviceURL = @"https://sm.ms/api/upload";
    NSString *serviceURL = @"http://192.168.1.59/upload_file1.php";
    NSString *serviceKey = @"file";
    //NSData *data = UIImagePNGRepresentation(db.image);//  手动构造的测试数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:[YHPhotoManger filePathOfSubDirectory:db.billId fileName:db.file]];
    
#else
    NSString *serviceKey = @"file";
    NSString *serviceURL = [ApiService sharedApiService].uploadBillImageURL;
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[YHPhotoManger filePathOfSubDirectory:db.billId fileName:db.file]];
    
#endif
    
    [[YHBackgroundService new] uploadFormData:data
                                          url:serviceURL
                                   parameters:@{@"code":db.code,@"billId":db.billId,@"infoType":@(db.type),@"timestamp":@(db.timestamp)}
                                         name:serviceKey
                                     fileName:db.file
                              currentProgress:^(CGFloat progress) {
                                  NSLog(@"文件%@---上传进度----%f",db.file,progress);
                                  
                              }
                                  didComplete:^(id obj, NSError *error) {
                                      NSLog(@"文件%@-上传---响应信息：%@----错误信息：%@", db.file,obj,error);
                                      
                                      // 删除文件和数据库记录
                                      
                                      [weakSelf.uploadTasks removeObject:db];
                                      weakSelf.isUpLoad = weakSelf.uploadTasks.count;
                                      
                                      if (![obj isKindOfClass:[NSDictionary class]]) return ;
                                      
                                      if ([obj[@"code"] integerValue] != 20000) {
                                          
                                          //只允许上传失败两次
                                          if (db.allowUploadCount < 1) {// 0 1
                                              db.allowUploadCount ++;
                                              [db saveOrUpdate];
                                              NSLog(@"上传失败：%@",db);

                                          }else{
                                              [YHPhotoManger deleteUpLoadedFile:db];
                                              !(_complete)? : _complete(db.fileId);
                                              NSLog(@"已经两次上传失败，该文件已被删除：%@",db);
                                          }
                                          
                                      }else{
                                          
                                          [YHPhotoManger deleteUpLoadedFile:db];
                                          !(_complete)? : _complete(db.fileId);
                                          
                                          NSLog(@"上传成功:%@",db.fileId);

                                      }
                                      
                                      if (!weakSelf.uploadTasks.count) {
                                          NSLog(@"%s---所有上传任务执行完毕", __func__);
                                          //刷新新加入的文件
                                          [weakSelf upLoad];
                                      }

                                      
                                      
                                  }];
    
}


@end
