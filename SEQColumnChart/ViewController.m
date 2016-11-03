//
//  ViewController.m
//  SEQColumnChart
//
//  Created by ervin on 16/11/3.
//  Copyright © 2016年 ervin. All rights reserved.
//

#import "ViewController.h"
#import "SEQColumnChart.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*        创建对象         */
    SEQColumnChart *column = [[SEQColumnChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, 300)];
    /*        创建数据源数组 每个数组即为一个模块数据 例如第一个数组可以表示某个班级的不同科目的平均成绩 下一个数组表示另外一个班级的不同科目的平均成绩         */
    column.valueArr = @[
                        @[@12,@22,@33],
                        @[@22,@22,@33]
                        
                        ];
    /*       该点 表示原点距左下角的距离         */
    column.originSize = CGPointMake(30, 30);
    
    /*        第一个柱状图距原点的距离         */
    column.drawFromOriginX = 10;
    /*        两组柱状图间距         */
    column.typeSpace = 30;
    /*        柱状图的宽度         */
    column.columnWidth = 25;
    /*        X、Y轴字体颜色         */
    column.drawTextColorForX_Y = [UIColor whiteColor];
    /*        X、Y轴线条颜色         */
    column.colorForXYLine = [UIColor whiteColor];
    
    /*        模块的提示语         */
    column.xShowInfoText = @[@"A班级",@"B班级"];
    /*        开始动画         */
    [column showAnimation];
    [self.view addSubview:column];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
