//
//  QRCodeView.m
//  QRCode
//
//  Created by ba phuoc on 5/8/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "QRCodeView.h"
#import "Utilities.h"

@implementation QRCodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _qrImage = nil;
    }
    return self;
}

-(void)dealloc
{
    safeRelease(_qrImage);
    [super dealloc];
}

-(void)setQRCodeImage:(UIImage *)image
{
    safeRelease(_qrImage);
    if (image)
    {
        _qrImage = [image retain];
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //TODO: draw the QR_Image here
    NSLog(@"remember to draw the image");
}


@end
