//
//  HHSnowView.m
//  测试3
//
//  Created by 蔡浩浩 on 15/7/21.
//  Copyright (c) 2015年 蔡浩浩. All rights reserved.
//

#import "HHSnowView.h"
#define  SCREENW [UIScreen mainScreen].bounds.size.width
@interface HHSnowView ()
@property (strong,nonatomic)CADisplayLink *link;
@end

@implementation HHSnowView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    
    [self setUp];
}

- (void)setUp{
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    _link = link;
    
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"snowbg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:imageView];
    
}


- (void)drawRect:(CGRect)rect {
    
    
    static int x = 0;
    
    if(x%10==0){
    
        int i = arc4random_uniform(SCREENW);
        int j = arc4random_uniform(SCREENW);
        
        //创建layer
        CALayer *myLayer = [CALayer layer];
        myLayer.position = CGPointMake(i, -20);
        myLayer.bounds = CGRectMake(i, 0, 20, 20);
        myLayer.contents = (__bridge id)([UIImage imageNamed:@"雪花"].CGImage);
        
        //路径
        CAKeyframeAnimation *keyA = [CAKeyframeAnimation animation];
        UIBezierPath *path = [UIBezierPath bezierPath];
        keyA.keyPath = @"position";
        [path moveToPoint:CGPointMake(i, 0)];
        [path addLineToPoint:CGPointMake(j ,self.bounds.size.height)];
        keyA.duration = 10;
        keyA.path = path.CGPath;
        
        
        //旋转
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation";
        animation.toValue = @(M_PI*2);
        animation.repeatCount = MAXFLOAT;
        animation.duration = 5;
        
        //透明度
        CABasicAnimation *basic = [CABasicAnimation animation];
        basic.keyPath = @"opacity";
        basic.toValue = @0.3;
        basic.repeatCount = MAXFLOAT;
        basic.duration = 10;
        
        
        [self.layer addSublayer:myLayer];
        [myLayer addAnimation:keyA forKey:nil];
        [myLayer addAnimation:animation forKey:nil];
        [myLayer addAnimation:basic forKey:nil];
        NSLog(@"%ld",self.layer.sublayers.count);
        
        
    }
    
    if (self.layer.sublayers.count>100) {
        
        [self.layer.sublayers[5] removeFromSuperlayer];
        
    }
    
    x++;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    self.link.paused = !self.link.paused;
}

@end
