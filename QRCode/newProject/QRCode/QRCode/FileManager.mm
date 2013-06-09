//
//  FileManager.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "FileManager.h"
#import "Constants.h"



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
    [formatter setTimeStyle:NSDateFormatterLongStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Sydney"]];
    
    NSString * s = [formatter stringFromDate:now];
    s = [s stringByReplacingOccurrencesOfString:@"/" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.jpeg",s];
    NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:fileName];
    [UIImageJPEGRepresentation(image, 1) writeToFile:docPath atomically:NO];
    return fileName;
}

+(UIImage *)getCapturedImage:(NSString *)fileName
{
    if (fileName)
    {
//        NSArray * arr = [fileName componentsSeparatedByString:@"."];
//        NSString * s = @"\"";
//        for (int i=0;i<arr.count-1;i++)
//        {
//            if (![[arr objectAtIndex:i] isEqualToString:@""])
//            {
//                s = [NSString stringWithFormat:@"%@%@", s, [arr objectAtIndex:i]];
//            }
//        }
//        s = [NSString stringWithFormat:@"%@\".jpeg", s];
        NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:fileName];
        return [UIImage imageWithContentsOfFile:docPath];
    }
    return nil;
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

+(void)saveMyContactInfo:(NSDictionary *)dict
{
    if (dict)
    {
        NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:kMyContactInfo];
        [dict writeToFile:docPath atomically:NO];
    }
}

+(NSMutableDictionary *)getMyContactInfo
{
    NSString * docPath = [[FileManager getDocumentPath] stringByAppendingPathComponent:kMyContactInfo];
    NSMutableDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:docPath];
    return dict;
}

@end
