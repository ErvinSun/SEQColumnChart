//
//  SEQWaterColumn.h
//  SEQColumnChart
//
//  Created by ervin on 16/11/3.
//  Copyright © 2016年 ervin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEQWaterColumn : UIView
@property (nonatomic,assign) CGFloat percent; // 0~1

- (void)startWave;

- (void)resetWave;
@end
