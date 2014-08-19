//
//  HomeAddressViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormNoScrollViewViewController.h"
#import "HTAutocompleteTextField.h"

@protocol HomeAddressViewDelegate <NSObject>
-(void) popHomeAddressFromHomeInfo;
@end

@interface HomeAddressViewController : FormNoScrollViewViewController
@property (nonatomic, strong) homeAddress* mCorrespondingHomeInfo;

@property (nonatomic, strong) IBOutlet UITextField* mStreetAddress;
@property (nonatomic, strong) IBOutlet UITextField* mState;
@property (nonatomic, strong) IBOutlet HTAutocompleteTextField* mCity;

@property (nonatomic, weak) id <HomeAddressViewDelegate> mHomeAddressViewDelegate;
@end
