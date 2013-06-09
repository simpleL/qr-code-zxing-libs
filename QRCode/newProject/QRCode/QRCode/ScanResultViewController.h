//
//  ScanResultViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 08/06/2013.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultViewController : UIViewController
{
    UINavigationController * nav;
    BOOL                    isContinueScan;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem * btnSave, *btnContinueScan;
@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) NSString *fullName, *phoneNumber, *email, *personalSite, *address;
@property (nonatomic, retain) UIImage * image;
-(IBAction)btnClicked:(id)sender;

@end
