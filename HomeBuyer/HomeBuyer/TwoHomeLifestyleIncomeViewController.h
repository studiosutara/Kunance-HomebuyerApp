//
//  TwoHomeRentVsBuyViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwoHomeLifestyleDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface TwoHomeLifestyleIncomeViewController : UIViewController
@property (nonatomic, strong) UINavigationItem* navItem;

@property (nonatomic, weak) id <TwoHomeLifestyleDelegate> mTwoHomeLifestyleDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mRentalLifeStyleIncome;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nickname;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nickname;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nicknamex2;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nicknamex2;

@property (nonatomic, strong) IBOutlet UILabel* mHome1CashFlow;
@property (nonatomic, strong) IBOutlet UILabel* mHome2CashFlow;

@property (nonatomic, strong) IBOutlet UIView* mHome2CashView;
@property (nonatomic, strong) IBOutlet UIView* mTimeView;
@property (nonatomic, strong) IBOutlet UILabel* mDifferenceTitle;
@property (nonatomic, strong) IBOutlet UILabel* mHome1CashFlowDifference;
@property (nonatomic, strong) IBOutlet UILabel* mHome2CashFlowDifference; 

@property (nonatomic, strong) IBOutlet UIButton* mMonthlyCashFlowButton;
-(IBAction)monthlyButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* mAnnualCashFlowButton;
-(IBAction)annualButtonTapped:(id)sender;

@end
