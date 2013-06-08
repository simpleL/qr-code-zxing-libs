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

-(IBAction)btnClicked:(id)sender;

@end
