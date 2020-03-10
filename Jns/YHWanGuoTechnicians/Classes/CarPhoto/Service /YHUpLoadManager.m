//
//  YHUpLoadManager.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHUpLoadManager.h"
#import "NSObject+BGModel.h"
#import "YHBackgroundService.h"
#import "ApiService.h"
#import "YHCarPhotoModel.h"

typedef void(^Complete)(void);

@interface YHUpLoadManager ()

@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *>*datas;

@end

@implementation YHUpLoadManager
DEFINE_SINGLETON_FOR_CLASS(YHUpLoadManager);



#pragma mark  -  上传所有任务
- (void)upload{
    
    NSMutableDictionary *uploadData = self.datas.lastObject;
    if (uploadData) {
        __weak typeof(self) weakSelf = self;
        [self uploadOfTask:uploadData didComplete:^{
            NSString *mid = uploadData[@"mid"];
            [YHPhotoDBModel deleteWhere:[NSString stringWithFormat:@"where mid='%@'",mid]];
            [weakSelf.datas removeLastObject];
            [self upload];
        }];
    }else{
        NSLog(@"%s --- 所有任务组搞忘", __func__);
    }
    

}
#pragma mark  -  上传一个任务
- (void)uploadOfTask:(NSDictionary *)task
         didComplete:(Complete)complete{
    
    dispatch_group_t group = dispatch_group_create();
    NSString *subDirectory = [task valueForKey:@"mid"];
    
    [task enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([key isEqualToString:@"car_other"]) {
            
            NSArray <NSString *>*others = (NSArray *)obj;
            [others enumerateObjectsUsingBlock:^(NSString * _Nonnull fileName, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //[self uploadOfFile:fileName fileKey:key dispatchGroup:group];
                [self uploadOfsubDirectory:subDirectory file:fileName fileKey:key dispatchGroup:group];
            }];
            
        }else if ([key isEqualToString:@"mid"]){
            
        }else{
            //[self uploadOfFile:obj fileKey:key dispatchGroup:group];
            [self uploadOfsubDirectory:subDirectory file:obj fileKey:key dispatchGroup:group];
        }
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSLog(@"%s --- 一个任务组搞忘", __func__);
        !(complete)? : complete();
    });

}
#pragma mark  -  上传一个文件
- (void)uploadOfsubDirectory:(NSString *)directory
                        file:(NSString *)name
                     fileKey:(NSString *)key
               dispatchGroup:(dispatch_group_t)group
                        {
    
    dispatch_group_enter(group);

    //key = @"smfile";
    //@"https://sm.ms/api/upload"//@"http://192.168.1.59/upload_file.php"
    NSData *data = UIImagePNGRepresentation([self imageWithContentsOfsubDirectory:directory fileName:name]);
    [[YHBackgroundService new] uploadFormData:data
                                          url:[ApiService sharedApiService].uploadBillImageURL
                                   parameters:@{}
                                         name:key
                                     fileName:@"122.png"
                              currentProgress:^(CGFloat progress) {
                                  NSLog(@"%@--%@--上传进度----%f",key,name,progress);
                                  
                              }
                                  didComplete:^(id obj, NSError *error) {
                                      NSLog(@"%@--%@--上传成功---%@----%@", key,name,obj,error);
                                      dispatch_group_leave(group);
                                  }];

}
#pragma mark  -  从磁盘加载图片
- (UIImage *)imageWithContentsOfsubDirectory:(NSString *)directory
                                    fileName:(NSString *)fileName{
    
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
                             stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:directory];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
    
    return [UIImage imageWithContentsOfFile:filePath];
}


- (NSMutableArray<NSMutableDictionary *> *)datas
{
    if (!_datas) {
        NSArray <YHPhotoDBModel *>*models = [YHPhotoDBModel findAll];
        _datas = [NSMutableArray array];
        
        for (YHPhotoDBModel *model  in models) {
            
            
            //if(!model.isDo)  continue;
            
            NSMutableDictionary *info  = [NSMutableDictionary dictionary];
            info[@"mid"] = model.mid;
            if (model.imagePath0.length) {
                info[@"car_surface_front"] = model.imagePath0;
            }
            if (model.imagePath1.length) {
                info[@"car_surface_back"] = model.imagePath1;
            }
            if (model.imagePath2.length) {
                info[@"car_surface_left"] = model.imagePath2;
            }
            if (model.imagePath3.length) {
                info[@"car_surface_right"] = model.imagePath3;
            }
            if (model.imagePath4.length) {
                info[@"car_engine_room"] = model.imagePath4;
            }
            if (model.imagePath5.length) {
                info[@"car_rear_box"] = model.imagePath5;
            }
            if (model.imagePath6.length) {
                info[@"car_interior_1"] = model.imagePath6;
            }
            if (model.imagePath7.length) {
                info[@"car_interior_2"] = model.imagePath7;
            }
            if (model.imagePath8.length) {
                info[@"car_interior_3"] = model.imagePath8;
            }
            if (model.imagePath9.length) {
                info[@"car_instrument_panel"] = model.imagePath9;
            }
            if (model.others.count) {
                info[@"car_other"] = model.others;
            }
            if (info.allKeys.count > 1) {
                [_datas addObject:info];
            }
        }

    }
    return _datas;
}

@end
