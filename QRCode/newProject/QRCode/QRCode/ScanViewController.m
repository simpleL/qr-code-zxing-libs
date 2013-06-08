//
//  ScanViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanResultViewController.h"

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

-(void)btnClicked:(id)sender
{
    [nav popViewControllerAnimated:YES];
    isFound = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    nav = self.navigationController;
//    [nav popViewControllerAnimated:YES];    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //TODO: stop the camera stream
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:4 delay:3 options:UIViewAnimationOptionTransitionNone animations:^{} completion:^(BOOL finished)
    {
        if (finished && isFound)
        {
            UIStoryboard * storyBoard = self.storyboard;
            UIViewController * result = [storyBoard instantiateViewControllerWithIdentifier:@"resultViewController"];
            [nav pushViewController:result animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
