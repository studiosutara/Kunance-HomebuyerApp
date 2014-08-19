//
//  Utilities.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (BOOL)isValidEmail:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

+(MBProgressHUD*) getHUDViewWithText:(NSString*) text onView:(UIView*) view
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
    if(!text)
        HUD.labelText = @"Completed";
    else
        HUD.labelText = text;
    
    return HUD;
}

+(UIImage *)takeSnapshotOfView:(UIView*) view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(NSString*)getCurrencyFormattedStringForNumber:(NSNumber*) amount
{
    NSNumberFormatter* currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    currencyNumberFormatter.locale = [NSLocale currentLocale];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.maximumFractionDigits = 0;
    currencyNumberFormatter.usesGroupingSeparator = YES;
    [currencyNumberFormatter setNegativeFormat:@"-¤#,##0.00"];
    
    return [currencyNumberFormatter stringFromNumber:amount];
}

+(UIAlertView*) showAlertWithTitle:(NSString*)title andMessage:(NSString*) msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    return alert;
}

+(UIAlertView*) showSlowConnectionAlert
{
    return [Utilities showAlertWithTitle:@"Slow Connection" andMessage:@"Your profile may be slow to load due to network conditions"];
}

+(UIColor*) getKunanceBlueColor
{
    return [UIColor colorWithRed:15/255.0 green:125/255.0 blue:255/255.0 alpha:1.0];
}

+(BOOL) isUITextFieldEmpty:(UITextField*) aTextField
{
    if(aTextField && ![aTextField.text isEqualToString:@""])
        return NO;
    return YES;
}

+(CGFloat) getDeviceWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat) getDeviceHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (UIActivityIndicatorView*) getAndStartBusyIndicator
{
    CGFloat width = 40;
    CGFloat height = 40;
    
    CGFloat navBarHeight = 40;
    
    CGFloat x = [[UIScreen mainScreen] bounds].size.width/2-(width/2);
    CGFloat y = [[UIScreen mainScreen] bounds].size.height/2-navBarHeight-(height/2);
    
    UIActivityIndicatorView* busyIndicator = [[UIActivityIndicatorView alloc]
                                              initWithFrame:CGRectMake(x, y, width, height)];
    
    [busyIndicator setColor:[UIColor blackColor]];
    [busyIndicator startAnimating];
    
    return busyIndicator;
}

+ (NSString *)emptyIfNil:(NSString *)string
{
    if( (id)string == [NSNull null] ) return @"";
    if(!string)
    {
        return @"";
    }
    
    if((id)string == [NSNull null])
    {
        return @"";
    }
    
    if([string isEqualToString:@"null"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return @"";
    }
    
    return string;
}


@end
