//
//  ViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ViewController.h"
#import "Utilities.h"
#import "FileManager.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;

+(void)setImage:(UIImage *)image
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
}

-(void)viewWillAppear:(BOOL)animated
{    
    NSDictionary * dict = [FileManager getMyContactInfo];
    if(dict)
    {
        [imageView setImage:encode(dict)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
