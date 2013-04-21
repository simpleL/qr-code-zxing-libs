//
//  CustomeImageView.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "CustomeImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

@implementation CustomeImageView

-(id)init
{
    self = [super init];
    _points = nil;
    _image = nil;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _points = nil;
        _image = nil;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _points = nil;
    return self;
}

#pragma mark - Instance methods
-(void)setPoints:(NSArray *)points
{
    safeRelease(_points);
    _points = [points retain];
    [self setNeedsDisplay];
}

-(void)setImage:(UIImage *)image
{
    safeRelease(_image);
    _image = [image retain];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw image
    if (_image)
    {
        CGSize size_ = [_image size];
//        CGContextDrawImage(context, CGRectMake(0, 0, size_.width, size_.height), _image.CGImage);
        [_image drawInRect:CGRectMake(60, 0, size_.width, size_.height)];
    }
    if (_points)
    {
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextSetLineWidth(context, 5.0);
        
        for (NSValue * v in _points)
        {
            CGPoint p = [v CGPointValue];
            
            CGContextMoveToPoint(context, p.x + 60, p.y);
            CGContextAddLineToPoint(context, 60 + p.x - 1, p.y - 1);
            CGContextStrokePath(context);
        }
    }
//    NSLog(@"drawing..........");
}

@end
