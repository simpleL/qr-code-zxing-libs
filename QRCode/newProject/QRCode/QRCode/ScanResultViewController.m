//
//  ScanResultViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanResultViewController.h"
#import "ScanViewController.h"

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        isNewPush = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        isNewPush = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isNewPush = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    // show the scan view
    if (isNewPush)
    {
        isNewPush = NO;
        ScanViewController * scanView = [[[ScanViewController alloc] init] autorelease];
        [self.navigationController pushViewController:scanView animated:YES];
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        if (![ScanViewController isFound])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
