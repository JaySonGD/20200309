//
//  TableViewController.m
//  ffmpeg
//
//  Created by Jay on 25/6/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "TableViewController.h"
#import "FFM3u8Dowloader.h"
//#import "FFmpegManager.h"
#import <AVKit/AVKit.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = @"444";
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *kbsLB = cell.contentView.subviews.firstObject;
    UIProgressView *v = cell.contentView.subviews[1];
    
    NSArray *list = @[
                      @{
                          @"url":@"https://sp.new131.com/20190626/3qV67h32/index.m3u8",
                          @"name":@"王者无敌苏乞儿HD1280高清中字版.mp4"
                          },
                      @{
                          @"url":@"http://192.168.8.146/tx/1.m3u8",
                          @"name":@"2.mp4"
                          },  @{
                          @"url":@"http://vfile1.grtn.cn/2019/1561/3898/3837/156138983837.ssm/156138983837.m3u8",
                          @"name":@"3.mp4"
                          }
                      ];
    
    NSDictionary *obj = list[indexPath.row];
    if([FFM3u8Dowloader isDowloaded:obj[@"url"]]){
    
        
        
        //步骤2：创建AVPlayer
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:[FFM3u8Dowloader getCacheUrl:obj[@"url"]]];
        //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
        AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
        avPlayerVC.player = avPlayer;
        [self presentViewController:avPlayerVC animated:YES completion:nil];

        return;
    }

    
    [[FFM3u8Dowloader sharedManager] dowloadWithUrl:obj[@"url"] fileName:obj[@"name"] processBlock:^(float process, float kbs, long long size) {
        kbsLB.text = [NSString stringWithFormat:@"%0.2fKb/s",kbs];
        v.progress = process;
    } completionBlock:^(NSError * _Nonnull error) {

    }];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
