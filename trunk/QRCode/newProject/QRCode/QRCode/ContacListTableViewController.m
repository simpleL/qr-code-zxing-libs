//
//  ContacListTableViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ContacListTableViewController.h"
#import "ContactListTableViewCell.h"
#import "FileManager.h"
#import "Constants.h"
#import "Utilities.h"


@interface ContacListTableViewController ()

@end

@implementation ContacListTableViewController

static int selectedIndex = 0;
+(int)selectedIndex
{
    return selectedIndex;
}

-(id)init
{
    self = [super init];
    _contactsData = [[FileManager getContactsData] retain];
    if (_contactsData==nil)
    {
        _contactsData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder

{
    self = [super initWithCoder:aDecoder];
    _contactsData = [[FileManager getContactsData] retain];
    if (_contactsData==nil)
    {
        _contactsData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _contactsData = [[FileManager getContactsData] retain];
    if (_contactsData==nil)
    {
        _contactsData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadView
{
    [super loadView];    
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    safeRelease(_contactsData);
    _contactsData = [[FileManager getContactsData] retain];
    [_tableViewListContacts reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _contactsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListTableViewCell * cell = nil;
    static NSString *CellIdentifier = @"contactListTableViewCell";
    cell = [_tableViewListContacts dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (tableView == _tableViewListContacts)
    {
        //TODO: configurate
        NSDictionary * dict = [[_contactsData objectAtIndex:indexPath.row] objectForKey:kContactInfo];
        [cell setInfoWithFullName:[dict objectForKey:kFullName] phoneNumber:[dict objectForKey:kPhoneNumber] email:[dict objectForKey:kEmail] personalSite:[dict objectForKey:kPersonalSite] address:[dict objectForKey:kAddress]];
        cell.row = indexPath.row;
    }else
    {
        //TODO: configurate
    }
    
    
    // configurate the cell informations
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 287;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [FileManager deleteAtIndex:indexPath.row];
        safeRelease(_contactsData);
        _contactsData = [[FileManager getContactsData] retain];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
