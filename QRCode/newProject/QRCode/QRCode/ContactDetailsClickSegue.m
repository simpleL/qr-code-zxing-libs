//
//  ContactDetailsClickSegue.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ContactDetailsClickSegue.h"
#import "ContactListTableViewCell.h"
#import "ContactDetailsTableViewCell.h"
#import "ContactDetailsViewController.h"
#import "FileManager.h"
#import "Utilities.h"
#import "Constants.h"


@implementation ContactDetailsClickSegue
-(void)perform
{
    NSLog(@"telst");
    UINavigationController * nav = ((UIViewController*)self.sourceViewController).navigationController;
    NSDictionary * dict = [[FileManager getContactsData] objectAtIndex:[ContactListTableViewCell getRow]];
    NSDictionary * info = [dict objectForKey:kContactInfo];
    NSString * imagePath = [dict objectForKey:kImageName];
    
    ContactDetailsViewController * detailsController = (ContactDetailsViewController*)self.destinationViewController;
    detailsController.fullName = [info objectForKey:kFullName];
    detailsController.email = [info objectForKey:kEmail];
    detailsController.phoneNumber = [info objectForKey:kPhoneNumber];
    detailsController.personalSite = [info objectForKey:kPersonalSite];
    detailsController.address = [info objectForKey:kAddress];
    detailsController.imageName = imagePath;
    [nav pushViewController:self.destinationViewController animated:YES];
}
@end
