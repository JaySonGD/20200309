//
//  YHChooseView.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/5.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHChooseView.h"
#import "YHCarPhotoModel.h"

#import <Masonry/Masonry.h>
#import <UIButton+WebCache.h>

@interface YHOtherPhotoCell ()
@property (nonatomic, weak) UIButton *imageBtn;
@end
@implementation YHOtherPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:imageBtn];
        _imageBtn = imageBtn;
        _imageBtn.userInteractionEnabled = NO;
        
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.left.right.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end



@interface YHChooseView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray <UIButton *>*images;

@end

@implementation YHChooseView

+ (instancetype)chooseView{
    return [[NSBundle mainBundle] loadNibNamed:@"YHChooseView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.collectionView registerClass:[YHOtherPhotoCell class] forCellWithReuseIdentifier:@"cell"];
    CGFloat h = self.collectionView.bounds.size.height;
    self.layout.itemSize = CGSizeMake(h, h);
}
#pragma mark  -  get/set 方法
- (NSMutableArray<UIButton *> *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
        [_images addObject:self.btn0];
        [_images addObject:self.btn1];
        [_images addObject:self.btn2];
        [_images addObject:self.btn3];
        [_images addObject:self.btn4];
        [_images addObject:self.btn5];
        [_images addObject:self.btn6];
        [_images addObject:self.btn7];
        [_images addObject:self.btn8];
        [_images addObject:self.btn9];
    }
    return _images;
}
- (void)setModels:(NSArray<YHPhotoModel *> *)models
{
    _models = models;
    for (NSInteger i = 0; i < models.count; i++) {
        UIImage *image = models[i].image;
        NSURL *url = [NSURL URLWithString:models[i].url];
        !(image)? : ([self.images[i] setImage:image forState:UIControlStateNormal]);
        !(url)? : ([self.images[i] sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:image]);
        
        

    }
}

- (void)setOtherModels:(NSMutableArray<YHPhotoModel *> *)otherModels
{
    _otherModels = otherModels;
    [self.collectionView reloadData];
}

#pragma mark  -  事件监听
- (IBAction)choosePictureClick:(UIButton *)sender {
    !(_buttonClick)? : _buttonClick(sender);
}
- (IBAction)exampleClick:(UIButton *)sender {
    !(_exampleClick)? : _exampleClick(sender.tag);
}

#pragma mark  -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.otherModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHOtherPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    YHPhotoModel *model = self.otherModels[indexPath.item];
    UIImage *image = model.image? model.image : [UIImage imageNamed:@"otherAdd"];
    
    //[cell.imageBtn setImage:image forState:UIControlStateNormal];
    [cell.imageBtn sd_setImageWithURL:[NSURL URLWithString:model.url] forState:UIControlStateNormal placeholderImage:image];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !(_otherClick)? : _otherClick(indexPath.item,[collectionView cellForItemAtIndexPath:indexPath]);
}

@end
