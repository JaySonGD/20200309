//
//  MonitorViewController.m
//  AAChartKitDemo
//
//  Created by 魏唯隆 on 2017/12/11.
//  Copyright © 2017年 Danny boy. All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 * 🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/7842508/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

#import "MonitorViewController.h"
#import "AAChartKit.h"

#define PostNum 18  // 柱状图行数，对应x轴数量

@interface MonitorViewController ()//<AAChartViewEventDelegate, UIGestureRecognizerDelegate>
{
    UIScrollView *_monitorScrollView;
}
@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configTheChartView:AAChartTypeColumn];
}
- (void)configTheChartView:(AAChartType)chartType {
    
    CGFloat w = ([self.obj.allValues count] > 6)? self.view.bounds.size.width/6.0 *[self.obj.allValues count] : self.view.bounds.size.width;
    
    _monitorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-34-100)];
    _monitorScrollView.bounces = NO;
    _monitorScrollView.contentSize = CGSizeMake(w, 0);
    _monitorScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_monitorScrollView];
    
    self.aaChartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 0,w, self.view.frame.size.height-34-100)];
    self.aaChartView.userInteractionEnabled = YES;
    self.aaChartView.contentHeight = self.view.frame.size.height-34-100;
    [_monitorScrollView addSubview:self.aaChartView];
    
    
    NSArray *list = [self.obj allValues];
    NSArray *result = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        
        return [obj2[@"all"] compare:obj1[@"all"]]; //升序
        
    }];
    
    NSArray *xs = [result valueForKeyPath:@"x"];
    NSArray *ons = [result valueForKeyPath:@"on"];
    NSArray *nos = [result valueForKeyPath:@"no"];
    NSArray *alls = [result valueForKeyPath:@"all"];

    
    self.aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)
    .titleSet(@"")
    .subtitleSet(@"")
    .categoriesSet(
                   xs
//  @[@"10/25",@"10/26",@"10/27",@"10/28",@"10/29",@"10/30",@"10/31",@"11/01",@"11/02",@"11/03",@"11/04",@"11/05",@"11/06",@"11/07"]
                   )
    .yAxisTitleSet(@"")
    .dataLabelsEnabledSet(true)
    .dataLabelsFontSizeSet(@14.0)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"上线")
                 .dataSet(ons),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"总共")
                 .dataSet(alls),

                 AAObject(AASeriesElement)
                 .nameSet(@"审核")
                 .dataSet(nos),
                 ]
               );
    
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
    
}
//#pragma mark -- AAChartView delegate
//-(void)AAChartViewDidFinishLoad {
//    NSLog(@"😊😊😊图表视图已完成加载=====");
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//
//-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
//    CGPoint gesturePoint = [sender locationInView:self.view];
//    NSLog(@"handleSingleTap--- x:%f,y:%f",gesturePoint.x,gesturePoint.y);
//
//    CGFloat xRallerWidth = _monitorScrollView.contentSize.width;
//
//    // 点击区域
//    CGFloat postWidth = (xRallerWidth - 60)/PostNum;
//    for (int i=0; i<PostNum; i++) {
//        if((gesturePoint.x + _monitorScrollView.contentOffset.x) >= (postWidth*i + 40) &&
//           (gesturePoint.x + _monitorScrollView.contentOffset.x) <= (postWidth*(i+1) + 40)){
//            NSLog(@"🖱点击了第%d行柱", i+1);
//        }
//    }
//}

@end
