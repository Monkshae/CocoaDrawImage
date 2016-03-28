//
//  FirstView.m
//  CocoaDrawImage
//
//  Created by Mabye on 13-12-23.
//  Copyright (c) 2013年 Maybe. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
# if 0
    
#if 0
    //一个紫色的圆圈，使用UIKit来绘制到Cocoa已经准备好的当前上下文
    UIBezierPath *path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    [[UIColor purpleColor]setFill];
    [path fill];
#else
    //现在是使用Core Graphics完成同样的事；这将要求我先得到当前上下文的引用
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100));
    CGContextSetFillColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextFillPath(context);
    //CGContextDrawPath(context, kCGPathEOFillStroke);
#endif
  
#endif
}


//写了这个后背景会变成黑色，并且不执行drwaRect方法
/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //接下来，将实现一个VIew子类的drawLayer:inContext:这种情况下，将把引用提交上下文，但是他不是当前上下文，所以需要使他成为上下文以便使用UIKit
    
#if 0
    
#if 0
    UIGraphicsPushContext(ctx);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    [[UIColor redColor] setFill];
    [path fill];
    UIGraphicsPopContext();
#else
    //要在DrawLayer:inContext:中使用Core Graphics;只要简单的保存已经提交的上下文
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextFillPath(ctx);
    
#endif
    
#endif
}
*/


@end
