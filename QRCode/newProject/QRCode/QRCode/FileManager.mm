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



+(void)insertNewContact:(NSDictionary *)dict withImage:(UIImage *)image
{
    NSMutableArray * contactsData = [FileManager getContactsData];
    if(contactsData==nil)
    {
        contactsData = [[NSMutableArray alloc] init];
    }
    // save the picture
    NSString * imgName = [FileManager saveCapturedImage:image];
    // add new dict into contact list
    NSMutableDictionary * saveDict = [[NSMutableDictionary alloc] init];
    [saveDict setObject:dict forKey:kContactInfo];
    [saveDict setObject:imgName forKey:kImageName];
    [contactsData addObject:saveDict];
    
    // save the contacts list to file
    NSMutableDictionary * contacts = [[NSMutableDictionary alloc] init];
    [contacts setObject:contactsData forKey:kContactsData];
    [FileManager saveDictionary:contacts];
}

+(void)deleteAtIndex:(int)index
{
    NSMutableArray * contactsData = [FileManager getContactsData];
    if(index < contactsData.count)
    {
        [contactsData removeObjectAtIndex:index];
        // save the contacts list to file
        NSMutableDictionary * contacts = [[NSMutableDictionary alloc] init];
        [contacts setObject:contactsData forKey:kContactsData];
        [FileManager saveDictionary:contacts];
    }
}


+(void)callTo:(NSString *)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]]];
}

+(void)goToSite:(NSString*)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]]];
}

+(void)mailTo:(NSString*)email
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", email]]];
}

@end
