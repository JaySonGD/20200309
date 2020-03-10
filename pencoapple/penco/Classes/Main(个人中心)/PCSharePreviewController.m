//
//  PCSharePreviewController.m
//  penco
//
//  Created by Jay on 25/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCSharePreviewController.h"
#import "PCShareController.h"
#import "PCShareView.h"
#import "UIView+add.h"
#import "UIView+add.h"

#import "YHCommon.h"

#import "PCPreviewCell.h"

#import "YHModelItem.h"

#import "YHTools.h"
#import "MBProgressHUD+MJ.h"

#import <Photos/Photos.h>

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
@interface PCSharePreviewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *guideView;

@property (nonatomic, strong) NSArray <YHCellItem *>*models;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) UIImageView *bgIV;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewW;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewH;

@end

@implementation PCSharePreviewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.superview.frame = CGRectMake(15, 15, self.view.bounds.size.width-30,  self.view.bounds.size.height);
    
    self.tableView.superview.backgroundColor = [UIColor whiteColor];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width-30;
    CGFloat h = 0;//w * self.shareImage.size.height / self.shareImage.size.width;
    
    self.headerView.superview.bounds = CGRectMake(0, 0, w, h+170);
    
    NSString *createTime = (self.tableModels.firstObject.reportTime.length > 16)? ([self.tableModels.firstObject.reportTime substringToIndex:16]) : self.tableModels.firstObject.reportTime;
    UILabel *createTimeLB = (UILabel *)self.headerView.superview.subviews.lastObject;
    
    createTimeLB.text = [NSString stringWithFormat:@"%@",createTime?createTime:@""];

    
    self.headerView.image = self.shareImage;
    self.qrCodeView.image = [YHTools createQRCode];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    [self.navigationController.navigationBar setTintColor:YHColor0X(0x605858, 1.0)];//设置自己想要的颜色
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    [self.navigationController.navigationBar setTintColor:YHColor0X(0x605858, 1.0)];//设置自己想要的颜色、
    if (self.tableModels.count < 12) {
        return;
    }
    self.models =  self.tableModels;
//                @[
//                    self.tableModels[7],
//                    self.tableModels[0],
//                    self.tableModels[3],
//                    self.tableModels[4],
//                    self.tableModels[2],
//                    self.tableModels[1],
//                    self.tableModels[10],
//                    self.tableModels[11],
//                    self.tableModels[5],
//                    self.tableModels[6],
//                    self.tableModels[8],
//                    self.tableModels[9]
//                    ];
    
    
    
    
    // 获取准确的contentSize前调用
    UIScrollView *box = (UIScrollView *)self.tableView.superview;
    UIEdgeInsets inset = box.contentInset;
    inset.top += 15;
    box.contentInset = inset;
    
    
    [self.tableView layoutIfNeeded];
    if(self.tableView.contentSize.height > (screenHeight - kStatusBarAndNavigationBarHeight - SafeAreaBottomHeight - 79)){
        //box.contentInset = UIEdgeInsetsMake(box.contentInset.top, 0, box.contentInset.bottom + 79+SafeAreaBottomHeight, 0);
        box.contentInset = UIEdgeInsetsMake(box.contentInset.top, 0, box.contentInset.bottom + 79+SafeAreaBottomHeight+kStatusBarAndNavigationBarHeight, 0);

    }
    

    self.tableView.frame =CGRectMake(0, 0, screenWidth-30, self.tableView.contentSize.height);
    box.contentSize = CGSizeMake(screenWidth-30, self.tableView.frame.size.height);
    self.tableView.backgroundColor = [UIColor clearColor];
  
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-30, self.tableView.contentSize.height)];
    bgIV.image = [UIImage imageNamed:@"照片分享"];

    [self.tableView.superview insertSubview:bgIV atIndex:0];
    self.bgIV = bgIV;
    


    UILabel *desLB = self.tableView.tableFooterView.subviews.lastObject;
    
    NSString *text = @"定期提醒测量，\n看见一毫米的改变，\n看见新的自己";
    NSMutableAttributedString *attText =  [[NSMutableAttributedString alloc] initWithString:text];
    
    [attText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:15]
                        range:NSMakeRange(0, attText.length)];
    [attText addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:0.36 green:0.33 blue:0.33 alpha:1.00]
                        range:NSMakeRange(0, attText.length)];
    
    [attText addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:20]
                    range:NSMakeRange(4, 2)];


    
    desLB.attributedText = attText;
    
}

- (void)setShareImage:(UIImage *)shareImage{
    _shareImage = shareImage;
    CGFloat w = [UIScreen mainScreen].bounds.size.width-30;
    CGFloat h = shareImage? (w * _shareImage.size.height / _shareImage.size.width) : 0;
    self.headerView.image = shareImage;
    self.headerView.superview.bounds = CGRectMake(0, 0, w, h+170);
    self.addBtn.hidden = (BOOL)shareImage;
    
    self.bgIV.frame = CGRectMake(0, h, self.bgIV.bounds.size.width,  self.bgIV.bounds.size.height);
    [self.tableView reloadData];

    [self.tableView layoutIfNeeded];

    self.tableView.frame = CGRectMake(0, 0, screenWidth-30, self.tableView.contentSize.height);
    UIScrollView *box = (UIScrollView *)self.tableView.superview;
    box.contentSize = CGSizeMake(screenWidth-30, self.tableView.frame.size.height);


    [self.headerView.superview setRounded:self.headerView.superview.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:20];

}

- (void)cancelAction{

    [self.navigationController popToRootViewControllerAnimated:YES];
    return;
    if (!self.shareImage) {
        [self popViewController:nil];
        return;
    }
    
    self.shareImage = nil;
    [self takePhotoAction:nil];
}

- (IBAction)takePhotoAction:(UIButton *)sender {
     __weak typeof(self) weakSelf = self;
    PCShareController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCShareController"];
    vc.choseImageBlock = ^(UIImage * _Nonnull image) {
        weakSelf.shareImage = image;
    };
    [self.navigationController pushViewController:vc animated:YES];
    //    vc.tableModels = self.tableModels;
    //vc.tableModels = self.reportModels;
    
    //UINavigationController *navVC =  [[UINavigationController alloc] initWithRootViewController:vc];
   // navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    //[self presentViewController:vc animated:YES completion:nil];
}


- (void)shareAction{
    PCShareView *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"PCShareView"];
    vc.image = [self convertViewToImage:self.tableView];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:nil ];
    [self savePhoto:vc.image];
}

- (void)savePhoto:(UIImage *)image{
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 请求/检查访问权限：
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied && oldStatus != PHAuthorizationStatusNotDetermined) { //用户拒绝当前App访问相册
                
                
//                PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"请打开相册权限"] message:@"设置-隐私-相册"];
//                [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
//
//                }];
//                [self presentViewController:vc animated:NO completion:nil];
                [MBProgressHUD showError:[NSString stringWithFormat:@"请打开相册权限 \n\r 设置-隐私-相册"]];

                
            } else if (status == PHAuthorizationStatusAuthorized){  // 用户允许当前App访问相册
                ///
                [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (error) {
                        YHLog(@"%@",@"保存失败");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:@"保存失败"];
                        });
                    } else {
                        YHLog(@"%@",@"保存成功");
                    }
                }];
                ///
            } else if (status == PHAuthorizationStatusRestricted){  // 无法访问相册

                [MBProgressHUD showError:[NSString stringWithFormat:@"因系统原因，无法访问相册"]];

//                PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"因系统原因，无法访问相册" message:nil];
//                [vc addActionWithTitle:@"确定" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
//                    
//                }];
//                [self presentViewController:vc animated:NO completion:nil];

            }
        });
    }];
    
}



- (UIImage *)convertViewToImage:(UITableView *)tableView {
    
    UIImage* viewImage = nil;
    UITableView *scrollView = (UITableView *)self.tableView.superview;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    
    return viewImage;
    
    CGPoint savedContentOffset = tableView.contentOffset;
    ///计算画布所需实际高度
    CGFloat contentHeight = 0;
    if (tableView.tableHeaderView)
        contentHeight += tableView.tableHeaderView.frame.size.height;
    {
        NSInteger sections = tableView.numberOfSections;
        for (NSInteger i = 0; i < sections; i++) {
            contentHeight += [tableView rectForHeaderInSection:i].size.height;
            
            NSInteger rows = [tableView numberOfRowsInSection:i];
            {
                for (NSInteger j = 0; j < rows; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    contentHeight += cell.frame.size.height;
                }
            }
            
            contentHeight += [tableView rectForFooterInSection:i].size.height;
        }
    }
    if (tableView.tableFooterView)
        contentHeight += tableView.tableFooterView.frame.size.height;
    
    ///创建画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tableView.frame.size.width, contentHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    ///把所有的视图 render到CGContext上
    if (tableView.tableHeaderView) {
        contentHeight = tableView.tableHeaderView.frame.size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        [tableView.tableHeaderView.layer renderInContext:ctx];
        CGContextTranslateCTM(ctx, 0, tableView.tableHeaderView.frame.size.height);
    }
    
    NSInteger sections = tableView.numberOfSections;
    for (NSInteger i = 0; i < sections; i++) {
        ///sectionHeader
        contentHeight += [tableView rectForHeaderInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *headerView = [tableView headerViewForSection:i];
        if (headerView) {
            [headerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, headerView.frame.size.height);
        }
        ///Cell
        NSInteger rows = [tableView numberOfRowsInSection:i];
        {
            for (NSInteger j = 0; j < rows; j++) {
                //讓該cell被正確的產生在tableView上, 之後才能在CGContext上正確的render出來
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                contentHeight += cell.frame.size.height;
                [cell.layer renderInContext:ctx];
                CGContextTranslateCTM(ctx, 0, cell.frame.size.height);
            }
        }
        ///sectionFooter
        contentHeight += [tableView rectForFooterInSection:i].size.height;
        tableView.contentOffset = CGPointMake(0, contentHeight);
        UIView *footerView = [tableView footerViewForSection:i];
        if (footerView) {
            [footerView.layer renderInContext:ctx];
            CGContextTranslateCTM(ctx, 0, footerView.frame.size.height);
        }
    }
    
    if (tableView.tableFooterView) {
        tableView.contentOffset = CGPointMake(0, tableView.contentSize.height-tableView.frame.size.height);
        [tableView.tableFooterView.layer renderInContext:ctx];
        //CGContextTranslateCTM(ctx, 0, tableView.tableFooterView.frame.size.height);
    }
    
    ///生成UIImage对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    tableView.contentOffset = savedContentOffset;
    return image;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YHCellItem *model = self.models[indexPath.row];
    
    cell.icon.image = [UIImage imageNamed:model.icon];
    cell.nameLB.text = model.name;
    //cell.valueLB.text = [NSString stringWithFormat:@"%.1f",roundf(model.value*10)*0.1];
    //cell.valueLB.text = [NSString stringWithFormat:@"%.1f",((NSInteger)(model.value*10+0.5))*0.1];
    cell.valueLB.text = [NSString stringWithFormat:@"%.1f",[YHTools roundNumberStringWithRound:1 number:model.normal]];

    
    double d = [YHTools roundNumberStringWithRound:1 number:model.change];
    NSString *x = ((d < 0)? (@"减少") : (d > 0? (@"增加") : (@"")));
    //cell.changeLB.text = [NSString stringWithFormat:@"%@%0.1f",x,roundf(model.change*10)*0.1];
    //cell.changeLB.text = [NSString stringWithFormat:@"%@%0.1f",x,((NSInteger)(model.change*10+0.5))*0.1];
    cell.changeLB.text = [NSString stringWithFormat:@"%@%.1f",x,[YHTools roundNumberStringWithRound:1 number:fabs(model.change)]];


    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    YHLog(@"%s--%f", __func__,scrollView.contentOffset.y);
    
    YHLog(@"%s--%f", __func__,scrollView.contentSize.height - scrollView.bounds.size.height);

    CGFloat alpha = (scrollView.contentOffset.y)/(scrollView.contentSize.height - scrollView.bounds.size.height);
    self.guideView.alpha = 1 - ((alpha > 1)? 1.0 : alpha);
}

@end
