//
//  ScanViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        isFound = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        isFound = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isFound = NO;
    }
    return self;
}

static BOOL isFound = NO;
+(BOOL)isFound
{
    return isFound;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
    self.navigationController.navigationBarHidden = YES;
}

-(void)btnClicked:(id)sender
{
    UIBarButtonItem * item = (UIBarButtonItem*)sender;
    nav = self.navigationController;
    [nav popViewControllerAnimated:YES];
    if (item.tag==12)
    {
        NSLog(@"Found QRCode");
        isFound = YES;
    }else
    {
        isFound = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
