//
//  YHPortraitController.m
//  penco
//
//  Created by Jay on 19/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHPortraitController.h"
#import "YYImageClipViewController.h"

#import "YHTools.h"

#import <UIImageView+WebCache.h>

@interface YHPortraitController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,YYImageClipDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YHPortraitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStyleDone target:self action:@selector(addImage)];

    if(self.imageUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
//        return;
        
    }
    
    [self addImage:nil];
}
- (IBAction)addImage:(id)sender {
   UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSuccWith:YES];
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSuccWith:NO];
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)cannel:(id)sender {
    [self popViewController:sender];
}
- (IBAction)complete:(id)sender {
    !(_complete)? : _complete([YHTools base64FromImage:self.imageView.image]);
    [self popViewController:sender];
}

// 打开相机/相册
- (void)openSuccWith:(BOOL )isCamera{
    
    UIImagePickerController *photoPicker = [UIImagePickerController new];
    photoPicker.delegate = self;
    //photoPicker.allowsEditing = YES;
    
    if (isCamera) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    if (!isCamera) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:photoPicker animated:YES completion:nil];
}


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//
//    if ([mediaType isEqualToString:@"public.image"]) {
//        UIImage * image;
//        // 判断，图片是否允许修改
//        if ([picker allowsEditing]){
//            //获取用户编辑之后的图像
//            image = [info objectForKey:UIImagePickerControllerEditedImage];
//        } else {
//            // 照片的元数据参数
//            image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
//
//        self.imageView.image = image;
//
//
//        self.cannelBtn.hidden = NO;
//        self.completeBtn.hidden = NO;
//        // 压缩图片
//
//        // YHLog(@"%@",NSStringFromCGSize(compressImg.size));
//        // 用于上传
//        //NSData *tmpData = UIImageJPEGRepresentation(compressImg, 0.5);
//
//    }
//
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 200.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    self.imageView.image = editedImage;
    self.cannelBtn.hidden = NO;
    self.completeBtn.hidden = NO;

    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
