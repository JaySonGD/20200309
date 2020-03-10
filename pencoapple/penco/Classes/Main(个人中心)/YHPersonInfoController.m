//
//  YHPersonInfoController.m
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "UIViewController+RESideMenu.h"
#import "YHPersonInfoController.h"
#import "YHPortraitController.h"
#import "PCAlertViewController.h"

#import "PCPersonModel.h"

#import "YHCommon.h"
#import "YHTools.h"

#import "YHNetworkManager.h"

#import <MBProgressHUD.h>
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>

static const DDLogLevel ddLogLevel = DDLogLevelInfo;
NSString *const notificationReloadUser = @"PCNotificationReloadUser";
NSString *const notificationCheckUser = @"notificationCheckUser";
extern NSString *const notificationReloadLoginInfo;
extern NSString *const notificationConfirmReport;


@interface YHPersonInfoController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;

@property (weak, nonatomic) IBOutlet UIButton *headImg;
@property (nonatomic, strong) NSMutableDictionary *parm;
@property (weak, nonatomic) IBOutlet UIImageView *ageimg;
@property (weak, nonatomic) IBOutlet UIImageView *heghtImg;

@property (weak, nonatomic) IBOutlet UIImageView *nameimg;
@property (nonatomic, assign) BOOL addSuccess;

@end

@implementation YHPersonInfoController
- (IBAction)sexAction:(id)sender {
    [self.view endEditing:YES];
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = @"男";
        self.sexTF.tag = 1;
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = @"女";
        self.sexTF.tag = 2;
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sexTF.userInteractionEnabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if(_action == PersonInfoActionDefault) return;
    
    [self.tableView layoutIfNeeded];
    
    CGFloat h = screenHeight - kStatusBarAndNavigationBarHeight - SafeAreaBottomHeight - self.tableView.contentSize.height;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, h)];
    self.tableView.tableFooterView = footer;
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0, 0, 205, 44);
    actionBtn.center = CGPointMake(screenWidth*0.5, h - 36 - 22);
    actionBtn.backgroundColor = YHColor0X(0xD2B081, 1.0);
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [actionBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [actionBtn setTitle:(_action == PersonInfoActionAdd)? @"确认添加": ((_action == PersonInfoActionNext)? @"下一步":@"删除") forState:UIControlStateNormal];
    YHViewRadius(actionBtn, 22);
    actionBtn.hidden = (_action == PersonInfoActionMasterDetail);
    [footer addSubview:actionBtn];
    
    UILabel *msg = [[UILabel alloc] init];
    msg.text = @"请如实填写个人信息，以免影响测量";
    msg.textColor = YHColor(130, 130, 130);
    [msg sizeToFit];
    msg.center = CGPointMake(footer.center.x, 0);
    [footer addSubview:msg];
    
    if (_action == PersonInfoActionNext) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(exitApp)];
        [self.navigationController.navigationBar setTintColor:YHColor0X(0x605858, 1.0)];//设置自己想要的颜色
    }
    
    if (_action == PersonInfoActionAdd) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(popViewController:)];
        [self.navigationController.navigationBar setTintColor:YHColor0X(0x605858, 1.0)];//设置自己想要的颜色
    }
    
    //    if ([YHTools sharedYHTools].lastImage) {
    //        [self.headImg setImage:[YHTools sharedYHTools].lastImage forState:UIControlStateNormal];
    //        self.parm[@"headImg"] = [YHTools base64FromImage:[YHTools sharedYHTools].lastImage];
    //    }
    
    if(_action == PersonInfoActionAdd || _action == PersonInfoActionNext) return;
    
    //[self.headImg setImage:[YHTools imageFromBase64:self.model.headImg] forState:UIControlStateNormal];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.model.headImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.parm[@"headImg"] = [YHTools base64FromImage:image];
    }];
    
    self.nameTF.text = self.model.personName;
    self.sexTF.text = self.model.sex? @"女" : @"男";
    self.sexTF.tag = self.model.sex + 1;
    self.ageTF.text = [NSString stringWithFormat:@"%ld",(long)self.model.age];
    self.heightTF.text = [NSString stringWithFormat:@"%ld",(long)self.model.height];//self.model.height;
    self.weightTF.text = [NSString stringWithFormat:@"%.2f",self.model.weight];//self.model.weight;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(modifyAction)];
    [self.navigationController.navigationBar setTintColor:YHColor(57, 57, 57)];//设置自己想要的颜色
    
    self.parm[@"personId"] = self.model.personId;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)exitApp{
    //    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"您确定要退出体形管家？" message:nil];
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否退出登陆" message:nil];
    [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:^(UIButton * _Nonnull action) {
    }];
    [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [self popViewController:nil];
    }];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)popViewController:(id)sender{
    if (_action == PersonInfoActionNext) {
        
        if (!self.addSuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadLoginInfo object:Nil userInfo:nil];
            //            NSAssert(1 > 2, @"必须至少要添加一个用户");
            exit(1);
            return;
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PCNotificationShowCoverView" object:Nil userInfo:nil];
        
    }
    if (self.isLeft) {
        [self presentLeftMenuViewController:sender];
    }
    [super popViewController:sender];
}

- (void)modifyAction{
    
    self.parm[@"personName"] = self.nameTF.text;
    self.parm[@"sex"] = @(self.sexTF.tag-1);
    self.parm[@"age"] = [@"" isEqualToString:self.ageTF.text]? @"0" : self.ageTF.text;
    self.parm[@"height"] = self.heightTF.text;
    self.parm[@"weight"] = self.weightTF.text;
    if ([self convertToInt:self.parm[@"personName"]] > 16) {
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    if (!self.nameTF.hasText) {
        [MBProgressHUD showError:@"请填写昵称"];
        
        return;
    }
    NSString * regex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:self.parm[@"personName"]]){
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    
    if (!self.heightTF.hasText) {
        [MBProgressHUD showError:@"请填写身高"];
        return;
    }
    if( !(self.heightTF.text.integerValue >=10 && self.heightTF.text.integerValue <= 220) ){
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    //        if(!(self.weightTF.text.integerValue >=5 && self.weightTF.text.integerValue <= 200) ){
    //            [MBProgressHUD showError:@"请填写合适的体重"];
    //            return;
    //        }
    
    if((self.ageTF.text.integerValue <0 || self.ageTF.text.integerValue > 99) && !IsEmptyStr(self.ageTF.text)){
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    
    //    if (!self.parm[@"headImg"]) {
    //        [MBProgressHUD showError:@"请添加头像"];
    //        return;
    //    }
    
    if (!self.nameTF.hasText) {
        [MBProgressHUD showError:@"请填写昵称"];
        
        return;
    }
    
    if(!self.sexTF.tag && self.sexTF.hasText){
        if ([self.sexTF.text isEqualToString:@"男"]) {
            self.sexTF.tag = 1;
        }
        if ([self.sexTF.text isEqualToString:@"女"]) {
            self.sexTF.tag = 2;
        }
        
    }
    
    if (!self.sexTF.tag) {
        [MBProgressHUD showError:@"请填写性别"];
        return;
    }
    //    if (!self.ageTF.hasText) {
    //        [MBProgressHUD showError:@"请填写年龄"];
    //        return;
    //    }
    if (!self.heightTF.hasText) {
        [MBProgressHUD showError:@"请填写身高"];
        return;
    }
    //    if (!self.weightTF.hasText) {
    //        [MBProgressHUD showError:@"请填写体重"];
    //        return;
    //    }
    
    
    [self modify];
    
}

- (void)modify{
    
    NSString *accountId = YHTools.accountId;
    
    if (!accountId ) {
        return;
    }
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] modifyPerson:self.parm onComplete:^(PCPersonModel *model) {
        YHLog(@"%s", __func__);
        [MBProgressHUD hideHUDForView:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadUser object:Nil userInfo:nil];
        //        [MBProgressHUD showError:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.sourceVC) {
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationConfirmReport object:self.observer userInfo:@{@"personId" : model.personId}];
                [self.navigationController popToViewController:self.sourceVC animated:NO];
            }
            else [self popViewController:nil];
        });
        
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
        YHLog(@"%s", __func__);
    }];
    
}


- (void)btnAction{
    if (self.action == PersonInfoActionAdd || self.action == PersonInfoActionNext) {
        
        
        self.parm[@"personName"] = self.nameTF.text;
        self.parm[@"sex"] = @(self.sexTF.tag-1);
        self.parm[@"age"] = [@"" isEqualToString:self.ageTF.text]?  @"0" : self.ageTF.text;
        self.parm[@"height"] = self.heightTF.text;
        self.parm[@"weight"] = self.weightTF.text;
        //        if (!self.parm[@"headImg"]) {
        //            [MBProgressHUD showError:@"请添加头像"];
        //            return;
        //        }
        
        if (!self.nameTF.hasText) {
            [MBProgressHUD showError:@"请填写昵称"];
            
            return;
        }
        
        if ([self convertToInt:self.parm[@"personName"]] > 16) {
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return;
        }
        
        NSString * regex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if(![pred evaluateWithObject:self.parm[@"personName"]]){
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return;
        }
        
        
        if(!self.sexTF.tag && self.sexTF.hasText){
            if ([self.sexTF.text isEqualToString:@"男"]) {
                self.sexTF.tag = 1;
            }
            if ([self.sexTF.text isEqualToString:@"女"]) {
                self.sexTF.tag = 2;
            }
            
        }
        
        if (!self.sexTF.tag) {
            [MBProgressHUD showError:@"请填写性别"];
            return;
        }
        if (!self.heightTF.hasText) {
            [MBProgressHUD showError:@"请填写身高"];
            return;
        }
        if( !(self.heightTF.text.integerValue >=10 && self.heightTF.text.integerValue <= 220) ){
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return;
        }
        
        
        if (self.sourceVC) {
            
            
            PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定测量用户为'%@'",self.nameTF.text] message:nil];
            
            [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
            [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
                [self addUser];
            }];
            [self presentViewController:vc animated:NO completion:nil];
            
            return;
        }
        
        [self addUser];
        
        return;
    }
    
    
    PCAlertViewController *vc = [PCAlertViewController alertControllerWithTitle:@"是否删除用户和\n该用户所有数据" message:nil];
    
    [vc addActionWithTitle:@"否" style:PCAlertActionStyleCancel handler:nil];
    [vc addActionWithTitle:@"是" style:PCAlertActionStyleDefault handler:^(UIButton * _Nonnull action) {
        [self deleteUser];
    }];
    [self presentViewController:vc animated:NO completion:nil];
    
    //    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"是否删除用户和该用户所有数据" preferredStyle:UIAlertControllerStyleAlert];
    //    [vc addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        [self deleteUser];
    //    }]];
    //    [vc addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
    //
    //    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)deleteUser{
    NSString *personId = self.model.personId;
    NSString *accountId = YHTools.accountId;
    
    if (!personId || !accountId ) {
        return;
    }
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] deletePerson:@{@"personId":self.model.personId} onComplete:^{
        [MBProgressHUD hideHUDForView:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadUser object:Nil userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popViewController:nil];
        });
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)addUser{
    NSString *accountId = YHTools.accountId;
    if ([self convertToInt:self.parm[@"personName"]] > 16) {
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    NSString * regex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:self.parm[@"personName"]]){
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    if((self.ageTF.text.integerValue <0 || self.ageTF.text.integerValue > 99) && !IsEmptyStr(self.ageTF.text)){
        [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
        return;
    }
    
    if (!accountId ) {
        return;
    }
    
    [MBProgressHUD showMessage:nil toView:self.view];
    [[YHNetworkManager sharedYHNetworkManager] addPerson:self.parm onComplete:^(PCPersonModel *model) {
        YHLog(@"%s", __func__);
        [MBProgressHUD hideHUDForView:self.view];
        if(self.sourceVC) [YHTools setPersonId:model.personId];
        [[NSNotificationCenter defaultCenter]postNotificationName:notificationReloadUser object:Nil userInfo:nil];
        self.addSuccess = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.sourceVC) {
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationConfirmReport object:self.observer userInfo:@{@"personId" : model.personId}];
                [self.navigationController popToViewController:self.sourceVC animated:YES];
            }
            else [self popViewController:nil];
        });
        
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YHLog(@"%s", __func__);
    }];
}


- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.nameTF == textField) {
        self.nameimg.hidden = NO;
    }
    if (self.ageTF == textField) {
           self.ageimg.hidden = NO;
       }
    if (self.heightTF == textField) {
           self.heghtImg.hidden = NO;
       }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.nameTF == textField) {
        self.nameimg.hidden = YES;
    }
    if (self.ageTF == textField) {
           self.ageimg.hidden = YES;
       }
    if (self.heightTF == textField) {
           self.heghtImg.hidden = YES;
       }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        /**< 在这里处理删除键的逻辑 */
        return YES;
    }
    if (textField == self.nameTF) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger length = [self textLength:newString];//转换过的长度
        YHLog(@"%@------长度: %ld",newString,length);
        
        if (length > 16)
        {
            return NO;
        }
        
        return YES;
    }
    if (textField == self.weightTF) {
        //如果输入的是“.”  判断之前已经有"."或者字符串为空
        if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return NO;
        }
        //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4){
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return NO;
        }
        
        
        if (![@"0123456789." containsString:string] && string.length > 0) {
            [MBProgressHUD showError:@"请如实填写个人信息，以免影响测量"];
            return NO;
        }
    }
    return YES;
}

-(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        //设置汉字和字母的比例  如何限制4个字符或12个字母 就是1:3  如果限制是6个汉字或12个字符 就是 1:2  一次类推
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}
//- (void)setAction:(PersonInfoAction)action{
//    _action = action;
//    if(action == PersonInfoActionDefault) return;
//    [self.tableView layoutIfNeeded];
//
//    CGFloat h = screenHeight - kStatusBarAndNavigationBarHeight - SafeAreaBottomHeight - self.tableView.contentSize.height;
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, h)];
//    self.tableView.tableFooterView = footer;
//
//    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    actionBtn.frame = CGRectMake(0, 0, 205, 44);
//    actionBtn.center = CGPointMake(screenWidth*0.5, h - 36 - 22);
//    [footer addSubview:actionBtn];
//    actionBtn.backgroundColor = YHColor0X(0xD2B081, 1.0);
//    actionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [actionBtn setTitle:(action == PersonInfoActionAdd)? @"确认添加":@"删除" forState:UIControlStateNormal];
//    YHViewRadius(actionBtn, 22);
//
//}

//#pragma mark - Table view data source
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    return (section == 1)? 3 : (section? 2:1);
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.userInteractionEnabled = (self.action != PersonInfoActionDelete) || (indexPath.row == 0 && indexPath.section == 0);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            WeakSelf
            YHPortraitController *vc = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"YHPortraitController"];
            
            vc.complete = ^(NSString * _Nonnull baseImag) {
                weakSelf.parm[@"headImg"] = baseImag;
                [weakSelf.headImg setImage:[YHTools imageFromBase64:baseImag] forState:UIControlStateNormal];
                //[YHTools sharedYHTools].lastImage = weakSelf.headImg.currentImage;
            };
            vc.imageUrl = self.model.headImg;
            //
            //[vc.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.headImg] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (NSMutableDictionary *)parm{
    if (!_parm) {
        _parm = [NSMutableDictionary dictionary];
        _parm[@"headImg"] = @"";
    }
    return _parm;
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
