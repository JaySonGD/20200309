//
//  YHVideosController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/7/11.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHVideosController.h"
#import "YHNetworkPHPManager.h"

#import "YHTools.h"
//#import "MBProgressHUD+MJ.h"
#import "YHVideoCell.h"
#import "ALPlayerViewSDKViewController.h"
@interface YHVideosController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YHVideosController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self reupdataDatasource];
    self.tableView.estimatedRowHeight = 230;
}

- (IBAction)videoPalyActions:(id)sender {
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//- (void)reupdataDatasource{
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    __weak __typeof__(self) weakSelf = self;
//    
//    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
//     getVideoList:[YHTools getAccessToken]
//     projectId:@"227"
//     billId:@"3139"
//     onComplete:^(NSDictionary *info) {
//         [MBProgressHUD hideHUDForView:self.view];
//         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
//             NSDictionary *data = info[@"data"];
//             weakSelf.videos = data[@"showToolsData"];
//             [weakSelf.tableView reloadData];
//         }else {
//             if(![weakSelf networkServiceCenter:info[@"code"]]){
//                 YHLog(@"");
//             }
//         }
//     } onError:^(NSError *error) {
//         [MBProgressHUD hideHUDForView:self.view];
//     }];
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadDatasource:_videos[indexPath.row] indexL:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak __typeof__(self) weakSelf = self;
    
    NSDictionary *info = _videos[indexPath.row];
    NSString *vid = info[@"videoId"];
    vid = IsEmptyStr(vid)?  info[@"video_id"]:vid;

    [[YHNetworkPHPManager sharedYHNetworkPHPManager]
     getMediaPlayAuth:[YHTools getAccessToken]
     videoId:vid
     onComplete:^(NSDictionary *info) {
         [MBProgressHUD hideHUDForView:self.view];
         if (((NSNumber*)info[@"code"]).integerValue == 20000) {
             
             NSDictionary *data= info[@"data"];
             ALPlayerViewSDKViewController *controller = [[ALPlayerViewSDKViewController alloc]init];
             [controller setPlayauth:data[@"playAuth"]];
             [controller setVid:vid];
             [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
             
             [self presentViewController:controller animated:YES completion:^{
                 NSLog(@"ViewController presentViewController");
             }];
         }else{
             if(![weakSelf networkServiceCenter:info[@"code"]]){
                 YHLog(@"");
             }
         }
     } onError:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

@end
