//
//  OneHomePaymentViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoEntryViewController.h"

@protocol OneHomePaymentViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface OneHomePaymentViewController : UIViewController
@property (nonatomic, weak) id <OneHomePaymentViewDelegate> mOneHomePaymentViewDelegate;

@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName;
@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName2;
@property (nonatomic, strong) IBOutlet UIImageView* mHomeTypeIcon;

@property (nonatomic, strong) IBOutlet UILabel* mHome1ComparePayment;
@property (nonatomic, strong) IBOutlet UILabel* rentComparePayment;
@property (nonatomic, strong) IBOutlet UIView* mHomePaymentView;

@property (nonatomic, strong) IBOutlet UIView* mTimeView;
@property (nonatomic, strong) IBOutlet UILabel* mChartTitle;
@property (nonatomic, strong) IBOutlet UILabel* mDifferenceTitle;
@property (nonatomic, strong) IBOutlet UILabel* mPaymentsDifference;

@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;

@property (nonatomic) IBOutlet UIButton* mAddAHomeButton;
-(IBAction)addAHomeTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mMonthlyPaymentButton;
-(IBAction)monthlyButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mAnnualPaymentButton;
-(IBAction)annualButtonTapped:(id)sender;
@end
