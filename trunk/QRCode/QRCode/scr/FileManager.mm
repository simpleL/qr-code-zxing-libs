//
//  FileManager.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

-(id)init
{
    self  = [super init];
    
    return self;
}

-(NSArray *)loadFromPath:(NSString*)path extension:(NSString*)ext
{
    NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
    return array;
}

+(NSArray *)loadFromPath:(NSString*)path extension:(NSString*)ext
{
    FileManager * fileManager = [[[FileManager alloc] init] autorelease];
    return [fileManager loadFromPath:path extension:ext];
}

@end
