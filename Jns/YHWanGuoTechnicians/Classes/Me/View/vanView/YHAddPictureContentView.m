//
//  YHAddPictureContentView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/3.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHAddPictureContentView.h"
#import <Masonry.h>
//#import "MBProgressHUD+MJ.h"
#import "YHCommon.h"
#import "YHImageItemView.h"
#import "YHPhotoManger.h"
#import "UIAlertController+Blocks.h"

#define YHGetImageKey @"getPic_imageIndex"
// 控制允许添加的最多的图片数量
#define MAXNUMBER 5

@interface YHAddPictureContentView() <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(nonatomic, strong) NSMutableArray *picArrs;
/** 增加图片按钮 */
@property(nonatomic, weak) UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray *arrImage;
/** 记录已选择的图片数量 */
@property (nonatomic, assign) NSInteger imageNumber;

@property (nonatomic, strong) NSFileManager *fileManager;
/** 记录每张图片存储的沙盒路径 */
@property (nonatomic, strong) NSMutableArray *imagePathArr;
/** 是否更新图片标识 */
@property(nonatomic, assign) BOOL isUpdateImage;
/** 目前正在更新的item */
@property (nonatomic, strong) YHImageItemView *item;

@end

@implementation YHAddPictureContentView

- (NSMutableArray *)picArrs{
    if (!_picArrs.count) {
        _picArrs = [NSMutableArray array];
    }
    return _picArrs;
}
- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}
- (NSMutableArray *)imagePathArr{
    if (!_imagePathArr.count) {
        _imagePathArr = [NSMutableArray array];
    }
    return _imagePathArr;
}

- (instancetype)initWithBilld:(NSString *)billd{
    if (self = [super init]) {
        
        self.billID = billd;
        self.isUpdateImage = NO;
       
        // 初始化增加按钮
        [self initAddBtn];
        
        [self initBase];
    }
    return self;
}
- (void)initBase{
    
    dispatch_group_t _group = dispatch_group_create();
    dispatch_group_notify(_group, dispatch_get_global_queue(0, 0), ^{
        
        dispatch_group_enter(_group);
        // 获取本地沙盒数据
        [self getLocalData];
        dispatch_group_leave(_group);
    });
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
       
        if (self.arrImage.count == 0) {
            [self initAddPictureContentView];
        }else{
            [self createAllChildView];
        }
    });
    
};
- (void)initAddBtn{
    
    UIButton *addBTn = [[UIButton alloc] init];
    addBTn.layer.borderColor = YHLineColor.CGColor;
    self.addBtn = addBTn;
    [addBTn setImage:[UIImage imageNamed:@"otherAdd"] forState:UIControlStateNormal];
    addBTn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBTn setTitleColor:YHLineColor forState:UIControlStateNormal];
    addBTn.backgroundColor = [UIColor whiteColor];
    [addBTn addTarget:self action:@selector(addTargetEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: addBTn];
    
}
#pragma mark - 获取沙盒数据 ---
- (void)getLocalData{
    // 默认为0
    self.imageNumber = 0;
    NSArray *imageArr = [[NSUserDefaults standardUserDefaults] objectForKey:YHGetImageKey];
    NSMutableArray *arr = [NSMutableArray array];
    if (imageArr.count > 0) {
        
        for (NSInteger i = 0; i<imageArr.count; i++) {
            NSString *imagePath = imageArr[i];
            NSData *imageData = [self.fileManager contentsAtPath:imagePath];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                // 有效的图片路径
                [self.imagePathArr addObject:imagePath];
                [arr addObject:image];
            }
        }
    }
    self.imageNumber = self.imagePathArr.count;
    self.arrImage = [NSMutableArray arrayWithArray:arr];

}
- (void)initAddPictureContentView{
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addBtn.superview).and.offset(20);
        make.top.equalTo(self.addBtn.superview).and.offset(20);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}
#pragma mark - 创建已经添加的ImageView ---
- (void)createAllChildView{
    
    for (int i = 0; i<self.arrImage.count; i++) {
       
        YHImageItemView *itemView = [[YHImageItemView alloc] initWithImageItemViewClearnBlock:^(YHImageItemView *item) {
             [self clickClearnBtnHandle:item];
        } tapImageViewBlock:^(YHImageItemView *item) {
            [self tapImageViewGesture:item];
        }];
        
        itemView.imagePath = self.imagePathArr[i];
        itemView.imageV.image = self.arrImage[i];
        [self addSubview:itemView];
        [self.picArrs addObject:itemView];
        
        // 10的间距和40的宽高
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@47);
            make.height.equalTo(@47);
            make.top.equalTo(itemView.superview).and.offset(20);
            make.left.equalTo(@(i*50 + 20));
            
        }];
    }
    
    YHImageItemView *lastItemView = [self.picArrs lastObject];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.bottom.equalTo(lastItemView);
        make.left.equalTo(lastItemView.mas_left).and.offset(50);
    }];
    
    self.addBtn.hidden = self.picArrs.count == MAXNUMBER ? YES : NO;
    
}
#pragma mark--图片触摸事件--
- (void)tapImageViewGesture:(YHImageItemView *)item{
    
    self.item = item;
    self.isUpdateImage = YES;
    
    [UIAlertController showInViewController:self.window.rootViewController withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = item;
        popover.sourceRect = item.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self openLocalPhoto];
            return;
        }
        [self takePhoto];
        
    }];
    
}
#pragma mark--清除按钮回调--
- (void)clickClearnBtnHandle:(YHImageItemView *)item{
    
    // 删除缓存中对用的图片
    NSError *error = nil;
    [self.fileManager removeItemAtPath:item.imagePath error:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        return;
    }
    // 删除item路径
    [self.imagePathArr removeObject:item.imagePath];
    // 删除图片
    [self.arrImage removeObject:item.imageV.image];
    // 删除控件记录
    [self.picArrs removeObject:item];
    self.imageNumber = self.picArrs.count;
    // 删除item
    [item removeFromSuperview];
    // 刷新UI
    [self refreshUI];
}

#pragma mark - 点击删除图片后刷新UI ---
- (void)refreshUI{
    
    for (int i = 0; i<self.picArrs.count; i++) {
        
        YHImageItemView *itemView = self.picArrs[i];
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@47);
            make.height.equalTo(@47);
            make.top.equalTo(itemView.superview).and.offset(20);
            make.left.equalTo(@(i*50 + 20));
        }];
    }
    
     YHImageItemView *lastItemView = [self.picArrs lastObject];
    
    if (lastItemView) {
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.bottom.equalTo(lastItemView);
            make.left.equalTo(lastItemView.mas_left).and.offset(50);
        }];
    }else{
        // 只存在增加按钮的情况
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.top.equalTo(self.addBtn.superview).and.offset(27);
            make.left.equalTo(@20);
        }];
    }
    self.addBtn.hidden = self.picArrs.count == MAXNUMBER ? YES : NO;
}
- (void)addTargetEvent{
    
    [UIAlertController showInViewController:self.window.rootViewController withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择", @"拍照"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = self.addBtn;
        popover.sourceRect = self.addBtn.bounds;
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if(buttonIndex == controller.cancelButtonIndex || buttonIndex == controller.destructiveButtonIndex) return ;
        buttonIndex -= 2;
        
        if (buttonIndex == 0) {
            [self openLocalPhoto];
            return;
        }
        [self takePhoto];
        
    }];
}

#pragma mark - 打开本地相册
-(void)openLocalPhoto{
    
    [[NSUserDefaults standardUserDefaults] setBool:[NSNumber numberWithBool:self.isUpdateImage] forKey:@"isUpdateImage"];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - 打开照相机 --
-(void)takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)setBillID:(NSString *)billID{
   
    _billID = billID;
   NSString *oldBilld = [[NSUserDefaults standardUserDefaults] objectForKey:@"yh_billd_key"];
    if (![oldBilld isEqualToString:billID]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:YHGetImageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // 缓存最新工单
    [[NSUserDefaults standardUserDefaults] setValue:billID forKey:@"yh_billd_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){

        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // 图片旋转
        image = [YHPhotoManger fixOrientation:image];
        
        dispatch_group_t group = dispatch_group_create();
       __block NSData * imageData = nil;
        __block NSString *imagePath = nil;
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            // 压缩图片
            imageData = [self compressImageQuality:image toKByte:600 queueGroup:group];
                // 更新图片
            if (self.isUpdateImage) {
                
                 dispatch_group_enter(group);
                NSString *upadtePath = self.item.imagePath;
                [self.fileManager createFileAtPath:upadtePath contents:imageData attributes:nil];
                 dispatch_group_leave(group);
                
            }else{ // 新增图片
                 dispatch_group_enter(group);
               NSLock *lock = [[NSLock alloc] init];
                [lock lock];
                self.imageNumber++;
                if (self.imageNumber > MAXNUMBER) {
                    [picker dismissViewControllerAnimated:YES completion:nil];
                    self.imageNumber = MAXNUMBER;
                    return;
                }
                [lock unlock];
                //将图片放在沙盒的documents文件夹中
                NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *imageName = [NSString stringWithFormat:@"image_%@_%ld.png",self.billID,self.imageNumber];
                imagePath = [DocumentsPath stringByAppendingPathComponent:imageName];
                [self.imagePathArr addObject:imagePath];
                
                //把刚刚图片转换的data对象拷贝至沙盒中
                [self.fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                [self.fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                dispatch_group_leave(group);
            }
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            imagePath = !imagePath ? @"" : imagePath;
            if (self.isUpdateImage) {
                    //  更换图片
                self.item.imageV.image = image;
                [picker dismissViewControllerAnimated:YES completion:^{
                    self.isUpdateImage = NO;
                }];
            }else{ // 新增图片
                [self addPictureImageView:image imagePath:imagePath];
                [picker dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:self.imagePathArr forKey:YHGetImageKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
            }
        });
    }
}

#pragma mark - 图片压缩 --
- (NSData *)compressImageQuality:(UIImage *)image toKByte:(NSInteger)kb queueGroup:(dispatch_group_t)group{
    
     dispatch_group_enter(group);
    
    if (image.size.width > 1080) {
        image = [self compressOriginalImage:image toSize:CGSizeMake(1080, 1080 * image.size.height / image.size.width)];
    }
    kb *= 1000;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1000.0f);
     dispatch_group_leave(group);
    return imageData;
}
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * resultImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

#pragma mark - 保存图片到相册完成回调 ---
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
     [MBProgressHUD showSuccess:@"已保存图片到系统相册" toView:self.window];
}
#pragma mark - 增加图片 --
- (void)addPictureImageView:(UIImage *)image imagePath:(NSString *)path{
    
    if (image == nil) {
        return;
    }
    
    if (self.picArrs.count > MAXNUMBER - 1) {
        return;
    }
    
    YHImageItemView *lastItemView = [self.picArrs lastObject];
    YHImageItemView *itemView = [[YHImageItemView alloc] initWithImageItemViewClearnBlock:^(YHImageItemView *item) {
        [self clickClearnBtnHandle:item];
    } tapImageViewBlock:^(YHImageItemView *item) {
        
        [self tapImageViewGesture:item];
    }];
    itemView.imagePath = path;
    itemView.imageV.image = image;
    [self addSubview:itemView];
    
    if (!lastItemView) {
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(47, 47));
            make.top.equalTo(itemView.superview).and.offset(20);
            make.left.equalTo(itemView.superview).and.offset(20);
        }];
        [self.picArrs addObject:itemView];
        
        
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.bottom.equalTo(itemView);
            make.left.equalTo(itemView.mas_right).and.offset(3);
        }];
        return;
    }
    
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(lastItemView);
        make.top.equalTo(lastItemView);
        make.left.equalTo(lastItemView.mas_right).and.offset(3);
    }];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.bottom.equalTo(itemView);
        make.left.equalTo(itemView.mas_right).and.offset(3);
    }];
    
    [self.picArrs addObject:itemView];
    [self.arrImage addObject:image];
    self.addBtn.hidden = self.picArrs.count == MAXNUMBER ? YES : NO;
    
}
@end
