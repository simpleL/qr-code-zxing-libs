//
//  FileManager.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

-(id)init;
-(NSArray*)loadFromPath:(NSString*)path extension:(NSString*)ext;
+(NSArray*)loadFromPath:(NSString*)path extension:(NSString*)ext;
@end
