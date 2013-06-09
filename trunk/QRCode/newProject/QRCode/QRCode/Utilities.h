//
//  Utilities.h
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#ifndef _utilities__h_
#define _utilities__h_
#include "Constants.h"

#define safeRelease(x){if(x){[x release];x=nil;}}

UIImage * encode(NSDictionary * dict);
NSString * removeS1S2(NSString * s1, NSString * s2);
NSDictionary * createDictWith(NSString * fullName, NSString* phoneNumber, NSString * email, NSString * personalSite, NSString * address);
#endif
