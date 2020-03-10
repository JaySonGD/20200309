//
//  YHCheckCarAllPictureViewController.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/6/26.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCheckCarAllPictureViewController.h"
#import "YHAddPictureContentView.h"
#import "UIAlertController+Blocks.h"

#import "AccidentDiagnosisCell.h"

#import "TTZSurveyModel.h"
#import "TTZDBModel.h"

#import "NSObject+BGModel.h"
#import "YHPhotoManger.h"
#import "YHHUPhotoBrowser.h"
#import "TTZUpLoadService.h"
#import "YHCarPhotoService.h"

#import <UIButton+WebCache.h>


@interface YHCheckCarAllPictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) NSInteger willSelectIndex;
@property (nonatomic, weak) UICollectionView *photoView;
@end

static  NSInteger MaxAllowUploadCount = 10;

@implementation YHCheckCarAllPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test];

    [self initCheckCarAllPictureBase];
    
    [self initCheckCarAllPictureUI];
    
}

- (void)test{
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
}

- (void)initCheckCarAllPictureBase{
    
    self.title = @"检测封面";
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
}
- (void)initCheckCarAllPictureUI{
    
    if(!self.isAllowUpLoad && !self.model.dbImages.count){
        [MBProgressHUD showError:@"暂无封面图片"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    
    CGFloat topMargin = iPhoneX ? 88 : 64;
    
    if (self.isAllowUpLoad) {
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(saveBtnClickedEvent) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"保存" forState: UIControlStateNormal];
        [rightBtn setTitleColor:YHNagavitionBarTextColor forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    UIView *pictureContentView = [[UIView alloc] init];
    pictureContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pictureContentView];
    [pictureContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@0);
        make.height.equalTo(@126);
        make.width.equalTo(pictureContentView.superview);
    }];
    // 标题Label
    UILabel *picTitleL = [[UILabel alloc] init];
    picTitleL.text = @"车辆外观图片";
    [pictureContentView addSubview:picTitleL];
    [picTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.left.equalTo(@20);
        make.height.equalTo(@45);
        make.width.equalTo(picTitleL.superview);
    }];
    // 分隔线
    UIView *seprateLine = [[UIView alloc] init];
    seprateLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [pictureContentView addSubview:seprateLine];
    [seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(picTitleL.mas_bottom);
        make.left.equalTo(@0);
        make.height.equalTo(@1);
        make.width.equalTo(seprateLine.superview);
    }];
    // 增加图片按钮
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *photoView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    photoView.showsVerticalScrollIndicator = NO;
    photoView.showsHorizontalScrollIndicator = NO;
    
    photoView.dataSource = self;
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [photoView registerClass:[YHPhotoAddCell class] forCellWithReuseIdentifier:@"YHPhotoAddCell"];
    layout.itemSize = CGSizeMake(62, 62);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _photoView = photoView;
    
    [pictureContentView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(seprateLine.mas_bottom).offset(10);
        make.left.equalTo(pictureContentView.mas_left).offset(20);
        make.bottom.equalTo(pictureContentView.mas_bottom).offset(-10);
        make.right.equalTo(pictureContentView.mas_right).offset(-20);
    }];
    
    if (self.isExistCoverTask) {
        __weak typeof(self) weakSelf = self;
        [TTZUpLoadService sharedTTZUpLoadService].complete = ^(NSString *fileId) {
            
            if (!weakSelf.isExistCoverTask) {//上传完毕，重新拉一下数据
#pragma mark 要重新拉一下数据
                [weakSelf refreshImage];
            }
            
        };
    }else if(self.isAllowUpLoad){
        [self refreshRemoteAndLocalImage];
    }else{
        [self refreshImage];
    }
}

- (void)refreshRemoteAndLocalImage{
    [MBProgressHUD showMessage:@"" toView:self.view];
     __weak typeof(self) weakSelf = self;
    [[YHCarPhotoService new] getBillImageListByBillId:self.model.billId
                                              imgCode:self.model.code
                                                 type:3
                                              success:^(NSArray *list) {
                                                  
                                                  NSArray *relatives = [list valueForKeyPath:@"relative_url"];
                                                  NSArray *imgs = [list valueForKeyPath:@"url"];

                                                  if (imgs.count) {
                                                      [weakSelf.model.dbImages removeAllObjects];
                                                      if (imgs.count < MaxAllowUploadCount) {
                                                          
                                                          // 现添加远程资源
                                                          for (NSInteger i = 0; i < imgs.count; i ++) {
                                                              TTZDBModel *db = [TTZDBModel new];
                                                              //db.fileId = imgs[i];
                                                              db.fileId = [NSString stringWithFormat:@"%@;%@",imgs[i],relatives[i]];

                                                              [weakSelf.model.dbImages addObject:db];
                                                          }
                                                          
                                                          NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",weakSelf.model.billId,weakSelf.model.code]];
                                                          
                                                          NSInteger count = imgs.count + localImages.count;
                                                          count = (count > MaxAllowUploadCount)? MaxAllowUploadCount : count; //最多5个
                                                          
                                                          for (NSInteger i = imgs.count; i < count; i ++) {
                                                              TTZDBModel *db = localImages[i - imgs.count];
                                                              [weakSelf.model.dbImages addObject:db];
                                                          }
                                                          
                                                          // 加上本地缓存还小于5张图片
                                                          if (count<MaxAllowUploadCount) {
                                                              TTZDBModel *defaultDB = [TTZDBModel new];
                                                              defaultDB.image = [UIImage imageNamed:@"otherAdd"];
                                                              [weakSelf.model.dbImages addObject:defaultDB];
                                                          }
                                                          
                                                      }else{
                                                          for (NSInteger i = 0; i < MaxAllowUploadCount; i ++) {
                                                              TTZDBModel *db = [TTZDBModel new];
                                                              //db.fileId = imgs[i];
                                                              db.fileId = [NSString stringWithFormat:@"%@;%@",imgs[i],relatives[i]];

                                                              [weakSelf.model.dbImages addObject:db];
                                                          }
                                                      }
                                                  }else{
                                                      [weakSelf.model.dbImages removeAllObjects];
                                                      NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",weakSelf.model.billId,weakSelf.model.code]];
                                                      NSInteger count = localImages.count;
                                                      count = (count > MaxAllowUploadCount)? MaxAllowUploadCount : count; //最多5个
                                                      
                                                      for (NSInteger i = 0; i < count; i ++) {
                                                          TTZDBModel *db = localImages[i];
                                                          [weakSelf.model.dbImages addObject:db];
                                                      }
                                                      
                                                      // 加上本地缓存还小于5张图片
                                                      if (count<MaxAllowUploadCount) {
                                                          TTZDBModel *defaultDB = [TTZDBModel new];
                                                          defaultDB.image = [UIImage imageNamed:@"otherAdd"];
                                                          [weakSelf.model.dbImages addObject:defaultDB];
                                                      }
                                                  }
                                                  [MBProgressHUD hideHUDForView:self.view];
                                                  [weakSelf.photoView reloadData];
                                                  
                                              }
                                              failure:^(NSError *error) {
                                                  [MBProgressHUD hideHUDForView:self.view];
                                              }];
    
}

- (void)refreshImage{
    [MBProgressHUD showMessage:@"" toView:self.view];
    __weak typeof(self) weakSelf = self;
    [[YHCarPhotoService new] getBillImageListByBillId:self.model.billId
                                              imgCode:self.model.code
                                                 type:3
                                              success:^(NSArray *list) {
                                                  
                                                  NSArray *imgs = [list valueForKeyPath:@"url"];
                                                  NSArray *relatives = [list valueForKeyPath:@"relative_url"];

                                                  [weakSelf.model.dbImages removeAllObjects];
                                                  if (imgs.count<MaxAllowUploadCount) {//少于五张
                                                      
                                                      // 现添加远程资源
                                                      for (NSInteger i = 0; i < imgs.count; i ++) {
                                                          TTZDBModel *db = [TTZDBModel new];
                                                          //db.fileId = imgs[i];
                                                          db.fileId = [NSString stringWithFormat:@"%@;%@",imgs[i],relatives[i]];

                                                          [weakSelf.model.dbImages addObject:db];
                                                      }
                                                      
                                                      if (self.isAllowUpLoad) {
                                                          TTZDBModel *defaultDB = [TTZDBModel new];
                                                          defaultDB.image = [UIImage imageNamed:@"otherAdd"];
                                                          [weakSelf.model.dbImages addObject:defaultDB];
                                                      }
                                                      
                                                      
                                                  }else{//五张全部上传成功
                                                      for (NSInteger i = 0; i < MaxAllowUploadCount; i ++) {
                                                          TTZDBModel *db = [TTZDBModel new];
                                                          //db.fileId = imgs[i];
                                                          db.fileId = [NSString stringWithFormat:@"%@;%@",imgs[i],relatives[i]];

                                                          [weakSelf.model.dbImages addObject:db];
                                                      }
                                                  }
                                                  [weakSelf.photoView reloadData];
                                                  [MBProgressHUD hideHUDForView:self.view];
                                                  
                                              }
                                              failure:^(NSError *error) {
                                                  [MBProgressHUD hideHUDForView:self.view];
                                              }];
    
    
}

#pragma mark  - 拍照
- (void)setPhotoImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark  - 相册
- (void)setImagePickerVC:(NSInteger)index {
    self.willSelectIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//FIXME:  -  是否存在上传封面的上传任务
- (BOOL)isExistCoverTask{
    if (![TTZUpLoadService sharedTTZUpLoadService].isUpLoad) return NO;
    //SELECT * FROM TTZDBModel WHERE (billId = '13779' AND code = 'car_appearance') AND type =3;
    //NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"where billId ='%@' and  code ='%@' ",self.model.billId,self.model.code]];
    NSArray <TTZDBModel *> *localImages = [TTZDBModel findWhere: [NSString stringWithFormat:@"WHERE (billId = '%@' AND code = '%@') AND type = 3 ",self.model.billId,self.model.code]];
    
    return (BOOL)localImages.count;
}


//FIXME:  -  UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (self.model.dbImages.count > MaxAllowUploadCount)? MaxAllowUploadCount : self.model.dbImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHPhotoAddCell" forIndexPath:indexPath];
    
    NSLog(@"%s----url--%@---%d", __func__,self.model.dbImages[indexPath.item].fileId,indexPath.item);

    if([self.model.dbImages[indexPath.item].fileId containsString:@"http"]){
        NSString *url = [self.model.dbImages[indexPath.item].fileId componentsSeparatedByString:@";"].firstObject;
        [cell.imageBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"carModelDefault"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%s--%@---%@---%@", __func__,image,error,imageURL);
        }];
    }else{
        //[cell.imageBtn setImage:nil forState:UIControlStateNormal];
        //[cell.imageBtn setImage:self.model.dbImages[indexPath.item].image forState:UIControlStateNormal];
        [cell.imageBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:self.model.dbImages[indexPath.item].image];
    }
    
    if (self.isAllowUpLoad && !self.isExistCoverTask) {//可以上传和没有上传封面任务的时候允许操作图片
        
        cell.clearnBtn.hidden = !((BOOL)(self.model.dbImages[indexPath.item].fileId));
        
        __weak typeof(self) weakSelf = self;
        cell.clearnAction = ^{
            
            TTZDBModel *deleteModel = weakSelf.model.dbImages[indexPath.item];
            
            if([deleteModel.fileId containsString:@"http"]){
#pragma mark 要删除远程的图片
                [weakSelf deleteRemoteImage:deleteModel success:nil failure:nil];
            }
            
            [weakSelf.model.dbImages removeObject:deleteModel];
            [TTZDBModel deleteWhere:[NSString stringWithFormat:@"where fileId ='%@'",deleteModel.fileId]];
            
            if (weakSelf.model.dbImages.count < MaxAllowUploadCount && ![weakSelf.model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
                TTZDBModel *defaultModel = [TTZDBModel new];
                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                [weakSelf.model.dbImages addObject:defaultModel];
                
            }
            [weakSelf.photoView  reloadData];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //已经到了完成状态，只可以预览图片，不可以编辑图片
    if (!self.isAllowUpLoad) {
        NSMutableArray *urls = [NSMutableArray array];
        [self.model.dbImages enumerateObjectsUsingBlock:^(TTZDBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *url = [obj.fileId componentsSeparatedByString:@";"].firstObject;
            [urls addObject:url];
        }];
        
        [YHHUPhotoBrowser showFromImageView:nil withURLStrings:urls placeholderImage:[UIImage imageNamed:@"carModelDefault"] atIndex:indexPath.item dismiss:nil];
        return;
    }
    
    if (!IsEmptyStr(self.model.dbImages[indexPath.item].fileId)) return;
    
    // 允许上传图片
    
    if(self.isExistCoverTask){
        [MBProgressHUD showError:@"暂有封面图片上传任务,请稍后再操作"];
        return;
    }
    UICollectionViewCell *sender = [collectionView cellForItemAtIndexPath:indexPath];
    [UIAlertController showInViewController:self withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self setImagePickerVC:indexPath.item];
            return;
        }
        [self setPhotoImagePickerVC:indexPath.item];
        
    }];
}



#pragma mark  -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    TTZDBModel *selectModel = self.model.dbImages[self.willSelectIndex];
    if([selectModel.fileId containsString:@"http"]){
#pragma mark 要删除远程的图片
        __weak typeof(self) weakSelf = self;
        [self deleteRemoteImage:selectModel success:^{
            
            selectModel.fileId = nil;
            
            NSString *fileName = [YHPhotoManger fileName];
            
            if(!selectModel.fileId.length) selectModel.fileId = fileName;
            selectModel.billId = weakSelf.model.billId;
            selectModel.image = image;
            selectModel.file = fileName;
            selectModel.code = weakSelf.model.code;
            selectModel.type = 3;
            
            selectModel.timestamp = selectModel.timestamp? selectModel.timestamp : YHPhotoManger.timestamp;
            
            [selectModel saveOrUpdate:@[@"image"]];
            
#pragma mark 保存图片
            [YHPhotoManger saveImage:image
                        subDirectory:weakSelf.model.billId
                            fileName:fileName];
            
            if (weakSelf.willSelectIndex<(MaxAllowUploadCount - 1) && weakSelf.willSelectIndex == weakSelf.model.dbImages.count - 1) {
                TTZDBModel *defaultModel = [TTZDBModel new];
                defaultModel.image = [UIImage imageNamed:@"otherAdd"];
                [weakSelf.model.dbImages addObject:defaultModel];
            }
            [weakSelf.photoView reloadData];
            NSInteger maxIndex = (weakSelf.model.dbImages.count > MaxAllowUploadCount)? (MaxAllowUploadCount - 1) : (weakSelf.model.dbImages.count-1);
            
            [weakSelf.photoView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:maxIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];

            
        } failure:nil];
        
        return;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    NSString *fileName = [YHPhotoManger fileName];
    
    if(!selectModel.fileId.length) selectModel.fileId = fileName;
    selectModel.billId = self.model.billId;
    selectModel.image = image;
    selectModel.file = fileName;
    selectModel.code = self.model.code;
    selectModel.type = 3;
    
    selectModel.timestamp = selectModel.timestamp? selectModel.timestamp : YHPhotoManger.timestamp;

    [selectModel saveOrUpdate:@[@"image"]];
    
#pragma mark 保存图片
    [YHPhotoManger saveImage:image
                subDirectory:self.model.billId
                    fileName:fileName];
    
    if (self.willSelectIndex<(MaxAllowUploadCount - 1) && self.willSelectIndex == self.model.dbImages.count - 1) {
        TTZDBModel *defaultModel = [TTZDBModel new];
        defaultModel.image = [UIImage imageNamed:@"otherAdd"];
        [self.model.dbImages addObject:defaultModel];
    }
    [self.photoView reloadData];
    
    NSInteger maxIndex = (self.model.dbImages.count > MaxAllowUploadCount)? (MaxAllowUploadCount - 1) : (self.model.dbImages.count-1);

    [self.photoView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:maxIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];

    
}

- (void)deleteRemoteImage:(TTZDBModel *)dbModel
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[YHCarPhotoService new] deleteBillImageByBillId:self.model.billId
                                              imgURL:[dbModel.fileId componentsSeparatedByString:@";"].lastObject
                                                type:3
                                             success:^{
                                                 !(success)? : success();
                                                 [MBProgressHUD hideHUDForView:self.view];
                                             }
                                             failure:^(NSError *error) {
                                                 !(failure)? : failure(error);
                                                 [MBProgressHUD hideHUDForView:self.view];
                                                 [MBProgressHUD showError:[error.userInfo valueForKey:@"message"]];
                                             }];
}

#pragma mark - 保存 ----
- (void)saveBtnClickedEvent{
    
    __weak typeof(self) weakSelf = self;
    [TTZDBModel updateSet:[NSString stringWithFormat:@"SET isUpLoad = 1 where billId ='%@' and type = 3",self.model.billId]];
//    [[TTZUpLoadService sharedTTZUpLoadService] uploadDidHandle:^{
//        !(weakSelf.callBackBlock)? : weakSelf.callBackBlock();
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
    
    [[TTZUpLoadService sharedTTZUpLoadService] uploadOrder:self.model.billId didHandle:^{
        !(weakSelf.callBackBlock)? : weakSelf.callBackBlock();
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    
}

- (void)popViewController:(id)sender{
    !(_callBackBlock)? : _callBackBlock();
    [super popViewController:sender];
}

- (void)dealloc{
    NSLog(@"%s----guole", __func__);
}
@end
