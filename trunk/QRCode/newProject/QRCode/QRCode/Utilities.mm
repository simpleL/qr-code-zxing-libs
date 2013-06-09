//
//  Utilities.m
//  QRCode
//
//  Created by Nguyen Ba Phuoc on 4/21/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>
#import "QRCodeGenerator.h"

UIImage * encode(NSDictionary * dict)
{
    if (dict==nil)
    {
        return nil;
    }
    // optimize data
    NSString * txtData = [NSString stringWithFormat:@"%@", dict];
    txtData = removeS1S2(@"\n", txtData);
    
    NSArray * arr = [txtData componentsSeparatedByString:@"\""];
    
    txtData = @"";
    for (int i=0; i<arr.count; i++)
    {
        if (i%2==0)
        {
            txtData = [NSString stringWithFormat:@"%@%@", txtData, removeS1S2(@" ", [arr objectAtIndex:i])];
        }else
        {
            txtData = [NSString stringWithFormat:@"%@\"%@\"", txtData, [arr objectAtIndex:i]];
        }
    }
    // return the result
    NSData * data = UIImageJPEGRepresentation([QRCodeGenerator qrImageForString:txtData imageSize:240], 1);
    return [UIImage imageWithData:data];
}

NSString * removeS1S2(NSString * s1, NSString * s2)
{
    NSArray * arr = [s2 componentsSeparatedByString:s1];
    NSString * sr = @"";
    for (NSString * i in arr)
    {
        if (![i isEqualToString:@" "])
        {
            sr = [NSString stringWithFormat:@"%@%@", sr, i];
        }
    }
    return sr;
}

NSDictionary * createDictWith(NSString * fullName, NSString* phoneNumber, NSString * email, NSString * personalSite, NSString * address)
{
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:fullName forKey:kFullName];
    [dict setObject:phoneNumber forKey:kPhoneNumber];
    [dict setObject:email forKey:kEmail];
    [dict setObject:personalSite forKey:kPersonalSite];
    [dict setObject:address forKey:kAddress];
    
    return dict;
}