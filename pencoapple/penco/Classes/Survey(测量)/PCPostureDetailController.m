//
//  PCPostureController.m
//  penco
//
//  Created by Zhu Wensheng on 2019/7/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <WebKit/WebKit.h>
#import "PCPostureDetailController.h"
#import "YHNetworkManager.h"
#import "YHTools.h"
#import "YHCommon.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "PCPostureCell.h"
#import "PCMessageModel.h"
@interface PCPostureDetailController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pcV;
@property (strong, nonatomic) NSMutableArray *imgs;
@property (weak, nonatomic) IBOutlet UICollectionView *tableV;
@property (strong,nonatomic)NSNumber *hipLC;
@property (strong,nonatomic)NSNumber *hipV;
@property (strong,nonatomic)NSNumber *shoulderLC;
@property (strong,nonatomic)NSNumber *shoulderV;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet WKWebView *wkWeb;
@property (weak, nonatomic) IBOutlet UIImageView *tesim;

@property (strong, nonatomic)PCPostureModel *postureModel;
@end

@implementation PCPostureDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self posturesDetail];
    //[self loadImage:self.info];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)posturesDetail{
    
    NSString *personId = self.model.info.personId;//YHTools.personId;
    NSString *accountId = self.model.info.accountId;//YHTools.accountId;
    NSString *postureId = self.model.info.reportId;
    
    if (!personId || !accountId || !postureId) {
        
        return;
    }
#ifdef YHTest
    [MBProgressHUD showError:[NSString stringWithFormat:@"报告: %@", postureId]];
#endif
    [MBProgressHUD showMessage:nil toView:self.view];
    NSDictionary *parm = @{@"personId":personId,@"postureId":postureId,@"accountId":accountId};
    //@{@"personId":@"",@"postureId":@"",@"accountId":@""}
    WeakSelf
    [[YHNetworkManager sharedYHNetworkManager] getPostures:parm onComplete:^(PCPostureModel * _Nonnull model) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [weakSelf loadWeb:model.analysisReportUrl];
//        [weakSelf loadWeb:@"https://www.baidu.com/index.php?tn=monline_3_dg"];
//        [self loadImage:model];
//        weakSelf.postureModel = model;
//        [weakSelf.postureModel postureImg:^(UIImage * _Nonnull image) {
//            [weakSelf.tableV reloadData];
//           weakSelf.tesim.image = [weakSelf.postureModel.postureCards[1] regionImg];
//            [weakSelf.postureModel.postureCards[1] imgUrl];
//        }];
//        NSArray *dd = [weakSelf.postureModel postureCards];
    } onError:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.userInfo[@"message"]];
    }];
}

- (void)loadWeb:(NSString*)url{
    if (!url) {
        return;
    }
  UIWebView *webView = [[UIWebView alloc] init];
   
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}

-(void)loadAngle:(NSDictionary*)info{
    NSDictionary *resultData = [info objectForKey:@"resultData"];
    NSArray *frontLine = [resultData objectForKey:@"frontLine"];
    self.hipV = [resultData objectForKey:@"angleHip"];
    self.shoulderV = [resultData objectForKey:@"angleShoulder"];
    
    if (frontLine == nil) {
        frontLine = [resultData objectForKey:@"sideLine"];
    }
    NSDictionary *keypoints = [YHTools dictionaryWithJsonString:[resultData objectForKey:@"keypoints"]];
    //特殊点 右肩5 右胯11
    
    NSArray *p = keypoints[@"5"];
    
    self.shoulderLC = p[1];
    
    
    p = keypoints[@"11"];
    
    self.hipLC = p[1];
}

- (void)loadImage:(PCPostureModel*)info{
    self.imgs = [@[[NSNull null], [NSNull null]]mutableCopy];
    
    self.timeL.text = [info.measureTime substringToIndex:16];
    WeakSelf
    NSDictionary *analysisResult = info.analysisResult;
    NSString *positivePhotoUrl = info.positivePhotoUrl;
    NSString *sidePhotoUrl = info.sidePhotoUrl;
    
    NSDictionary *image1 = [analysisResult objectForKey:@"front"];
    NSDictionary *image2 = [analysisResult objectForKey:@"side"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:positivePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image1 == nil) {
                return ;
            }
            [weakSelf.imgs replaceObjectAtIndex:0 withObject:[weakSelf load:image1 image:image dottedLine:YES]];
            [weakSelf loadAngle:image1];
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [weakSelf.tableV reloadData];
            });        }
    }];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:sidePhotoUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            if (image == nil || image2 == nil) {
                return ;
            }
            [weakSelf.imgs replaceObjectAtIndex:1 withObject:[weakSelf load:image2 image:image dottedLine:NO]];
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [weakSelf.tableV reloadData];
            });
        }
    }];
}


- (UIImage*)load:(NSDictionary*)info image:(UIImage*)image dottedLine:(BOOL)dottedLine{
    if (!info) {
        return [NSNull null];
    }
    NSDictionary *resultData = [info objectForKey:@"resultData"];
    NSArray *frontLine = [resultData objectForKey:@"frontLine"];
    if (frontLine == nil) {
        frontLine = [resultData objectForKey:@"sideLine"];
    }
    NSArray *limb;
    NSMutableArray *lines = [@[] mutableCopy];
    NSMutableArray *points = [@[] mutableCopy];
    if (dottedLine) {
//        右肩5 左肩 2 左胯8 右胯11 左膝 9 右膝 12 左踝 10 右踝 13
        limb = @[@[info[@"shoulder"][@"left"], info[@"shoulder"][@"right"]], @[info[@"hip"][@"left"], info[@"hip"][@"right"]], @[info[@"hip"][@"left"], info[@"knee"][@"left"]], @[info[@"hip"][@"right"], info[@"knee"][@"right"]], @[info[@"knee"][@"left"], info[@"ankle"][@"left"]], @[info[@"knee"][@"right"], info[@"ankle"][@"right"]]];
    }else{
        limb = @[@[info[@"ear"][@"right"], info[@"shoulder"][@"right"]], @[info[@"hip"][@"right"], info[@"knee"][@"right"]], @[info[@"knee"][@"right"], info[@"ankle"][@"right"]]];
    }
    for (NSArray *p in limb) {
        [lines addObject:@{@"color" : @(0X4CD0FF),
                           @"weight" : @4,
                           @"points" : p
                           }];
        [points addObjectsFromArray:p];//绘制的关键点
    }
    if (frontLine) {
        [lines addObject: @{@"color" : @(0X4CD0FF),
                            @"weight" : @1,
                            @"points" : frontLine
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



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postureModel.imgs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PCPostureCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadImg:self.postureModel.imgs[indexPath.row] index:indexPath.row hip:_hipLC.floatValue hipV:_hipV.floatValue shoulder:_shoulderLC.floatValue shoulderV:_shoulderV.floatValue];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}


- (void)popViewController:(id)sender{
    if (self.isNews) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [super popViewController:sender];
}
@end
