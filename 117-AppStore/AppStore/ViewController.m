//
//  ViewController.m
//  AppStore
//
//  Created by Jay on 14/1/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

#import "PresentAnimationDelegate.h"

#import "TableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** <##> */
@property (nonatomic, strong) NSArray <UIColor *> *colors;
/** <##> */
@property (nonatomic, strong) NSArray <NSString *> *imgNames;

/** <##> */
@property (nonatomic, strong) PresentAnimationDelegate *presentAnimationDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.presentAnimationDelegate = [PresentAnimationDelegate new];
    
    self.colors = @[[UIColor redColor],
                  [UIColor orangeColor],
                  [UIColor yellowColor],
                  [UIColor greenColor],
                  [UIColor blueColor],
                  [UIColor cyanColor],
                    [UIColor purpleColor]];
    
    self.imgNames = @[@"1",
                    @"2",
                    @"3",
                    @"4",
                    @"5",
                    @"6",
                    @"7"];


    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.tableView.showsVerticalScrollIndicator = NO;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor redColor];
    cell.iv.image = [UIImage imageNamed:self.imgNames[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell endAnimation];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell startAnimation];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    NextViewController *nextVC = [[NextViewController alloc] initWithColor:self.colors[indexPath.section] bgView:[self imageFromView]];
    nextVC.imgName = self.imgNames[indexPath.section];
    CGRect rect = [self.view convertRect:cell.frame fromView:cell.superview];

    __weak typeof(self) weakSelf = self;
    __weak typeof(NextViewController*) weakNextVC = nextVC;

    
    [self.presentAnimationDelegate animationWithPresented:self presenting:nextVC presentedAnimations:^(CompleteBlock completion,UIView *animationView){
        
        cell.alpha = 0.0;
        weakNextVC.bgView.alpha = 0.0;
        weakNextVC.view.backgroundColor = [UIColor clearColor];
        
        
        [UIView animateWithDuration:1 - 0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [animationView layoutIfNeeded];
            weakNextVC.contentView.layer.cornerRadius = 8.0;
            weakNextVC.contentView.layer.masksToBounds = YES;
            weakNextVC.backButton.alpha = 0.0;
            weakNextVC.contentView.frame = rect;
            weakNextVC.topView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            weakNextVC.topView.layer.cornerRadius = 8.0;
            weakNextVC.topView.layer.masksToBounds = YES;
            weakNextVC.listView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            cell.alpha = 1.0;
            completion(finished);
        }];
        
    } presentingAnimations:^(CompleteBlock completion,UIView *animationView) {
        
        
        weakNextVC.contentView.frame = rect;
        weakNextVC.contentView.layer.cornerRadius = 8.0;
        weakNextVC.contentView.layer.masksToBounds = YES;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            cell.contentView.hidden = YES;
            [animationView layoutIfNeeded];
            weakNextVC.contentView.frame = CGRectMake(30, 60, self.view.frame.size.width - 60, weakSelf.view.frame.size.height - 120);
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:1 - 0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [animationView layoutIfNeeded];
                weakNextVC.contentView.frame = self.view.frame;
                weakNextVC.contentView.layer.cornerRadius = 0.0;
                weakNextVC.contentView.layer.masksToBounds = YES;
                
            } completion:^(BOOL finished) {
                cell.contentView.hidden = NO;
                completion(finished);
            }];
        }];

        
    } complete:^(BOOL flag) {
        
    }];
    
}

- (UIImageView *)imageFromView{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = img;
    
    UIBlurEffect *effect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = imgView.bounds;
    [imgView addSubview:effectView];
    
    return imgView;
}

//var imageFromView: UIImageView {
//    UIGraphicsBeginImageContext(self.view.frame.size)
//    let context = UIGraphicsGetCurrentContext()
//    self.view.layer.render(in: context!)
//    let img = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//
//    let imgView = UIImageView.init(frame: self.view.bounds)
//    imgView.image = img
//
//    let effect = UIBlurEffect.init(style: .light)
//    let effectView = UIVisualEffectView.init(effect: effect)
//    effectView.frame = imgView.bounds
//    imgView.addSubview(effectView)
//
//    return imgView
//}
@end
