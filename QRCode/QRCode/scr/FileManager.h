//
//  FileManager.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

-(NSMutableDictionary*)loadFromPath:(NSString*)path;
-(void)writeDictToFile:(NSDictionary*)dict atPath:(NSString*)path andName:(NSString*)name;

+(NSMutableDictionary*)loadFromPath:(NSString*)path;
+(void)writeDictToFile:(NSDictionary*)dict atPath:(NSString*)path andName:(NSString*)name;
@end
