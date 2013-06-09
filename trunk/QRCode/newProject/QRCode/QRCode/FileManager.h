//
//  FileManager.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(NSString*)getDocumentPath;
+(NSString*)saveCapturedImage:(UIImage*)image;
+(UIImage*)getCapturedImage:(NSString*)fileName;
+(void)saveDictionary:(NSDictionary*)dict;
+(NSMutableArray*)getContactsData;

+(void)saveMyContactInfo:(NSDictionary *)dict;
+(NSMutableDictionary*)getMyContactInfo;


+(void)insertNewContact:(NSDictionary*)dict withImage:(UIImage*)image;
+(void)deleteAtIndex:(int)index;

@end
