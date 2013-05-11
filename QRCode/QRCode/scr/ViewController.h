//
//  ViewController.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DecoderDelegate.h>

@class ScanView;
@class AVCamCaptureManager;
@class AVCaptureVideoPreviewLayer;
@class AVCaptureSession;
@class Decoder;
@class QRCodeView;

@interface ViewController : UIViewController<DecoderDelegate, UITextViewDelegate>
{
    NSSet               *_readers;
    NSMutableArray      *_points;
    Decoder             *_decoder;
    
    int     _lastButtonPressedTag;
    
    // main view
    IBOutlet UIBarButtonItem    *_btnScan;
    IBOutlet UIBarButtonItem    *_btnMyInfos;
    IBOutlet UIBarButtonItem    *_btnContactList;
    
    // my informations view
    IBOutlet UIView             *_myInfoView;
    IBOutlet UIBarButtonItem    *_btnMyInfoBack;
    IBOutlet UIBarButtonItem    *_btnMyInfoSave;
    
    // Scan view
    IBOutlet ScanView           *_scanView;
    IBOutlet UIBarButtonItem    *_btnCancel;
    BOOL                        _isScanViewEnable;
    
    // scan result view
    IBOutlet UIView             *_scanResultView;
    IBOutlet UIBarButtonItem    *_btnScanResultCancel;
    IBOutlet UIBarButtonItem    *_btnScanResultSave;
    IBOutlet UIImageView        *_imgScanResultCapturedImage;
    IBOutlet UITextView         *_txtScanResultText;
    NSMutableDictionary         *_dictScanReulst;
    
    // contact info view
    IBOutlet UIView             *_contactInfoView;
    IBOutlet UIBarButtonItem    *_btnContactInfoBack;
    IBOutlet UIBarButtonItem    *_btnContactInfoQRImage;
    IBOutlet UIView             *_viewContactInfoContainer;
    IBOutlet UITextView         *_txtContactInfoDetails;
    IBOutlet UITextView         *_txtContactInfoDescription;
    
    // QRCode view
    IBOutlet QRCodeView         *_qrcodeView;
    IBOutlet UIBarButtonItem    *_btnQRCodeBack;
    IBOutlet UIBarButtonItem    *_btnQRCodeSwitch;
    
    // contact list view
    IBOutlet UIView                 *_contactListView;
    IBOutlet UISearchBar            *_serBarContactListSearch;
    IBOutlet UIGestureRecognizer    *_swipe;
    IBOutlet UITableView            *_tableContacts;
    
    // list name of contacts
    NSArray                  *_searchData;    
    NSMutableArray           *_contactsData;
    
    AVCaptureSession            *_session;
}

@property (readonly) float screenW, screenH;
@property (nonatomic, retain) AVCaptureSession * session;
@property BOOL shouldDecode;

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

-(IBAction)buttonClicked:(id)sender;
@end
