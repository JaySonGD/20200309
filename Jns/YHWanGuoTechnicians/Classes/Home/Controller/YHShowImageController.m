

//
//  YHShowImageController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2018/12/6.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "YHShowImageController.h"
#import "SVProgressHUD.h"

#import "YHCarPhotoService.h"
#import "WXPay.h"
#import "YHWebFuncViewController.h"

@interface YHShowImageController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *confireBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHLC;
@property (weak, nonatomic) IBOutlet UIImageView *letterIV;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation YHShowImageController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    WeakSelf
    //YHLayerBorder(self.confireBtn, [UIColor whiteColor], 1);
    //YHViewRadius(self.confireBtn, 8);
    
    if(self.isHome){
        
        if(!self.needBuy){
            [self.confireBtn setTitle:@"升级权限" forState:UIControlStateNormal];
        }
        
    }else{
        
        self.confireBtn.hidden = !self.needBuy;
        
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.confireBtn.hidden ? 0 : 62, 0);
    
    self.desLB.hidden = YES;
    [self.closeBtn setImage:[UIImage imageNamed:@"imageClose"] forState:UIControlStateNormal];
    [SVProgressHUD showWithStatus:@"加载中..."];
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"宽：%f, 高：%f", image.size.width, image.size.height);
        [SVProgressHUD dismiss];
        
        if (!image) {
            return ;
        }
        CGFloat h = screenWidth * image.size.height/image.size.width;
        weakSelf.hLC.constant = h + (self.needBuy? 62:0);
        weakSelf.imageHLC.constant =  h;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)payAction:(UIButton *)sender {
    
    if([self.confireBtn.currentTitle isEqualToString:@"升级权限"]){//跳转到联系我们
        YHWebFuncViewController *controller = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"YHWebFuncViewController"];
        
        controller.urlStr= [NSString stringWithFormat:@"%@/index.html?token=%@&status=ios#/personal/contactMe",SERVER_PHP_URL_Statements_H5_Vue,[YHTools getAccessToken]];
        controller.barHidden = YES;
         [self dismissViewControllerAnimated:NO completion:nil];
        UINavigationController *nav = (UINavigationController *)self.presentingViewController;
        if(!nav || ![nav isKindOfClass:[UINavigationController class]]){
            nav = self.navigationController;
        }
        [nav pushViewController:controller animated:YES];
        return;
    }
    
    if (!sender.selected) {
        
        [self.closeBtn setImage:[UIImage imageNamed:@"dialog_close_notice2"] forState:UIControlStateNormal];
        self.letterIV.hidden = NO;
        self.desLB.hidden = NO;
        sender.selected = YES;
        
        UIImage *image = [UIImage imageNamed:@"表格"];
        [self.imageView sd_setImageWithURL:nil placeholderImage:image];
        
        CGFloat h = screenWidth * image.size.height/image.size.width;
        
        self.hLC.constant = h + self.letterIV.height;
        self.imageHLC.constant = h;

        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] orgFunctionOrderPaySuccess:^(NSDictionary *info) {
        if (info) {
            [[WXPay sharedWXPay] payByParameter:info success:^{
                
                [[YHCarPhotoService new] orgFunctionOrderPaySuccess:^(NSDictionary *info) {
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:@"支付成功！"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
                    [self closeAction:nil];
                    [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];

                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:@"支付失败！"];
                }];
                
            } failure:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"支付失败！"];
            }];
            return ;
        }
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"不需要购买！"];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
//        [self closeAction:nil];
//        [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];

    }];
}

- (IBAction)closeAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
