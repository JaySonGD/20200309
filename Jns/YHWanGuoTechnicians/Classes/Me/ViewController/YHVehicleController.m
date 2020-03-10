//
//  YHVehicleController.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/4/24.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHVehicleController.h"
#import "YHAssignTechnicianController.h"
#import "YHCommon.h"
#import "YHTools.h"
@interface YHVehicleController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtonS;
- (IBAction)upBack:(id)sender;
- (IBAction)reSetAction:(id)sender;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *menuButtonLC;
@property (nonatomic)NSInteger indexSel;
- (IBAction)menuButtonActions:(id)sender;
@property (strong, nonatomic)NSMutableArray *flags;
@property (weak, nonatomic) IBOutlet UIImageView *checkCarIG;
@property (strong, nonatomic)NSMutableArray *drawFlags;
@end

@implementation YHVehicleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawFlags = [@[]mutableCopy];
    self.flags = [@[]mutableCopy];
    // Do any additional setup after loading the view.
    [_scrollV addSubview:_contentView];
    [_scrollV setContentSize:_contentView.frame.size];
    [self menuButtonActions:_menuButtonS[0]];
   
    _checkCarIG.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_checkCarIG addGestureRecognizer:singleTap];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    

    
    CGPoint nowPoint = [gestureRecognizer locationInView:_checkCarIG];
    NSLog(@"%f %f", nowPoint.x, nowPoint.y);
    CGRect frame =  _contentView.frame;
    NSString *icon = @[@"icon-youpenqi iconfont",@"icon-yousecha iconfont",@"icon-banjinxiufu iconfont",@"icon-huahen iconfont",@"icon-fugaijiangenghuan iconfont",@"icon-kejianshang iconfont"][_indexSel];
    ;
    //do something....
    
//    {icon:icon-yousecha iconfont,top:15.302491103202847%,left:31.70731707317073%}
    NSString *value =  [NSString stringWithFormat:@"{icon:%@,top:%@,left:%@}", icon,[NSString stringWithFormat:@"%.2f%%", nowPoint.y * 100 / frame.size.height], [NSString stringWithFormat:@"%.2f%%", (frame.size.width - nowPoint.x) * 100 / frame.size.width]];
    
    [_flags addObject:value];
    [_drawFlags addObject:[self flagDrawX:nowPoint.x Y:nowPoint.y menuIndex:_indexSel]];
}

- (UIImageView*)flagDrawX:(float)x Y:(float)y menuIndex:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"checkCar_%ld", (long)index + 1]]];
    imageView.frame = CGRectMake(0, 0, 22, 22);
    imageView.center = CGPointMake(x, y);//XY数据和PC的正好相反，因为图片右旋转90度了
    [_contentView addSubview:imageView];
    return imageView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"assgin"]) {
        
        YHAssignTechnicianController * controller =segue.destinationViewController;
        controller.orderInfo = self.orderInfo;
    }
}


- (IBAction)menuButtonActions:(UIButton*)button {
    self.indexSel = button.tag;
    [_menuButtonS enumerateObjectsUsingBlock:^(UIButton *menuB, NSUInteger idx, BOOL * _Nonnull stop) {
       NSLayoutConstraint *menuLC =  _menuButtonLC[idx];
        menuLC.constant = -40;
        menuB.layer.borderWidth = 1;
        menuB.layer.borderColor = YHCellColor.CGColor;
        menuB.backgroundColor = [UIColor whiteColor];
        [menuB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuB setImage:nil forState:UIControlStateNormal];
    }];
    
    NSLayoutConstraint *menuLC =  _menuButtonLC[_indexSel];
    menuLC.constant= - 25;
    button.backgroundColor = YHNaviColor;
    button.layer.borderColor = YHNaviColor.CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@[@"checkCar_11",@"checkCar_12",@"checkCar_7",@"checkCar_10",@"checkCar_8",@"checkCar_9"][_indexSel]] forState:UIControlStateNormal];
}

- (IBAction)upBack:(id)sender {
    [_flags removeLastObject];
    UIView *view = [_drawFlags lastObject];
    [view removeFromSuperview];
    [_drawFlags removeLastObject];
}

- (IBAction)reSetAction:(id)sender {
    [_flags removeAllObjects];
    [_drawFlags enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
    [_drawFlags removeAllObjects];
}
@end
