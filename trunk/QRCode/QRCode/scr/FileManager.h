//
//  FileManager.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kContactInfo    @"Info"
#define kImageName      @"ImageName"
#define kContactsData   @"ContactsData"

@interface FileManager : NSObject

+(NSString*)getDocumentPath;
+(NSString*)saveCapturedImage:(UIImage*)image;
+(void)saveDictionary:(NSDictionary*)dict;
+(NSMutableArray*)getContactsData;

@end
