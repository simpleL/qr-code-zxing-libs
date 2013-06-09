//
//  ContactDetailsViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "ContactDetailsTableViewCell.h"
#import "FileManager.h"

@interface ContactDetailsViewController ()

@end

@implementation ContactDetailsViewController

@synthesize fullName, phoneNumber, email, personalSite, address, imageName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    static NSString *CellIdentifier = @"contactDetailsTableViewCell";
    ContactDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.fullName.text = fullName;
    cell.phoneNumber.text = phoneNumber;
    cell.email.text = email;
    cell.personalSite.text = personalSite;
    cell.address.text = address;
    [cell.image setImage:[FileManager getCapturedImage:imageName]];
    // configurate the cell informations
    return cell;
}

#pragma mark table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
