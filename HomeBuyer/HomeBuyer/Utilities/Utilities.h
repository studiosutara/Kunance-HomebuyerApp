//
//  Utilities.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface Utilities : NSObject
+ (BOOL)isValidEmail:(NSString*)emailString;
+(UIAlertView*) showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg;
+(UIAlertView*) showSlowConnectionAlert;
+(BOOL) isUITextFieldEmpty:(UITextField*) aTextField;
+(CGFloat) getDeviceWidth;
+(CGFloat) getDeviceHeight;
+(UIColor*) getKunanceBlueColor;
+ (UIActivityIndicatorView*) getAndStartBusyIndicator;
+(NSString*)getCurrencyFormattedStringForNumber:(NSNumber*) amount;
+(MBProgressHUD*) getHUDViewWithText:(NSString*) text onView:(UIView*) view;
+ (NSString *)emptyIfNil:(NSString *)string;
+(UIImage *)takeSnapshotOfView:(UIView*) view;
@end
