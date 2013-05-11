//
//  ViewController.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "ViewController.h"
#import <QRCodeReader.h>
#import <ZXingWidgetController.h>
#import <TwoDDecoderResult.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomeImageView.h"
#import "Utilities.h"
#import "QRCodeGenerator.h"
#import "ScanView.h"
#import "QRCodeView.h"
#import <QuartzCore/QuartzCore.h>

#import <zxing/ReaderException.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

#import "AVCamCaptureManager.h"
#import "FileManager.h"

#define BUTTON_TAG_START_SCAN           1
#define BUTTON_TAG_CANCEL_SCAN          2
#define BUTTON_TAG_MY_INFO              3
#define BUTTON_TAG_CONTACT_LIST         4
#define BUTTON_TAG_MY_INFO_BACK         5
#define BUTTON_TAG_MY_INFO_SAVE         6
#define BUTTON_TAG_RESULT_CANCEL        7
#define BUTTON_TAG_RESULT_SAVE          8
#define BUTTON_TAG_CONTACT_INFO_BACK    9
#define BUTTON_TAG_CONTACT_INFO_QRIMAGE 10
#define BUTTON_TAG_QRCODE_BACK          11
#define BUTTON_TAG_QRCODE_SWITCH        12

#define kIndex @"INDEX"
#define kName  @"NAME"

#define kFullName       @"FullName"
#define kAddress        @"Address"
#define kPhoneNumber    @"PhoneNumber"
#define kEmail          @"Email"
#define kPersonalSite   @"PersonalSite"

typedef enum
{
    FlyDirectionLeft,
    FlyDirectionRight,
    FlyDirectionTop,
    FlyDirectionBottom
}FlyDirection;
#define FLY_FINISHED void(^)(BOOL)


#pragma mark - PROTOTYPE DECLARATION
@interface ViewController (AVCaptureVideoDataOutputSampleBufferDelegate)<AVCaptureVideoDataOutputSampleBufferDelegate>
-(void)decodeImage:(UIImage*)image;
- (void)setupCaptureSession;
@end

@interface ViewController (privateMethods)
-(void)preloadHUD;
-(void)startFlyIn:(UIView*)theView  completed:(FLY_FINISHED)completion;
-(void)startFlyOutTo:(FlyDirection)direction view:(UIView*)theView  completed:(FLY_FINISHED)completion;
-(void)setDataToResultView:(NSMutableDictionary*)dict andImage:(UIImage*)image;
-(NSString*)remove:(NSString*)s1 from:(NSString*)s2;
@end

@interface ViewController (listContactView)<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
-(void)initGesture;
-(void)swipeGesture;
-(void)tapGesture;
-(NSArray*)searchWith:(NSString*)searchString;
@end

#pragma mark - IMPLEMENTATION
@implementation ViewController
@synthesize screenH, screenW;
@synthesize shouldDecode;
@synthesize session = _session;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        screenW = [[UIScreen mainScreen] bounds].size.width;
        screenH = [[UIScreen mainScreen] bounds].size.height;
        _lastButtonPressedTag = 0;
        _dictScanReulst =  nil;
        _searchData = nil;
        _contactsData = [FileManager getContactsData];
        if (_contactsData==nil)
        {
            _contactsData = [[NSMutableArray alloc] init];
        }else
            [_contactsData retain];
        
        [self preloadHUD];
        [self initGesture];
        _decoder = nil;
        _points = nil;
        
        // Do any additional setup after loading the view, typically from a nib.
        QRCodeReader * reader = [[QRCodeReader alloc] init];
        _readers = [[NSSet alloc] initWithObjects:reader,nil];
        [reader release];
        
        safeRelease(_decoder);
        _decoder = [[Decoder alloc] init];
        [_decoder setDelegate:self];
        [_decoder setReaders:_readers];
    }
    return self;
}

-(void)dealloc
{
    safeRelease(_decoder);
    safeRelease(_readers);
    safeRelease(_contactsData);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCaptureSession];
    
    // Create video preview layer and add it to the UI
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    
    CALayer *viewLayer = [_scanView layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [_scanView bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    
    if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported]) {
        [[newCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    
    [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
    
    [newCaptureVideoPreviewLayer release];
        
    self.shouldDecode = NO;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - override methods
// disable autorotation
-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - actions
-(void)startDecode:(id)sender
{
    safeRelease(_points);
    _points = [[NSMutableArray alloc] init];
    
    Decoder * decoder = [[Decoder alloc] init];
    [decoder setDelegate:self];
    [decoder setReaders:_readers];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.jpg"];
    
//    NSLog(@"%@", docPath);
    UIImage * image = [UIImage imageWithContentsOfFile:docPath];
    [decoder decodeImage:image];
}

-(UIImage*)startEncodeTemporaryInfo
{    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"Nguyen van A" forKey:kFullName];
    [dict setObject:@"Trinh Dinh Thao" forKey:kAddress];
    [dict setObject:@"01689971684" forKey:kPhoneNumber];
    [dict setObject:@"common.start@gmail.com" forKey:kEmail];
    [dict setObject:@"baphuoc.com.vn" forKey:kPersonalSite];

    // optimize data
    NSString * txtData = [NSString stringWithFormat:@"%@", dict];
    txtData = [self remove:@"\n" from:txtData];
    
    NSArray * arr = [txtData componentsSeparatedByString:@"\""];
    
    txtData = @"";
    for (int i=0; i<arr.count; i++)
    {        
        if (i%2==0)
        {
            txtData = [NSString stringWithFormat:@"%@%@", txtData, [self remove:@" " from:[arr objectAtIndex:i]]];
        }else
        {
            txtData = [NSString stringWithFormat:@"%@\"%@\"", txtData, [arr objectAtIndex:i]];
        }
    }
    // return the result
    NSData * data = UIImageJPEGRepresentation([QRCodeGenerator qrImageForString:txtData imageSize:240], 1);
    return [UIImage imageWithData:data];
    
    //------------------------------------ generate temporary contact list
//    NSMutableArray * array = [[NSMutableArray alloc] init];
//    for (int i=0; i<100; i++)
//    {
//        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[NSString stringWithFormat:@"Nguyen so %d", i+1] forKey:kName];
//        [dict setObject:@"Trinh Dinh Thao" forKey:kAddress];
//        [dict setObject:@"01689971684" forKey:kPhoneNumber];
//        [dict setObject:@"common.start@gmail.com" forKey:kEmail];
//        [dict setObject:@"baphuoc.com.vn" forKey:kPersonalSite];
//        [array addObject:dict];
//    }
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:array forKey:@"testFileSize"];
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kContactsFileListName];
//    [dict writeToFile:docPath atomically:NO];
//    return nil;
    //------------------------------------ end generate temporary contact list
//    NSData *imgData = UIImageJPEGRepresentation(image, 1);
//    [imgData writeToFile:docPath atomically:NO];
//    [(CustomeImageView*)self.view setImage:image];
}

-(void)buttonClicked:(id)sender
{
    UIView * btn = (UIView*)sender;
    
    if (btn.tag == BUTTON_TAG_START_SCAN)
    {        
        void (^finishFlyIn)(BOOL finished) = ^(BOOL finished)
        {
//TODO: uncomment these
//            _isScanViewEnable = YES;
//            if (_isScanViewEnable)
//            {
//                self.shouldDecode = YES;
//            }
            
            // -----------------------------create temporary result
//TODO: remove the code below
            void (^runOutScanView)(void) = ^(void)
            {
                [_scanView setCenter:CGPointMake(160, -240)];
            };
            
            void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
            {
                [_scanView setHidden:finished];
                [_btnScan setEnabled:finished];
                UIImage * image = [self startEncodeTemporaryInfo];
                [self decodeImage:image];
//                [_imgScanResultCapturedImage setImage:image];
            };
            
            [_btnScan setEnabled:NO];
            _isScanViewEnable = NO;
            [_session stopRunning];
            self.shouldDecode = NO;
            [UIView animateWithDuration:.4f animations:runOutScanView completion:finishRunOut];

            
            [self startFlyIn:_scanResultView completed:nil];
            
            // ------------------------------end temporary
        };
        [_session startRunning];
        [_scanView setHidden:NO];        
        [self startFlyIn:_scanView completed:finishFlyIn];
    }
    
    if (btn.tag == BUTTON_TAG_CANCEL_SCAN)
    {        
        void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
        {
            [_scanView setHidden:finished];
            [_btnScan setEnabled:finished];
        };
        
        _isScanViewEnable = NO;
        [_session stopRunning];
        self.shouldDecode = NO;
        [self startFlyOutTo:FlyDirectionTop view:_scanView completed:finishRunOut];
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_INFO_BACK)
    {
        void (^finished)(BOOL)  = ^(BOOL finished){
            if (_contactListView.alpha > 0)
            {
                [self.searchDisplayController.searchResultsTableView setHidden:NO];
            }        
        };       
        
        [self startFlyOutTo:FlyDirectionRight view:_contactInfoView completed:finished];
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_INFO_QRIMAGE)
    {
        [self startFlyIn:_qrcodeView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_CONTACT_LIST)
    {
        void (^finished)(BOOL)  = ^(BOOL finished){
            if (_contactListView.alpha > 0)
            {
                [self.searchDisplayController.searchResultsTableView setHidden:NO];
            }
        };
        [self startFlyIn:_contactListView completed:finished];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO)
    {                
        [self startFlyIn:_myInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO_BACK)
    {
        [self startFlyOutTo:FlyDirectionLeft view:_myInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_MY_INFO_SAVE)
    {
        // this function do nothing
//        [self startFlyIn:_contactInfoView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_QRCODE_BACK)
    {
        [self startFlyOutTo:FlyDirectionRight view:_qrcodeView completed:nil];
    }
    
    if (btn.tag == BUTTON_TAG_QRCODE_SWITCH)
    {
        
    }
    
    if (btn.tag == BUTTON_TAG_RESULT_CANCEL)
    {
        [self startFlyOutTo:FlyDirectionBottom view:_scanResultView completed:nil];
        safeRelease(_dictScanReulst);
    }
    
    if (btn.tag == BUTTON_TAG_RESULT_SAVE)
    {
        void (^finished)(BOOL)  = ^(BOOL finished){
            //TODO: load scanned contact info to the view
            [self startFlyIn:_contactInfoView completed:nil];
            [_txtContactInfoDetails setText:[NSString stringWithFormat:@"%@", _dictScanReulst]];
        };
        [self startFlyOutTo:FlyDirectionBottom view:_scanResultView completed:finished];
        
        // save the picture
        NSString * imgName = [FileManager saveCapturedImage:_imgScanResultCapturedImage.image];
        // add new dict into contact list
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_dictScanReulst forKey:kContactInfo];
        [dict setObject:imgName forKey:kImageName];
        [_contactsData addObject:dict];
        
        // save the contacts list to file
        NSMutableDictionary * contacts = [[NSMutableDictionary alloc] init];
        [contacts setObject:_contactsData forKey:kContactsData];
        [FileManager saveDictionary:contacts];
        safeRelease(contacts);
        safeRelease(dict);
    }
    
    // set last tag pressed button
    _lastButtonPressedTag = btn.tag;
}

#pragma mark - Decoder delegate implementation
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
//    NSLog(@"will decode image");
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{    
    void (^finishRunOut)(BOOL finished) = ^(BOOL finished)
    {
        [_scanView setHidden:finished];
        [_btnScan setEnabled:finished];
    };
    
    [_btnScan setEnabled:NO];
    _isScanViewEnable = NO;
    [_session stopRunning];
    self.shouldDecode = NO;
    [self startFlyOutTo:FlyDirectionTop view:_scanView completed:finishRunOut];
    //TODO: convert result into dictionary and set it to scanResult view
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.plist"];
    [result.text writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:docPath];
    [self setDataToResultView:dict andImage:image];
    
    [self startFlyIn:_scanResultView completed:nil];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    if (_isScanViewEnable)
    {
//        safeRelease(_decoder);
//        _decoder = [[Decoder alloc] init];
//        [_decoder setDelegate:self];
//        [_decoder setReaders:_readers];
        self.shouldDecode = YES;
    }
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
//    NSLog(@"found possible result point after decoding image");
//    NSLog(@"(%d, %d)", (int)point.x, (int)point.y);
//    [_points addObject:[NSValue valueWithCGPoint:point]];
}

@end


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate implementation
@implementation ViewController (AVCaptureVideoDataOutputSampleBufferDelegate)

// Create and configure a capture session and start it running
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
        [session release];
        return;
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //    output.minFrameDuration = CMTimeMake(1, 15);
    AVCaptureConnection * connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoMinFrameDuration:CMTimeMake(1, 30)];
    
    // Assign session to an ivar.
    [self setSession:session];
    [session release];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
//    NSLog(@"captured");
    if (self.shouldDecode)
    {
        // Create a UIImage from the sample buffer data
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        if (!image)
        {
            NSLog(@"nil");
        }else
        {
            self.shouldDecode = NO;
            try {
                [self decodeImage:image];
            } catch (zxing::ReaderException * e)
            {
                NSLog(@"%@", [NSString stringWithUTF8String:e->what()]);
            }        
        }
    }
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

-(void)decodeImage:(id)image
{        
//    safeRelease(_points);
//    _points = [[NSMutableArray alloc] init];
    [_decoder decodeImage:image]; 
}

@end


@implementation ViewController (privateMethods)

-(void)startFlyIn:(UIView *)theView completed:(void (^)(BOOL))completion
{
    void (^flyIn)(void) = ^(void)
    {        
        [theView setCenter:CGPointMake(screenW/2, screenH/2)];
        [theView setAlpha:1];
    };
    [theView setHidden:NO];
    [UIView animateWithDuration:.4f animations:flyIn completion:completion];
}

-(void)startFlyOutTo:(FlyDirection)direction view:(UIView *)theView completed:(void (^)(BOOL))completion
{
    void (^flyOut)(void) = ^(void)
    {
        switch (direction) {
            case FlyDirectionBottom:
            {
                [theView setCenter:CGPointMake(screenW/2, 3*screenH/2)];
            }
                break;
            case FlyDirectionLeft:
            {
                [theView setCenter:CGPointMake(-screenW/2, screenH/2)];
            }
                break;
            case FlyDirectionRight:
            {
                [theView setCenter:CGPointMake(3*screenW/2, screenH/2)];
            }
                break;
            case FlyDirectionTop:
            {
                [theView setCenter:CGPointMake(screenW/2, -screenH/2)];
            }
                break;
            default:
                break;
        }
        [theView setAlpha:0];        
    };    
    
    void(^completed)(BOOL) = ^(BOOL finished)
    {
        [theView setHidden:YES];
        if (completion)
        {
            completion(finished);
        }        
    };
    
    [UIView animateWithDuration:.4f animations:flyOut completion:completed];
}

-(void)preloadHUD
{    
    // my info view
    [self.view addSubview:_myInfoView];
    [_myInfoView setCenter:CGPointMake(-screenW/2, screenH/2)];
    [_myInfoView setAlpha:0];
    
    // scan view
    [self.view addSubview:_scanView];
    [_scanView setCenter:CGPointMake(screenW/2, -screenH/2)];
    [_scanView setAlpha:0];
    _isScanViewEnable = NO;
    
    // scan result view
    [self.view addSubview:_scanResultView];
    [_scanResultView setCenter:CGPointMake(screenW/2, 3*screenH/2)];
    [_scanResultView setAlpha:0];
    
    // contact list view
    [self.view addSubview:_contactListView];
    [_contactListView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_contactListView setAlpha:0];
    
    // contact info view
    [self.view addSubview:_contactInfoView];
    [_contactInfoView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_contactInfoView setAlpha:0];
    
    // QRCode view
    [self.view addSubview:_qrcodeView];
    [_qrcodeView setCenter:CGPointMake(3*screenW/2, screenH/2)];
    [_qrcodeView setAlpha:0];
    
    
    _txtContactInfoDescription.layer.borderWidth = 0.5f;
    _txtContactInfoDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    _txtContactInfoDescription.layer.cornerRadius = 5.f;
    
    _txtContactInfoDetails.layer.borderWidth = 0.5f;
    _txtContactInfoDetails.layer.borderColor = [[UIColor grayColor] CGColor];
    _txtContactInfoDetails.layer.cornerRadius = 5.f;
}

-(void)setDataToResultView:(NSMutableDictionary*)dict andImage:(UIImage*)image
{
    //TODO: set dict informations to scan result view
    [_imgScanResultCapturedImage setImage:image];
    [_txtScanResultText setText:[NSString stringWithFormat:@"%@", dict]];
    
    // keep the scan result dictionary
    _dictScanReulst = [dict  retain];
}

-(NSString *)remove:(NSString *)s1 from:(NSString *)s2
{
    NSArray * arr = [s2 componentsSeparatedByString:s1];
    NSString * sr = @"";
    for (NSString * i in arr)
    {
        if (![i isEqualToString:@" "])
        {
            sr = [NSString stringWithFormat:@"%@%@", sr, i];
        }
    }
    return sr;
}

@end


@implementation ViewController (listContactView)

-(void)initGesture
{
    _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    [self.view addGestureRecognizer:_swipe];
    [_viewContactInfoContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
}

-(void)swipeGesture
{
    [self startFlyOutTo:FlyDirectionRight view:_contactListView completed:nil];
    [self.searchDisplayController.searchResultsTableView setHidden:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

-(void)tapGesture
{
    [_txtContactInfoDescription resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^(void)
     {
         [_viewContactInfoContainer setCenter:CGPointMake(160, 218)];
     }];
}

-(NSArray *)searchWith:(NSString *)searchString
{  
    NSMutableArray * results = [[[NSMutableArray alloc] init] autorelease];
            
    // create temporary results
    for (int i=0; i<searchString.length; i++)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:i] forKey:kIndex];
        [dict setObject:[NSString stringWithFormat:@"name %d", i] forKey:kFullName];
        [results addObject:dict];
    }
    
    //nothing of searching, just return nil
    if (results.count == 0)
    {
        return nil;
    }
    return results;
}

#pragma mark - search bar controller delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableContacts)
    {
        return _contactsData.count;
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView && _searchData)
    {
        return _searchData.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultIdentifier"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView && _searchData)
    {
        // Configure the cell.
        NSDictionary * info = [_searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:kFullName]];
        return cell;
    }
    else if(tableView == _tableContacts)
    {
        // Configure the cell.
        NSDictionary * info = [[_contactsData objectAtIndex:indexPath.row] objectForKey:kContactInfo];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:kFullName]];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController.searchBar resignFirstResponder];
    [self.searchDisplayController.searchResultsTableView setHidden:YES];
    [self startFlyIn:_contactInfoView completed:nil];
    //TODO: load contact info into new view
    if (tableView == _tableContacts)
    {
        NSDictionary * dict = [_contactsData objectAtIndex:indexPath.row];
        [_txtContactInfoDetails setText:[NSString stringWithFormat:@"%@",[dict objectForKey:kContactInfo]]];
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView && _searchData)
    {
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    safeRelease(_searchData);
    _searchData = [[self searchWith:searchString] retain];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    safeRelease(_searchData);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25f animations:^(void)
    {        
        [_viewContactInfoContainer setCenter:CGPointMake(160, 42)];
    }];
    return YES;
}

@end
