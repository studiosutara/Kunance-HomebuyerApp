//
//  OneHomeLifeStyleViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeLifeStyleDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end



@interface HomeLifeStyleViewController : UIViewController
@property (nonatomic, weak) id <HomeLifeStyleDelegate> mHomeLifeStyleDelegate;
@property (nonatomic, strong) NSNumber* mHomeNumber;

@property (nonatomic, strong) IBOutlet UIImageView* mCondoSFHIndicator;
@property (nonatomic, strong) IBOutlet UILabel* mCondoSFHLabel;
@property (nonatomic, strong) IBOutlet UILabel* mHomeListPrice;
@property (nonatomic, strong) IBOutlet UILabel* mHomeLifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mEstIncomeTaxes;
@property (nonatomic, strong) IBOutlet UILabel* mFixedCosts;
@property (nonatomic, strong) IBOutlet UILabel* mTotalPayments;
@property (nonatomic, strong) IBOutlet UIView* mLifestyleView;
@end
