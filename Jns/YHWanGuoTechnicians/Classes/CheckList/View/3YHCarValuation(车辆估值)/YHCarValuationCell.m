//
//  YHCarValuationCell.m
//  YHWanGuoTechnicians
//
//  Created by mwf on 2018/9/7.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHCarValuationCell.h"

@implementation YHCarValuationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.referencePriceView.layer.borderColor = [YHColor(233, 233, 233) CGColor];
    self.referencePriceView.layer.borderWidth = 1.0f;
    self.alreadySetView.layer.borderColor = [YHColor(233, 233, 233) CGColor];
    self.alreadySetView.layer.borderWidth = 1.0f;
    self.reportQRCodeView.layer.borderColor = [YHColor(233, 233, 233) CGColor];
    self.reportQRCodeView.layer.borderWidth = 1.0f;
}

- (void)refreshUIWithModel:(YHCarValuationModel *)model isPush:(BOOL)isPush controller:(UIViewController *)controller shareBtn:(UIButton *)shareBtn pushBtn:(UIButton *)pushBtn{
    self.setCarPriceTextField.delegate = self;
    self.shareBtn = shareBtn;
    self.pushBtn = pushBtn;
    
    if ([model.minPrice isEqualToString:@"0.00"] && [model.maxPrice isEqualToString:@"0.00"]) {
        self.referencePriceLabel.text = @"未获取到估值价格";
    } else {
        if ([model.minPrice isEqualToString:model.maxPrice]) {
            self.referencePriceLabel.text = [NSString stringWithFormat:@"%@万",model.minPrice];
        }else{
            self.referencePriceLabel.text = [NSString stringWithFormat:@"%@万  到  %@万",model.minPrice,model.maxPrice];
        }
    }
    
    //未推送
    if (IsEmptyStr(model.price) || [model.price isEqualToString:@"0.00"]) {
        //未推送
        if (isPush == NO) {
            self.shareBtn.hidden = YES;
            self.setCarPriceView.hidden = NO;
            self.alreadySetView.hidden = YES;
            self.reportQRCodeView.hidden = YES;
            self.pushBtn.hidden = NO;
        //已推送
        } else {
            self.shareBtn.hidden = NO;
            self.setCarPriceView.hidden = YES;
            self.alreadySetView.hidden = NO;
            self.alreadySetPriceLabel.text = [NSString stringWithFormat:@"%@万",self.setCarPriceTextField.text];
            self.reportQRCodeView.hidden = NO;
            [self setImageWithImage:self.reportQRCodeImageView WithModel:model];
            self.pushBtn.hidden = YES;
        }
    //已推送
    }else{
        self.shareBtn.hidden = NO;
        self.setCarPriceView.hidden = YES;
        self.alreadySetView.hidden = NO;
        self.alreadySetPriceLabel.text = [NSString stringWithFormat:@"%@万",model.price];
        self.reportQRCodeView.hidden = NO;
        [self setImageWithImage:self.reportQRCodeImageView WithModel:model];
        self.pushBtn.hidden = YES;
    }
}

#pragma mark - -------------------------------------二维码生成------------------------------------------
/**
 * 根据链接生成对应二维码图片
 */
- (void)setImageWithImage:(UIImageView *)imageView WithModel:(YHCarValuationModel *)model {
    //1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //2.恢复滤镜的默认属性
    [filter setDefaults];
    
    //3.将字符串转换成NSData
    NSString *urlStr = model.reportUrl;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    //5.获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    //6.将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的方法重绘二维码)
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - ------------------------------------textField限制----------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.setCarPriceTextField ) {
        self.pushBtn.backgroundColor = YHNaviColor;
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            _isHaveDian = NO;
        }
        
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [MBProgressHUD showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [MBProgressHUD showError:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            [MBProgressHUD showError:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [MBProgressHUD showError:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.setCarPriceTextField) {
        if (textField.text.length == 0 ) {
            self.pushBtn.backgroundColor = YHBackgroundColor;
        }
    }
}

@end
