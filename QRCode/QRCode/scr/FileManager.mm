//
//  FileManager.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "FileManager.h"

#define kContactsFileListName   @"myContactsList.plist"

@implementation FileManager

+(NSString *)getDocumentPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    return [paths objectAtIndex:0];
}

// return name of image
+(NSString*)saveCapturedImage:(UIImage *)image
{
    if (image==nil)
    {
        return nil;
    }
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Sydney"]];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:now]];
    NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:fileName];
    [UIImageJPEGRepresentation(image, 1) writeToFile:docPath atomically:NO];
    return fileName;
}

+(void)saveDictionary:(NSDictionary *)dict
{
    if (dict)
    {
        NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:kContactsFileListName];
        [dict writeToFile:docPath atomically:NO];
    }
}

+(NSMutableArray *)getContactsData
{
    NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:kContactsFileListName];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:docPath];
    if (dict)
    {
        return [dict objectForKey:kContactsData];
    }
    return nil;
}

@end
