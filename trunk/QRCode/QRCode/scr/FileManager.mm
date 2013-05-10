//
//  FileManager.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

-(NSMutableDictionary *)loadFromPath:(NSString*)path
{
    NSMutableDictionary * dict = nil;
    if (path)
    {
        dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
    }    
    return dict;
}

-(void)writeDictToFile:(NSDictionary*)dict atPath:(NSString*)path andName:(NSString*)name
{
    if (dict && path && name)
    {
        [dict writeToFile:[NSString stringWithFormat:@"%@\\%@", path, name] atomically:NO];
    }
}

+(NSMutableDictionary *)loadFromPath:(NSString*)path
{
    FileManager * fileManager = [[[FileManager alloc] init] autorelease];
    return [fileManager loadFromPath:path];
}

+(void)writeDictToFile:(NSDictionary *)dict atPath:(NSString *)path andName:(NSString *)name
{
    FileManager * fileManager = [[[FileManager alloc] init] autorelease];
    [fileManager writeDictToFile:dict atPath:path andName:name];
}

@end
