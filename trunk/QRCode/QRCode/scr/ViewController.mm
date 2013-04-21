//
//  ViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ViewController.h"
#import <QRCodeReader.h>
#import <ZXingWidgetController.h>
#import <TwoDDecoderResult.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomeImageView.h"
#import "Utilities.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _points = nil;
	// Do any additional setup after loading the view, typically from a nib.
    QRCodeReader * reader = [[QRCodeReader alloc] init];
    _readers = [[NSSet alloc] initWithObjects:reader,nil];
    [reader release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
-(void)startDecode:(id)sender
{
    safeRelease(_points);
    _points = [[NSMutableArray alloc] init];
    
    Decoder * decoder = [[Decoder alloc] init];
    [decoder setDelegate:self];
    [decoder setReaders:_readers];
    
//    [decoder decodeImage:[UIImage imageNamed:@"qrcode-nguyenBaPhuoc.png"]];
//    [decoder decodeImage:[UIImage imageNamed:@"QRcodeINDIA.gif"]];
//    [decoder decodeImage:[UIImage imageNamed:@"images.jpeg"]];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"images-%d.jpeg", [_textField.text intValue]]];
    [decoder decodeImage:image];
    [(CustomeImageView*)self.view setImage:image];
}

#pragma mark - Implements decoder delegate
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
//    NSLog(@"will decode image");
}
- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    NSLog(@"%@", [result text]);
    [(CustomeImageView*)self.view setPoints:_points];
}
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    NSLog(@"fail to decode image");
    [(CustomeImageView*)self.view setPoints:_points];
}
- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
//    NSLog(@"found possible result point after decoding image");
    NSLog(@"(%d, %d)", (int)point.x, (int)point.y);
    [_points addObject:[NSValue valueWithCGPoint:point]];
}

@end
