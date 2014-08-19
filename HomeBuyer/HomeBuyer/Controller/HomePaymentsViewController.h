//
//  OneHomePaymentsViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePaymentsDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface HomePaymentsViewController : UIViewController
@property (nonatomic, weak) id <HomePaymentsDelegate> mHomePaymentsDelegate;

@property (nonatomic, strong) NSNumber* mHomeNumber;

@property (nonatomic, strong) IBOutlet UILabel* mHomeTitle;
@property (nonatomic, strong) IBOutlet UIImageView* mCondoSFHIndicator;
@property (nonatomic, strong) IBOutlet UILabel*  mHomeListPrice;
@property (nonatomic, strong) IBOutlet UILabel* mTotalMonthlyPayments;
@property (nonatomic, strong) IBOutlet UILabel* mLoanPayment;
@property (nonatomic, strong) IBOutlet UILabel* mHOA;
@property (nonatomic, strong) IBOutlet UILabel* mPropertyTax;
@property (nonatomic, strong) IBOutlet UILabel* mInsurance;
@property (nonatomic, strong) IBOutlet UILabel* mPMI;
@property (nonatomic, strong) IBOutlet UIView* mPaymentsView;

@property (nonatomic, strong) IBOutlet UIButton* mCompareButton;
-(IBAction)compareButtonTapped:(id)sender;
@end
