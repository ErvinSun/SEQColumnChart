//
//  SEQWaterColumn.m
//  SEQColumnChart
//
//  Created by ervin on 16/11/3.
//  Copyright © 2016年 ervin. All rights reserved.
//

#import "SEQWaterColumn.h"
#import "SEQWaterWaveView.h"
@interface SEQWaterColumn ()
@property (nonatomic, weak) SEQWaterWaveView *waterWaveView;
@end
@implementation SEQWaterColumn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6];
        self.layer.cornerRadius = 2;
    }
    return self;
}
- (void)setupView
{
    SEQWaterWaveView *waterWaveView = [[SEQWaterWaveView alloc]init];
    waterWaveView.firstWaveColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6];
    waterWaveView.secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:0.8];
    [self addSubview:waterWaveView];
    _waterWaveView = waterWaveView;
}

- (void)startWave
{
    if (_percent > 0) {
        _waterWaveView.percent = _percent;
        [_waterWaveView startWave];
    }else{
        [self resetWave];
    }
}
- (void)resetWave
{
    [_waterWaveView reset];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    _waterWaveView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    
    _waterWaveView.layer.cornerRadius = 1;
}

@end
