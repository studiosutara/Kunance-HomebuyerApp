//
//  OneHomeTaxSavingsViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneHomeTaxSavingsViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface OneHomeTaxSavingsViewController : UIViewController
@property (nonatomic, weak) id <OneHomeTaxSavingsViewDelegate> mOneHomeTaxSavingsDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxSavings;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxesPaidWithHome;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxPaidWithRental;

@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName;
@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName2;
@property (nonatomic, strong) IBOutlet UIImageView* mHomeTypeIcon;
@property (nonatomic, strong) IBOutlet UIView* mTaxSavingsView;

@property (nonatomic, strong) IBOutlet UIView* mTimeView;
@property (nonatomic, strong) IBOutlet UILabel* mChartTitle;
@property (nonatomic, strong) IBOutlet UILabel* mDifferenceTitle;

@property (nonatomic, strong) IBOutlet UIButton* mMonthlyTaxButton;
-(IBAction)monthlyButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mAnnualTaxButton;
-(IBAction)annualButtonTapped:(id)sender;

@end
