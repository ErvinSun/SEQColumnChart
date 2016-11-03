//
//  SEQColumnChart.m
//  SEQColumnChart
//
//  Created by ervin on 16/11/3.
//  Copyright © 2016年 ervin. All rights reserved.
//

#import "SEQColumnChart.h"
#import "SEQWaterColumn.h"
@interface SEQColumnChart ()
//背景图
@property (nonatomic,strong)UIScrollView *BGScrollView;

//峰值
@property (nonatomic,assign) CGFloat maxHeight;

//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;
@end
@implementation SEQColumnChart
#pragma mark -------属性懒加载-----
-(NSMutableArray *)showViewArr{
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    return _showViewArr;
}
-(NSMutableArray *)layerArr{
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}
-(UIScrollView *)BGScrollView{
    if (!_BGScrollView) {
        _BGScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
        _bgVewBackgoundColor = [UIColor lightGrayColor];
        [self addSubview:_BGScrollView];
    }
    return _BGScrollView;
}
-(NSMutableArray *)yLineDataArr{
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
}
#pragma mark ------正文-------
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _needXandYLine = YES;
    }
    return self;
}

/**
 数据源数组

 @param valueArr 数据源数组
 */
-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    _valueArr = valueArr;
    CGFloat max = 0;
    for (NSArray *arr in _valueArr) {
        for (id sender in arr) {
            CGFloat currentNumber = [NSString stringWithFormat:@"%@",sender].floatValue;
            if (currentNumber > max) {
                max = currentNumber;
            }
        }
    }
    if (max<5.0) {
        _maxHeight = 5.0;
    }else if(max<10){
        _maxHeight = 10;
    }else{
        _maxHeight = max;
    }
}
-(void)showAnimation{
    [self clear];
    
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + _typeSpace + 40;
    self.BGScrollView.contentSize = CGSizeMake(_maxWidth, 0);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    [self drawXYRect];
    [self drawnfoTextRect];
    [self animationShow];
}

/**
 绘制X、Y轴  可以在此改动X、Y轴字体大小
 */
-(void)drawXYRect{
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
        
        [bezier addLineToPoint:P_M(self.originSize.x, 20)];
        
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
        
        [bezier addLineToPoint:P_M(_maxWidth , CGRectGetHeight(self.frame) - self.originSize.y)];
        
        
        layer.path = bezier.CGPath;
        
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = 1.5;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
        
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<5; i++) {
            
            CGFloat height = (CGRectGetHeight(self.frame) - _originSize.y - 30)/5 * (i+1);
            [second moveToPoint:P_M(_originSize.x, CGRectGetHeight(self.frame) - _originSize.y -height)];
            [second addLineToPoint:P_M(_maxWidth, CGRectGetHeight(self.frame) - _originSize.y - height)];
            
            CATextLayer *textLayer = [CATextLayer layer];
            NSInteger pace = _maxHeight / 5;
            NSString *text =[NSString stringWithFormat:@"%ld",(i + 1) * pace];
            CGFloat be = [self getTextWithWhenDrawWithText:text];
            textLayer.frame = CGRectMake(self.originSize.x - be - 3, CGRectGetHeight(self.frame) - _originSize.y -height - 5, be, 15);
            
            UIFont *font = [UIFont systemFontOfSize:7];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = text;
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];
            
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = second.CGPath;
        
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor greenColor].CGColor):_dashColor.CGColor);
        
        shapeLayer.lineWidth = 0.5;
        
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic2.duration = 1.5;
        
        basic2.fromValue = @(0);
        
        basic2.toValue = @(1);
        
        basic2.autoreverses = NO;
        
        
        
        basic2.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:basic2 forKey:nil];
        
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
    }
}

/**
 绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有
 */
-(void)drawnfoTextRect{
    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    if (_xShowInfoText.count == _valueArr.count&&_xShowInfoText.count>0) {
        
        NSInteger count = [_valueArr[0] count];
        
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            CATextLayer *textLayer = [CATextLayer layer];
            
            CGFloat wid =  count * _columnWidth;
            CGSize size = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
            
            textLayer.frame = CGRectMake( i * (count * _columnWidth + _typeSpace) + _typeSpace + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
            textLayer.string = _xShowInfoText[i];
            
            UIFont *font = [UIFont systemFontOfSize:9];
            
            textLayer.fontSize = font.pointSize;
            
            textLayer.foregroundColor = _drawTextColorForX_Y.CGColor;
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            
            [_BGScrollView.layer addSublayer:textLayer];
            
            //            CGFontRelease(fontRef);
            [self.layerArr addObject:textLayer];
        }
    }
}

/**
  动画展示 
 */
-(void)animationShow{
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        NSArray *arr = _valueArr[i];
        for (NSInteger j = 0; j<arr.count; j++) {
//            CGFloat height = [NSString stringWithFormat:@"%@",arr[j]].floatValue/_maxHeight * (CGRectGetHeight(self.frame) - 30 -   _originSize.y-1);
            
            SEQWaterColumn *waveProgressView = [[SEQWaterColumn alloc]initWithFrame:CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace + 2*j, CGRectGetHeight(self.frame) - _originSize.y-1 - (CGRectGetHeight(self.frame) - _originSize.y - 30), _columnWidth, (CGRectGetHeight(self.frame) - _originSize.y - 30))];
            waveProgressView.percent = [NSString stringWithFormat:@"%@",arr[j]].floatValue/100;
            [waveProgressView startWave];

            [self.showViewArr addObject:waveProgressView];
            [self.BGScrollView addSubview:waveProgressView];
        }
    }
}
-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]} context:nil].size;
    
    return size.width;
}
@end
