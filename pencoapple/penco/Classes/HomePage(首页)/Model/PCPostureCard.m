//
//  PCPostureCard.m
//  penco
//
//  Created by Zhu Wensheng on 2019/10/14.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCPostureCard.h"
#import "YHTools.h"


@interface PCPostureCard ()
@property (nonatomic, copy) NSString *direction;//方向
@property (nonatomic, copy) NSString *key;//
@end

@implementation PCPostureCard

-(UIImage *)regionImg{//局部图
    if (!self.img) {
        return nil;
    }
    if (self.imgCut) {
        return self.imgCut;
    }
    //    [self performSelector:@selector(lateralhead:) withObject:self.point];
    if ([@"lateralhead" isEqualToString:self.key]) {
        
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self lateralhead:self.point]];
        return self.imgCut;
    }
    if ([@"unevenshoulder" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self unevenshoulder:self.point]];
        return self.imgCut;
    }
    if ([@"scoliosis" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self scoliosis:self.point]];
        return self.imgCut;
    }
    if ([@"unevenhip" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self unevenhip:self.point]];
        return self.imgCut;
    }
    if ([@"xleg" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self xleg:self.point]];
        return self.imgCut;
    }
    if ([@"oleg" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self oleg:self.point]];
        return self.imgCut;
    }
    if ([@"xoleg" isEqualToString:self.key]) {
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self xoleg:self.point]];
        return self.imgCut;
    }
    if ([@"forwardhead" isEqualToString:self.key]) {//侧面
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self forwardhead:self.point  side:self.side]];
        return self.imgCut;
    }
    if ([@"roundedshoulder" isEqualToString:self.key]) {//侧面
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self roundedshoulder:self.point side:self.side]];
        return self.imgCut;
    }
    if ([@"kneehyperextension" isEqualToString:self.key]) {//侧面
        self.imgCut = [YHTools imageFromImage:self.img inRect:[self kneehyperextension:self.point  side:self.side]];
        return self.imgCut;
    }
    
    return nil;
}

-(NSString *)detailUrl{//二级界面url
    return [NSString stringWithFormat:@"%@%@/%@", self.postureDetailsPage, self.key, @{@"" : @0,@"left" : @1,@"right" : @2}[self.direction]];
}

-(NSString *)imgUrl
{//示意图url
    return [PCPostureCard mapsUrl:self];
}

// 头部侧倾
-(CGRect)lateralhead:(NSDictionary*)point{
    CGRect center = CGRectZero;
    CGFloat side = fabs(((NSNumber*)point[@"neck"][@"y"]).floatValue - ((NSNumber*)point[@"nose"][@"y"]).floatValue) * 1.4;
    center.size = CGSizeMake(side, side);
    center.origin.x = fabs(((NSNumber*)point[@"neck"][@"x"]).floatValue + ((NSNumber*)point[@"nose"][@"x"]).floatValue) / 2 - (side / 2);
    center.origin.y = fabs(((NSNumber*)point[@"neck"][@"y"]).floatValue + ((NSNumber*)point[@"nose"][@"y"]).floatValue) / 2 - (side / 2);
    return center;
}

// 高低肩
-(CGRect)unevenshoulder:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"neck"][@"y"]).floatValue - ((NSNumber*)point[@"nose"][@"y"]).floatValue) * 1.6;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = ((NSNumber*)point[@"neck"][@"x"]).floatValue - (side / 2);
    center.origin.y = ((NSNumber*)point[@"neck"][@"y"]).floatValue - (side / 2);
//    center.side = Math.abs(point.neck.y - point.nose.y) * 1.6
//    center.x = point.neck.x - (center.side / 2)
//    center.y = point.neck.y - (center.side / 2)
    return center;
}

// 脊椎异位
-(CGRect)scoliosis:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"neck"][@"y"]).floatValue - ((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue) * 1.3;
    center.size = CGSizeMake(side, side);
    center.origin.x = fabs(((NSNumber*)point[@"neck"][@"x"]).floatValue  + (((NSNumber*)point[@"hip"][@"left"][@"x"]).floatValue + ((NSNumber*)point[@"hip"][@"right"][@"x"]).floatValue) / 2) / 2 - (side / 2);
    center.origin.y = fabs(((NSNumber*)point[@"neck"][@"y"]).floatValue  + (((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue + ((NSNumber*)point[@"hip"][@"right"][@"y"]).floatValue) / 2) / 2 - (side / 2);
//    center.side = Math.abs(point.neck.y - point.hip.left.y) * 1.3
//    center.x = Math.abs(point.neck.x + (point.hip.left.x + point.hip.right.x) / 2) / 2 - (center.side / 2)
//    center.y = Math.abs(point.neck.y + (point.hip.left.y + point.hip.right.y) / 2) / 2 - (center.side / 2)
    return center;
}

// 骨盆侧倾
-(CGRect)unevenhip:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"hip"][@"left"][@"x"]).floatValue - ((NSNumber*)point[@"hip"][@"right"][@"x"]).floatValue) * 2;
    center.size = CGSizeMake(side, side);
    center.origin.x = fabs((((NSNumber*)point[@"hip"][@"left"][@"x"]).floatValue + ((NSNumber*)point[@"hip"][@"right"][@"x"]).floatValue) / 2) - (side / 2);
    center.origin.y = fabs((((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue + ((NSNumber*)point[@"hip"][@"right"][@"y"]).floatValue) / 2) - (side / 2);
//    center.side = Math.abs(point.hip.left.x - point.hip.right.x) * 2
//    center.x = Math.abs((point.hip.left.x + point.hip.right.x) / 2) - (center.side / 2)
//    center.y = Math.abs((point.hip.left.y + point.hip.right.y) / 2) - (center.side / 2)
    return center;
}

// X型腿
-(CGRect)xleg:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue - ((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue) * 1.6;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = fabs((((NSNumber*)point[@"knee"][@"left"][@"x"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"x"]).floatValue) / 2) - (side / 2);
    center.origin.y = fabs((((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"y"]).floatValue) / 2) - (side / 2);
//    center.side = Math.abs(point.hip.left.y - point.knee.left.y) * 1.6
//    center.x = Math.abs((point.knee.left.x + point.knee.right.x) / 2) - (center.side / 2)
//    center.y = Math.abs((point.knee.left.y + point.knee.right.y) / 2) - (center.side / 2)
    return center;
}

// O型腿
-(CGRect)oleg:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue - ((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue) * 1.6;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = fabs((((NSNumber*)point[@"knee"][@"left"][@"x"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"x"]).floatValue) / 2) - (side / 2);
    center.origin.y = fabs((((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"y"]).floatValue) / 2) - (side / 2);
//    center.side = Math.abs(point.hip.left.y - point.knee.left.y) * 1.6
//    center.x = Math.abs((point.knee.left.x + point.knee.right.x) / 2) - (center.side / 2)
//    center.y = Math.abs((point.knee.left.y + point.knee.right.y) / 2) - (center.side / 2)
    return center;
}

// XO型腿
-(CGRect)xoleg:(NSDictionary*)point{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"hip"][@"left"][@"y"]).floatValue - ((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue) * 1.6;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = fabs((((NSNumber*)point[@"knee"][@"left"][@"x"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"x"]).floatValue) / 2) - (side / 2);
    center.origin.y = fabs((((NSNumber*)point[@"knee"][@"left"][@"y"]).floatValue + ((NSNumber*)point[@"knee"][@"right"][@"y"]).floatValue) / 2) - (side / 2);
//    center.side = Math.abs(point.hip.left.y - point.knee.left.y) * 1.6
//    center.x = Math.abs((point.knee.left.x + point.knee.right.x) / 2) - (center.side / 2)
//    center.y = Math.abs((point.knee.left.y + point.knee.right.y) / 2) - (center.side / 2)
    return center;
}

// 头部前倾
-(CGRect)forwardhead:(NSDictionary*)point side:(NSString*)sideDirection{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"ear"][sideDirection][@"y"]).floatValue - ((NSNumber*)point[@"shoulder"][sideDirection][@"y"]).floatValue) * 2.;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = fabs((((NSNumber*)point[@"ear"][sideDirection][@"x"]).floatValue + ((NSNumber*)point[@"shoulder"][sideDirection][@"x"]).floatValue) / 2 - (side / 2));
    center.origin.y = fabs((((NSNumber*)point[@"ear"][sideDirection][@"y"]).floatValue + ((NSNumber*)point[@"shoulder"][sideDirection][@"y"]).floatValue) / 2 - (side / 2));
//    center.side = Math.abs(point.ear.right.y + point.shoulder.right.y) * 0.4
//    center.x = Math.abs((point.ear.right.x + point.shoulder.right.x) / 2 - (center.side / 2))
//    center.y = Math.abs((point.ear.right.y + point.shoulder.right.y) / 2 - (center.side / 2))
    return center;
}

// 圆肩
-(CGRect)roundedshoulder:(NSDictionary*)point side:(NSString*)sideDirection{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"ear"][sideDirection][@"y"]).floatValue - ((NSNumber*)point[@"shoulder"][sideDirection][@"y"]).floatValue) * 1.6;
    center.size = CGSizeMake(side, side);
    
    center.origin.x = fabs(((NSNumber*)point[@"shoulder"][sideDirection][@"x"]).floatValue - (side / 2));
    center.origin.y = fabs(((NSNumber*)point[@"shoulder"][sideDirection][@"y"]).floatValue - (side / 2));
//    center.side = Math.abs(point.ear.right.y - point.shoulder.right.y) * 1.6
//    center.x = Math.abs(point.shoulder.right.x - (center.side / 2))
//    center.y = Math.abs(point.shoulder.right.y - (center.side / 2))
    return center;
}

// 膝过伸
-(CGRect)kneehyperextension:(NSDictionary*)point side:(NSString*)sideDirection{
    CGRect center = CGRectZero;
    
    CGFloat side = fabs(((NSNumber*)point[@"hip"][sideDirection][@"y"]).floatValue - ((NSNumber*)point[@"ankle"][sideDirection][@"y"]).floatValue) * 1.1;
    center.size = CGSizeMake(side, side);
    center.origin.x = fabs(((NSNumber*)point[@"knee"][sideDirection][@"x"]).floatValue - (side / 2));
    center.origin.y = fabs(((NSNumber*)point[@"knee"][sideDirection][@"y"]).floatValue - (side / 2));
//    center.side = Math.abs(point.hip.right.y - point.ankle.right.y) * 1.1
//    center.x = Math.abs(point.knee.right.x - (center.side / 2))
//    center.y = Math.abs(point.knee.right.y - (center.side / 2))
    return center;
}


+(NSString*)mapsUrl:(PCPostureCard*)postureCard{
    //风险key值    风险方向（0：无；1：左；2：右）    风险级别（1：正常；2：轻微；3：严重）
    
    NSDictionary *urlMaps = @{
                              @"lateralhead" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lateralhead.png",
                              @"lateralhead01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lateralhead.png",
                              @"lateralhead12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_lateralhead.png",
                              @"lateralhead13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_lateralhead.png",
                              @"lateralhead22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_lateralhead.png",
                              @"lateralhead23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_lateralhead.png",
                              @"unevenshoulder" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/unevenshoulder.png",
                              @"unevenshoulder01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/unevenshoulder.png",
                              @"unevenshoulder12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_unevenshoulder.png",
                              @"unevenshoulder13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_unevenshoulder.png",
                              @"unevenshoulder22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_unevenshoulder.png",
                              @"unevenshoulder23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_unevenshoulder.png",
                              @"scoliosis" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/scoliosis.png",
                              @"scoliosis01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/scoliosis.png",
                              @"scoliosis12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_scoliosis.png",
                              @"scoliosis13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_scoliosis.png",
                              @"scoliosis22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_scoliosis.png",
                              @"scoliosis23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_scoliosis.png",
                              @"unevenhip" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/unevenhip.png",
                              @"unevenhip01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/unevenhip.png",
                              @"unevenhip12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_unevenhip.png",
                              @"unevenhip13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_unevenhip.png",
                              @"unevenhip22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_unevenhip.png",
                              @"unevenhip23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_unevenhip.png",
                              @"oleg" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_oleg.png",
                              @"oleg12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_oleg.png",
                              @"oleg13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_oleg.png",
                              @"oleg22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_oleg.png",
                              @"oleg23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_oleg.png",
                              @"xleg" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_xleg.png",
                              @"xleg12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_xleg.png",
                              @"xleg13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_xleg.png",
                              @"xleg22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_xleg.png",
                              @"xleg23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_xleg.png",
                              @"xoleg" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_xoleg.png",
                              @"xoleg12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_xoleg.png",
                              @"xoleg13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_xoleg.png",
                              @"xoleg22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_xoleg.png",
                              @"xoleg23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_xoleg.png",
                              @"forwardhead" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/forwardhead.png",
                              @"forwardhead01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/forwardhead.png",
                              @"forwardhead02" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/m_forwardhead.png",
                              @"forwardhead03" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/s_forwardhead.png",
                              @"forwardhead11" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/l_forwardhead.png",
                              @"forwardhead12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_forwardhead.png",
                              @"forwardhead13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_forwardhead.png",
                              @"forwardhead21" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/r_forwardhead.png",
                              @"forwardhead22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_forwardhead.png",
                              @"forwardhead23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_forwardhead.png",
                              @"roundedshoulder" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/roundedshoulder.png",
                              @"roundedshoulder01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/roundedshoulder.png",
                              @"roundedshoulder02" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/m_roundedshoulder.png",
                              @"roundedshoulder03" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/s_roundedshoulder.png",
                              @"roundedshoulder11" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/l_roundedshoulder.png",
                              @"roundedshoulder12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_roundedshoulder.png",
                              @"roundedshoulder13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_roundedshoulder.png",
                              @"roundedshoulder21" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/r_roundedshoulder.png",
                              @"roundedshoulder22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_roundedshoulder.png",
                              @"roundedshoulder23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_roundedshoulder.png",
                              @"kneehyperextension" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/kneehyperextension.png",
                              @"kneehyperextension01" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/kneehyperextension.png",
                              @"kneehyperextension02" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/m_kneehyperextension.png",
                              @"kneehyperextension03" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/s_kneehyperextension.png",
                              @"kneehyperextension11" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/l_kneehyperextension.png",
                              @"kneehyperextension12" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/lm_kneehyperextension.png",
                              @"kneehyperextension13" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/ls_kneehyperextension.png",
                              @"kneehyperextension21" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/r_kneehyperextension.png",
                              @"kneehyperextension22" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rm_kneehyperextension.png",
                              @"kneehyperextension23" : @"https://insole-1255704943.cos.ap-hongkong.myqcloud.com/production/disease/rs_kneehyperextension.png"
                              };
    
    NSString *direction = @{@"" : @"0", @"left" : @"1", @"right" : @"2"}[postureCard.direction];
    NSString *level = @{@"normal" : @"1", @"mild" : @"2", @"severe" : @"3"}[postureCard.level];
    NSString *key = [NSString stringWithFormat:@"%@%@%@", postureCard.key, direction, level];
    if (![urlMaps objectForKey:key]) {
        return [urlMaps objectForKey:postureCard.key];
    }
    return [urlMaps objectForKey:key];
}
@end
