//
//  UIView+LinearInterpView.m
//  jiggah
//
//  Created by Patrik Boras on 12/09/14.
//  Copyright (c) 2014 tapthis. All rights reserved.
//

#import "LinearInterpolationView.h"

@implementation LinearInterpolationView
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint bezierPoints[4];
    uint counter;
}


-(IBAction)clearView:(id)sender{
   //TODO: clear
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
    
}

- (void)drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect];
    [path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    counter = 0;
    UITouch *touch = [touches anyObject];
    bezierPoints[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    counter++;
    bezierPoints[counter] = p;
    if (counter == 3) // 4th point
    {
        [path moveToPoint:bezierPoints[0]];
        [path addCurveToPoint:bezierPoints[3] controlPoint1:bezierPoints[1] controlPoint2:bezierPoints[2]];
        [self setNeedsDisplay];
        bezierPoints[0] = [path currentPoint];
        counter = 0;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self drawBitmap];
    [self setNeedsDisplay];
    bezierPoints[0] = [path currentPoint];
    [path removeAllPoints];
    counter = 0;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];
    if (!incrementalImage) //background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end