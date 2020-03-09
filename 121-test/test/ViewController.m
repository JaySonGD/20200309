//
//  ViewController.m
//  test
//
//  Created by Jay on 20/3/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "include/Api.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [Api registerAppKey:@"mcdfdgq4363731453637"];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%s------------------------------------------------------------------------------------------------", __func__);
        [self touchesBegan:nil withEvent:nil];
    }];
    

//    [self up:@[]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    for (NSInteger i = 0 ; i < 1; i ++) {
        
    
    NSInteger t = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *url = [NSString stringWithFormat:@"https://haokan.baidu.com/videoui/list/tab?source=wise-channel&pd=&subTab=dongman&direction=down&refreshType=1&ua=Mozilla%%252F5.0%%2520(iPhone%%253B%%2520CPU%%2520iPhone%%2520OS%%252011_0%%2520like%%2520Mac%%2520OS%%2520X)%%2520AppleWebKit%%252F604.1.38%%2520(KHTML%%252C%%2520like%%2520Gecko)%%2520Version%%252F11.0%%2520Mobile%%252F15A372%%2520Safari%%252F604.1&bt=1553398538&cal33ler=bdwise&_=%@&c333b=jsonp3",@(t)];
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"errno"] integerValue] == 0) {
            NSArray *list = [responseObject valueForKey:@"data"][@"list"];
            NSMutableArray *data = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [data addObject:@{
                                  @"recName" : @"动漫",
                                  @"vid" : v[@"vid"],
                                  @"title" : v[@"title"],
                                  @"url" : [v[@"videoSrc"] componentsSeparatedByString:@"?"].firstObject,
                                  @"thumb" : v[@"thumbnail"],
                                  @"duration" : v[@"duration"],
                                  @"playCnt" : v[@"playcnt"],
                                  @"authorIcon" : v[@"authorIcon"],
                                  @"author" : v[@"author"],
                                  @"authorId" : v[@"authorid"],
                                  @"recType" : v[@"recType"],
                                  @"degradeNum" : v[@"degradeNum"],
                                  @"praiseNum" : v[@"praiseNum"]

                                  }];
            }];
            [self up:data];
//            NSLog(@"%s--%@", __func__,data);

        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
        
//        sleep(1.0);
    }

    return;
    

//    [[Api shareApi] getRequest:@"http://127.0.0.1/app/public/api/send" parameters:nil success:^(id respones) {
//        NSLog(@"%s", __func__);
//    } failure:^(NSError *error) {
//        NSLog(@"%s", __func__);
//    }];
}


- (void)up:(NSArray *)list{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    //session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    
    //post 发送json格式数据的时候加上这两句
    // >>>>>>>>
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //session.responseSerializer = [AFJSONResponseSerializer serializer];
    // <<<<<<<<
    
    
    [session POST:@"http://127.0.0.1/html/public/index/api/test8?debug=99&json" parameters:@{@"debug":@"99",@"json":@"",@"list":list} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%s--%@", __func__,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s", __func__);
    }];
//}
//    [session POST:@"http://127.0.0.1/html/public/index/api/test8?debug=9900&json" parameters:@{@"list":@[@{@"cz":@"cz",@"age":@(34)},@{@"cz":@"cz",@"age":@(34)}]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%s--%@", __func__,responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%s", __func__);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
