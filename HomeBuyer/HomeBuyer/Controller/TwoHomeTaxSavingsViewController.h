//
//  TwoHomeTaxSavingsViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>

@protocol TwoHomeTaxSavingsDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface TwoHomeTaxSavingsViewController : UIViewController 
@property (nonatomic, strong) IBOutlet UILabel* mEstFirstHomeTaxes;
@property (nonatomic, strong) IBOutlet UILabel* mEstSecondHomeTaxes;
@property (nonatomic, strong) IBOutlet UILabel* mEstRentalUnitTaxes;

@property (nonatomic, strong) IBOutlet UIImageView* mFirstHomeType;
@property (nonatomic, strong) IBOutlet UIImageView* mSecondHomeType;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nickname;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nickname;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nicknamex2;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nicknamex2;

@property (nonatomic, strong) IBOutlet UILabel* mHome1TaxSavings;
@property (nonatomic, strong) IBOutlet UILabel* mHome2TaxSavings;

@property (nonatomic, strong) IBOutlet UIView* mHome2TaxCompareView;

@property (nonatomic, strong) ShinobiChart* mTaxSavingsChart;

@property (nonatomic, weak) id <TwoHomeTaxSavingsDelegate> mTwoHomeTaxSavingsDelegate;

@property (nonatomic, strong) IBOutlet UIView* mTimeView;
@property (nonatomic, strong) IBOutlet UILabel* mDifferenceTitle;

@property (nonatomic, strong) IBOutlet UIButton* mMonthlyTaxesDueButton;
-(IBAction)monthlyButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mAnnualTaxesDueButton;
-(IBAction)annualButtonTapped:(id)sender;
@end
