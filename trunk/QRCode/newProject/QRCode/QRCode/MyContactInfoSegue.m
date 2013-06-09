//
//  MyContactInfoSegue.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 09/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "MyContactInfoSegue.h"
#import "InputNewContactViewController.h"
#import "InputInfoTableViewCell.h"
#import "FileManager.h"
#import "Constants.h"

@implementation MyContactInfoSegue
-(void)perform
{
    UINavigationController * nav = ((UIViewController*)self.sourceViewController).navigationController;

    InputNewContactViewController * inputController = (InputNewContactViewController*)self.destinationViewController;
    inputController.isAddNew = NO;
    
    //TODO: keep the contact in a dict
    
    NSDictionary * dict = [FileManager getMyContactInfo];
    
    inputController.fullName = [dict objectForKey:kFullName];
    inputController.phoneNumber = [dict objectForKey:kPhoneNumber];
    inputController.email = [dict objectForKey:kEmail];
    inputController.personalSite = [dict objectForKey:kPersonalSite];
    inputController.address = [dict objectForKey:kAddress];
    
    
    [nav pushViewController:self.destinationViewController animated:YES];
}
@end
