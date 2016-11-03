//
//  SEQWaterWaveView.h
//  SEQColumnChart
//
//  Created by ervin on 16/11/3.
//  Copyright © 2016年 ervin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEQWaterWaveView : UIView
@property (nonatomic, strong)   UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, strong)   UIColor *secondWaveColor;   // 第二个波浪颜色

@property (nonatomic, assign)   CGFloat percent;            // 百分比

@property (nonatomic, assign)   CGFloat waveCycle;      // 波纹周期
@property (nonatomic, assign)   CGFloat waveSpeed;      // 波纹速度
@property (nonatomic, assign)   CGFloat waveGrowth;     // 波纹上升速度


-(void) startWave;
-(void) stopWave;
-(void) reset;
@end
