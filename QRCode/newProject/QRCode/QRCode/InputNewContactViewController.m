//
//  InputNewContactViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
// inputNewContactTableViewCell

#import "InputNewContactViewController.h"
#import "InputInfoTableViewCell.h"

@interface InputNewContactViewController (tableViewMethods)<UITableViewDelegate, UITableViewDataSource>

@end

@implementation InputNewContactViewController

@synthesize table, isAddNew;
@synthesize fullName, phoneNumber, email, personalSite, address;
-(id)init
{
    self = [super init];
    if (self)
    {
        isAddNew = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    isAddNew = YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isAddNew = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation InputNewContactViewController(tableViewMethods)

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
    static NSString *CellIdentifier = @"inputNewContactTableViewCell";
    InputInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.fullName.text = fullName;
    cell.phoneNumber.text = phoneNumber;
    cell.email.text = email;
    cell.personalSite.text = personalSite;
    cell.address.text = address;
    
    // configurate the cell informations
    return cell;
}

#pragma mark table view delegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end