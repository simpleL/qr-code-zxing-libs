//
//  CustomScrollView.m
//  QRCode
//
//  Created by ba phuoc on 5/20/13.
//  Copyright (c) 2013 Nguyen Ba Phuoc. All rights reserved.
//

#import "CustomScrollView.h"

#import "Constants.h"
#import "Utilities.h"
#import "FileManager.h"

#import <QuartzCore/QuartzCore.h>


@interface CustomScrollView()<UITextFieldDelegate>
-(void)loadUI;
@end


@implementation CustomScrollView
-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setContentSize:CGSizeMake(320, 500)];
        [self setBounds:CGRectMake(0, 0, 320, 410)];
        _focusingTextField = nil;
        _dict = nil;
        [self loadUI];
        [self setDict:[FileManager getMyContactInfo]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setContentSize:CGSizeMake(320, 480)];
        [self loadUI];
        
    }
    return self;
}

-(void)dealloc
{
    safeRelease(_dict);
    [super dealloc];
}

- (void) loadUI
{
    UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    [lb setText:@"Full Name"];
    [self addSubview:lb];
    safeRelease(lb);
    
    _fullName = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 300, 40)];
    _fullName.text = @"test";
    _fullName.layer.borderColor = [UIColor grayColor].CGColor;
    _fullName.layer.borderWidth = 1;
    _fullName.borderStyle = UITextBorderStyleBezel;
    _fullName.layer.cornerRadius = 8;    
    _fullName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_fullName setDelegate:self];
    [self addSubview:_fullName];
    
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    [lb setText:@"Phone Number"];
    [self addSubview:lb];
    safeRelease(lb);
    
    _phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, 300, 40)];
    _phoneNumber.text = @"test";
    _phoneNumber.layer.borderColor = [UIColor grayColor].CGColor;
    _phoneNumber.layer.borderWidth = 1;
    _phoneNumber.borderStyle = UITextBorderStyleBezel;
    _phoneNumber.layer.cornerRadius = 8;
    _phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_phoneNumber setDelegate:self];
    [self addSubview:_phoneNumber];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    [lb setText:@"Email"];
    [self addSubview:lb];
    safeRelease(lb);
    
    _email = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 300, 40)];
    _email.text = @"test";
    _email.layer.borderColor = [UIColor grayColor].CGColor;
    _email.layer.borderWidth = 1;
    _email.borderStyle = UITextBorderStyleBezel;
    _email.layer.cornerRadius = 8;
    _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_email setDelegate:self];
    [self addSubview:_email];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 40)];
    [lb setText:@"Address"];
    [self addSubview:lb];
    safeRelease(lb);
    
    _address = [[UITextField alloc] initWithFrame:CGRectMake(10, 350, 300, 40)];
    _address.text = @"test";
    _address.layer.borderColor = [UIColor grayColor].CGColor;
    _address.layer.borderWidth = 1;
    _address.borderStyle = UITextBorderStyleBezel;
    _address.layer.cornerRadius = 8;
    _address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_address setDelegate:self];
    [self addSubview:_address];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 300, 40)];
    [lb setText:@"Personal Site"];
    [self addSubview:lb];
    safeRelease(lb);
    
    _personalSite = [[UITextField alloc] initWithFrame:CGRectMake(10, 450, 300, 40)];
    _personalSite.text = @"test";
    _personalSite.layer.borderColor = [UIColor grayColor].CGColor;
    _personalSite.layer.borderWidth = 1;
    _personalSite.borderStyle = UITextBorderStyleBezel;
    _personalSite.layer.cornerRadius = 8;
    _personalSite.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_personalSite setDelegate:self];
    [self addSubview:_personalSite];
}

-(void)handleTapGesture:(id)sender
{
    if (_focusingTextField)
    {
        [_focusingTextField resignFirstResponder];
        _focusingTextField = nil;
        [self setBounds:CGRectMake(0, 0, 320, 410)];
        [self setCenter:CGPointMake(160, 218)];
    }
}

-(void)setDict:(NSMutableDictionary *)dict
{
    if (dict)
    {
        safeRelease(_dict);
        _dict = [dict retain];
        
        NSString * s = nil;
        s = [dict objectForKey:kFullName];
        if (s)
        {
            _fullName.text = s;
            s = nil;
        }else
        {
            _fullName.placeholder = @"your full name";
        }
        
        s = [dict objectForKey:kPhoneNumber];
        if (s)
        {
            _phoneNumber.text = s;
            s = nil;
        }else
        {
            _phoneNumber.placeholder = @"0905151253";
        }
        
        s = [dict objectForKey:kEmail];
        if (s)
        {
            _email.text = s;
            s = nil;
        }else
        {
            _email.placeholder = @"example@gmail.com";
        }
        
        s = [dict objectForKey:kAddress];
        if (s)
        {
            _address.text = s;
            s = nil;
        }else
        {
            _address.placeholder = @"your address";
        }
        
        s = [dict objectForKey:kPersonalSite];
        if (s)
        {
            _personalSite.text = s;
            s = nil;
        }else
        {
            _personalSite.placeholder = @"your persional site";
        }
    }
}

-(NSMutableDictionary *)getDict
{
    if (_dict==nil)
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    NSString * s = nil;
    s = _fullName.text;
    if (s)
    {
        [_dict setObject:s forKey:kFullName];
        s = nil;
    }
    
    s = _phoneNumber.text;
    if (s)
    {
        [_dict setObject:s forKey:kPhoneNumber];
        s = nil;
    }
    
    s = _email.text;
    if (s)
    {
        [_dict setObject:s forKey:kEmail];
        s = nil;
    }
    
    s = _address.text;
    if (s)
    {
        [_dict setObject:s forKey:kAddress];
        s = nil;
    }
    
    s = _personalSite.text;
    if (s)
    {
        [_dict setObject:s forKey:kPersonalSite];
        s = nil;
    }
    return [_dict mutableCopy];
}

#pragma - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_focusingTextField==nil)
    {
        [self setBounds:CGRectMake(0, 0, 320, 280)];
        [self setCenter:CGPointMake(160, 120)];
    }
    _focusingTextField = textField;
    NSLog(@"%f", textField.center.y);
    [self setContentOffset:CGPointMake(0, textField.center.y < 260?textField.center.y-90:260-50) animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        _focusingTextField = nil;
        [self setBounds:CGRectMake(0, 0, 320, 410)];
        [self setCenter:CGPointMake(160, 218)];
        return NO;
    }
    return YES;
}

@end
