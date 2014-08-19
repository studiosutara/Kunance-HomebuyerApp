//
//  LeftMenuViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SECTION_USER_NAME_DASH_REALTOR 0
#define ROW_DASHBOARD 0
#define ROW_REALTOR 1

#define SECTION_HOMES 1
#define ROW_FIRST_HOME 0
#define ROW_SECOND_HOME 1

#define SECTION_LOAN 2
#define ROW_LOAN_INFO 0

#define SECTION_USER_PROFILE 3
#define ROW_CURRENT_LIFESTYLE 0
#define ROW_YOUR_PROFILE 1
#define ROW_FIXED_COSTS 2


#define SECTION_INFO 4
//#define ROW_HELP_CENTER 0
#define ROW_TERMS_AND_POLICIES 0
#define ROW_LOGOUT 1


@protocol LeftMenuDelegate <NSObject>
-(void) showFrontViewForSection:(NSInteger) section andRow:(NSInteger) row;
@end

@interface LeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <LeftMenuDelegate> mLeftMenuDelegate;
@end
