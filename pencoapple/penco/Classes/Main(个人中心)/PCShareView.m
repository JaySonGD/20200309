//
//  PCShareView.m
//  penco
//
//  Created by Jay on 26/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCShareView.h"

#import "MBProgressHUD+MJ.h"
#import "RESideMenu.h"

#import <UMCommon/UMCommon.h>   // 公共组件是所有友盟产品的基础组件，必选
#import <UMShare/UMShare.h>     // 分享组件
#import <UShareUI/UShareUI.h>  //分享面板

@interface PCShareView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation PCShareView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 57*2;
    CGFloat h = w * self.image.size.height / self.image.size.width;
    
    self.imageHeight.constant = h;
    self.imageV.image = self.image;
    

}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)shareAction:(UIButton *)sender {

    
    if (sender.tag == UMSocialPlatformType_Sina) {
        [MBProgressHUD showError:@"暂不支持"];
        return;
    }
    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
//
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        [self shareWebPageToPlatformType:platformType
//                                describe:@"subtitle"
//                                  titles:@"this is title"
//                                imageUrl:self.image
//                                 address:@"http://xxx.com"];
//    }];
//}
//
//
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//                          describe:(NSString *)describe
//                            titles:(NSString *)titles
//                          imageUrl:(id )imageUrl
//                           address:(NSString *)address{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];//[UMShareWebpageObject shareObjectWithTitle:titles descr:describe thumImage:imageUrl];
    //
    //    shareObject.webpageUrl = address;
    shareObject.shareImage = self.image;
    //
    messageObject.shareObject = shareObject;
    
    //    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:imageUrl];
    
    
    //5.调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:sender.tag messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            //[MBProgressHUD showSuccess:@"分享失败" toView:self.view];
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [MBProgressHUD showError:error.userInfo[@"message"]];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                //[MBProgressHUD showSuccess:@"分享成功" toView:self.view];
                [MBProgressHUD showError:@"分享成功"];
                //UMSocialShareResponse *resp = data;
                
                //分享结果消息
                //UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self close:nil];
//    UINavigationController *ctl = ((RESideMenu*)self.presentingViewController).contentViewController;
//    [ ctl popToRootViewControllerAnimated:NO];
    //});

}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
