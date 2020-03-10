//
//  PCPostureModel.m
//  penco
//
//  Created by Jay on 26/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <MJExtension.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import "PCPostureModel.h"
#import "YHCommon.h"
#import "YHTools.h"

@implementation PCPostureRisks
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"risks" : [PCPostureCard class]};
}
@end

@interface PCPostureModel ()
@property (nonatomic, copy) PostureImgHandler completionHandler;

@property (strong, nonatomic) UIImage *originalFrontimg;//体态原始正面图片
@property (strong, nonatomic) UIImage *originalSideimg;//体态原始侧面图片

@property (nonatomic, strong)PCPostureRisks *frontRs;
@property (nonatomic, strong)PCPostureRisks *sideRs;
@end

@implementation PCPostureModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"postureId":@[@"postureId",@"postureRecordId"]};
}

- (void)setMeasureTime:(NSString *)measureTime{
    _measureTime = [measureTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

-(NSMutableArray<PCPostureCard *> *)order:(NSMutableArray<PCPostureCard *> *)postures{

    //构建排序描述器
    NSSortDescriptor *levelDesc = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:YES comparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSDictionary *keys = @{@"normal" : @"c", @"mild" : @"b", @"severe" : @"a"};
       return [keys[obj1] compare:keys[obj2]];
    }];
    NSSortDescriptor *leyDesc = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES comparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
           NSDictionary *keys = @{
           @"lateralhead" : @"a",
           @"forwardhead" : @"b",
           @"unevenshoulder" : @"c",
           @"roundedshoulder" : @"d",
           @"scoliosis" : @"e",
           @"unevenhip" : @"f",
           @"oleg" : @"g",
           @"xleg" : @"h",
           @"xoleg" : @"i",
           @"kneehyperextension" : @"j",
           };
          return [keys[obj1] compare:keys[obj2]];
       }];
    NSArray *descriptorArray = [NSArray arrayWithObjects:levelDesc, leyDesc, nil];
    NSArray *sortedArray = [postures sortedArrayUsingDescriptors: descriptorArray];
    
    return [sortedArray mutableCopy];
}
/*
 1.体态结论；2.头部前倾；3.头部侧倾；4.XO腿型; 5.高低肩；6.骨盆前倾；7.脊柱异位；8.O型腿；9.圆肩；10.膝过伸
 */
- (NSMutableArray<PCPostureCard *> *)postureCards{
    if (!_postureCards) {
        _postureCards = [@[]mutableCopy];
        if (self.postureId) {

            
            NSDictionary *body = [self.analysisReport objectForKey:@"body"];
            NSDictionary *side = [body objectForKey:@"side"];
            NSString *sideDirection = [side objectForKey:@"side"];
            
            PCPostureRisks *frontRs = [PCPostureRisks mj_objectWithKeyValues:self.analysisReport[@"body"][@"front"]];
            PCPostureRisks *sideRs = [PCPostureRisks mj_objectWithKeyValues:self.analysisReport[@"body"][@"side"]];
            self.frontRs = frontRs;
            self.sideRs = sideRs;
            //        [frontRs.risks addObjectsFromArray:sideRs.risks];
            //        _postureCards =  [frontRs.risks mutableCopy];
            [_postureCards addObjectsFromArray:self.frontRs.risks];
            [_postureCards addObjectsFromArray:self.sideRs.risks];
            
            PCPostureCard *item = [PCPostureCard new];
            item.value = self.analysisReport[@"general"][@"score"];
            item.name = @"体态结论";
            item.postreUrl = self.analysisReportUrlList[@"postureConclusion"];
            [_postureCards insertObject:item atIndex:0];
            [self.frontRs.risks enumerateObjectsUsingBlock:^(PCPostureCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.img = self.originalFrontimg;
                obj.point = self.analysisReport[@"body"][@"front"][@"points"];
            }];
            [self.sideRs.risks enumerateObjectsUsingBlock:^(PCPostureCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.img = self.originalSideimg;
                obj.point = self.analysisReport[@"body"][@"side"][@"points"];
                obj.side = sideDirection;
            }];
            [_postureCards enumerateObjectsUsingBlock:^(PCPostureCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.postureDetailsPage = self.analysisReportUrlList[@"postureDetailsPage"];
            }];
            _postureCards = [self order:_postureCards];
        }else{
            PCPostureCard *item = [PCPostureCard new];
            [_postureCards addObject:item];

            item = [PCPostureCard new];
            item.name = @"头部前倾";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"头部侧倾";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"高低肩";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"圆肩";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"脊柱异位";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"骨盆侧倾";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"O型腿";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"X型腿";
            [_postureCards addObject:item];
            
            item = [PCPostureCard new];
            item.name = @"膝过伸";
            [_postureCards addObject:item];
            
            return nil;
        }
    }
    return _postureCards;
}

-(void)postureImg:(PostureImgHandler)hander{
    self.completionHandler = hander;
    [self loadImage:self];
//    [self performSelector:@selector(loadImage:) withObject:self afterDelay:6];
}

- (void)loadImage:(PCPostureModel*)info{
    self.imgs = [@[[NSNull null], [NSNull null]]mutableCopy];
    
    WeakSelf
    NSDictionary *analysisResult = info.analysisResult;
    NSString *positivePhotoUrl = info.positivePhotoUrl;
    NSString *sidePhotoUrl = info.sidePhotoUrl;
    
    
    NSDictionary *analysisReport = info.analysisReport;
    
    NSDictionary *body = [analysisReport objectForKey:@"body"];
    NSDictionary *side = [body objectForKey:@"side"];
    NSString *direction = [side objectForKey:@"side"];
    
    NSDictionary *image1 = [analysisResult objectForKey:@"front"];
    NSDictionary *image2 = [analysisResult objectForKey:@"side"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:positivePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image1 == nil) {
                return ;
            }
            weakSelf.originalFrontimg = image;
            [weakSelf.imgs replaceObjectAtIndex:0 withObject:[weakSelf load:image1 image:image dottedLine:YES direction:direction]];
            //            [weakSelf loadAngle:image1];
            [weakSelf.frontRs.risks enumerateObjectsUsingBlock:^(PCPostureCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.img = image;
            }];
            
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (weakSelf.completionHandler) {
                    weakSelf.completionHandler(weakSelf.imgs[0]);
                }
            });        }
    }];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:sidePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image2 == nil) {
                return ;
            }
            weakSelf.originalSideimg = image;
            [weakSelf.imgs replaceObjectAtIndex:1 withObject:[weakSelf load:image2 image:image dottedLine:NO direction:direction]];
            [weakSelf.sideRs.risks enumerateObjectsUsingBlock:^(PCPostureCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.img = image;
            }];
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (weakSelf.completionHandler) {
                    weakSelf.completionHandler(weakSelf.imgs[0]);
                }
            });
        }
    }];
}


- (UIImage*)load:(NSDictionary*)info image:(UIImage*)image dottedLine:(BOOL)dottedLine direction:(NSString*)direction{
    if (!info) {
        return [NSNull null];
    }
    NSArray *limb;
    NSMutableArray *lines = [@[] mutableCopy];
    NSMutableArray *points = [@[] mutableCopy];
    if (dottedLine) {
        //        右肩5 左肩 2 左胯8 右胯11 左膝 9 右膝 12 左踝 10 右踝 13
        limb = @[@[info[@"shoulder"][@"left"], info[@"shoulder"][@"right"]], @[info[@"hip"][@"left"], info[@"hip"][@"right"]], @[info[@"hip"][@"left"], info[@"knee"][@"left"]], @[info[@"hip"][@"right"], info[@"knee"][@"right"]], @[info[@"knee"][@"left"], info[@"ankle"][@"left"]], @[info[@"knee"][@"right"], info[@"ankle"][@"right"]]];
    }else{
        limb = @[@[info[@"ear"][direction], info[@"shoulder"][direction]], @[info[@"hip"][direction], info[@"knee"][direction]], @[info[@"knee"][direction], info[@"ankle"][direction]]];
    }
    for (NSArray *p in limb) {
        [lines addObject:@{@"color" : @(0X4CD0FF),
                           @"weight" : @4,
                           @"points" : p
                           }];
        [points addObjectsFromArray:p];//绘制的关键点
    }
    if (dottedLine) {
        [lines addObject: @{@"color" : @(0X4CD0FF),
                            @"weight" : @1,
                            @"points" : @[@{@"x" : info[@"nose"][@"x"],
                                            @"y" : @"0"},
                                          @{@"x" : info[@"nose"][@"x"],
                                            @"y" :  [NSString stringWithFormat:@"%f", image.size.height]}
                            ]
                            }];
    }else{
        [lines addObject: @{@"color" : @(0X4CD0FF),
                                   @"weight" : @1,
                                   @"points" : @[@{@"x" : info[@"ear"][direction][@"x"],
                                                   @"y" : @"0"},
                                                 @{@"x" : info[@"ear"][direction][@"x"],
                                                   @"y" :  [NSString stringWithFormat:@"%f", image.size.height]}
                                   ]
                                   }];
    }
    
    
    if (dottedLine) {
        NSInteger dottedContent = 10;//虚线空白间隔
        NSInteger dottedContentW = 10;//虚线颜色间隔
        NSInteger dottedContentCount = 8;//虚线段数
        //特殊点 右肩5 右胯11
        for (NSDictionary *p in @[info[@"shoulder"][@"left"], info[@"hip"][@"left"]]) {
            //            NSArray *p = keypoints[key];
            //加须线
            for (NSInteger i = 0; i < dottedContentCount; i++) {//虚线分割成多段线
                NSNumber *xN = p[@"x"];
                NSNumber *yN = p[@"y"];
                //线起始点
                NSInteger xS = xN.integerValue + (dottedContentW * i) + (dottedContent * i);//
                NSInteger yS = yN.integerValue;
                
                //结束点
                NSInteger xE = xN.integerValue + (dottedContentW * (i + 1)) + (dottedContent * i);
                NSInteger yE = yN.integerValue;
                
                NSDictionary *startLine = @{@"x" : @(xS), @"y" : @(yS)};//@[@(xS), @(yS)];
                NSDictionary *endLine = @{@"x" : @(xE), @"y" : @(yE)};
                
                [lines addObject:@{@"color" : @(0X4CD0FF),
                                   @"weight" : @4,
                                   @"points" : @[startLine, endLine]
                                   }];
            }
        }
        
        //t特殊点 左肩 2 左胯8
        for (NSDictionary *p in @[info[@"shoulder"][@"right"], info[@"hip"][@"right"]]) {
            //            NSArray *p = keypoints[key];
            //加须线
            for (NSInteger i = 0; i < dottedContentCount; i++) {//虚线分割成多段线
                NSNumber *xN = p[@"x"];
                NSNumber *yN = p[@"y"];
                //线起始点
                NSInteger xS = xN.integerValue - (dottedContentW * i) - (dottedContent * i);//
                NSInteger yS = yN.integerValue;
                
                //结束点
                NSInteger xE = xN.integerValue - (dottedContentW * (i + 1)) - (dottedContent * i);
                NSInteger yE = yN.integerValue;
                
                //                NSArray *startLine = @[@(xS), @(yS)];
                //                NSArray *endLine = @[@(xE), @(yE)];
                NSDictionary *startLine = @{@"x" : @(xS), @"y" : @(yS)};//@[@(xS), @(yS)];
                NSDictionary *endLine = @{@"x" : @(xE), @"y" : @(yE)};
                
                [lines addObject:@{@"color" : @(0X4CD0FF),
                                   @"weight" : @4,
                                   @"points" : @[startLine, endLine]
                                   }];
            }
        }
    }
    return [YHTools image:image withInfo:@{@"lines" : lines,
                                           @"points" : points
                                           }];
}

@end

