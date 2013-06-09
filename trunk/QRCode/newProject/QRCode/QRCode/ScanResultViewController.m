//
//  ScanResultViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ScanResultViewController.h"
#import "ScanViewController.h"

@interface ScanResultViewController (tableViewMethods)<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ScanResultViewController

@synthesize btnSave, btnContinueScan;

-(id)init
{
    self = [super init];
    if (self)
    {
        isContinueScan = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        isContinueScan = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isContinueScan = NO;
    }
    return self;
}

-(void)btnClicked:(id)sender
{
    UIBarButtonItem * btn = (UIBarButtonItem*)sender;    
    if (btn == btnSave)
    {
        NSLog(@"save the result");
    }
    if (btn == btnContinueScan)
    {        
        isContinueScan = YES;
    }
    [nav popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    nav = self.navigationController;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:4 delay:3 options:UIViewAnimationOptionTransitionNone animations:^{} completion:^(BOOL finished)
     {
         if (finished && isContinueScan)
         {
             UIStoryboard * storyBoard = self.storyboard;
             UIViewController * result = [storyBoard instantiateViewControllerWithIdentifier:@"scanViewController"];
             [nav pushViewController:result animated:YES];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@implementation ScanResultViewController(tableViewMethods)

#pragma mark Datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scanResultTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    
    // configurate the cell informations
    return cell;
}

#pragma mark table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end