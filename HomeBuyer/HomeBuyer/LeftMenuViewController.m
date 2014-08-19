//
//  LeftMenuViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()
@property (nonatomic, strong) UITableView* mMenuTableView;
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mMenuTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    CGRect rect = CGRectMake(self.view.bounds.origin.x,
                             self.view.bounds.origin.y+20,
                             [Utilities getDeviceWidth],
                             [Utilities getDeviceHeight]-20);
    
    self.mMenuTableView = [[UITableView alloc] initWithFrame:rect
                                                       style:UITableViewStyleGrouped];
    self.mMenuTableView.dataSource = self;
    self.mMenuTableView.delegate = self;
    self.mMenuTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mMenuTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.mLeftMenuDelegate && [self.mLeftMenuDelegate respondsToSelector:@selector(showFrontViewForSection:andRow:)])
    {
        [self.mLeftMenuDelegate showFrontViewForSection:indexPath.section andRow:indexPath.row];
    }
}

#pragma mark UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width-60, 30.0)];
    header.backgroundColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:(0.9)];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:header.frame];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    [header addSubview:textLabel];
    
    switch ((int)section) {
        case SECTION_USER_NAME_DASH_REALTOR:
            textLabel.text = [NSString stringWithFormat:@"%@",
                               [[[kunanceUser getInstance] getFirstName] uppercaseString]];
            textLabel.textAlignment = NSTextAlignmentCenter;
            break;
            
        case SECTION_HOMES:
            textLabel.text = @"HOMES";
            break;
            
        case SECTION_LOAN:
            textLabel.text = @"LOAN";
            break;
            
        case SECTION_USER_PROFILE:
            textLabel.text = @"PROFILE";
            break;
            
        case SECTION_INFO:
            textLabel.text = @"";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    switch (section)
    {
        case SECTION_USER_NAME_DASH_REALTOR:
                numOfRows = 2;
            break;
            
        case SECTION_HOMES:
            numOfRows = MAX_NUMBER_OF_HOMES_PER_USER;
            break;
            
        case SECTION_LOAN:
            numOfRows = 1;
            break;
            
        case SECTION_USER_PROFILE:
            numOfRows = 3;
            break;
            
        case SECTION_INFO:
            numOfRows = 2;
            break;
            
        default:
            break;
    }
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(void) enableCell:(UITableViewCell*) cell
{
    cell.userInteractionEnabled = YES;
    cell.textLabel.textColor = [UIColor blackColor];
}

-(void) disableCell:(UITableViewCell*) cell
{
    cell.textLabel.textColor = [UIColor grayColor];
    cell.userInteractionEnabled = NO;
}


-(void) updateRowForHomes:(NSIndexPath*) indexPath andCell:(UITableViewCell*) cell
{
    uint count = 0;
    homeInfo* home = nil;
    if([kunanceUser getInstance].mKunanceUserHomes)
    {
        count = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
        home = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:indexPath.row];
    }
    homeType type = homeTypeNotDefined;
    
    if(home)
        type = home.mHomeType;
    
    switch ([kunanceUser getInstance].mUserProfileStatus)
    {
        case ProfileStatusUndefined:
        case ProfileStatusUserPersonalFinanceInfoEntered:
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-add-home-gray.png"];
            [self disableCell:cell];
            if (indexPath.row == ROW_FIRST_HOME)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Add First Home"];
            }
            else if(indexPath.row == ROW_SECOND_HOME)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Add Second Home"];
            }
            break;
        }
            
        case ProfileStatusPersonalFinanceAndFixedCostsInfoEntered:
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-add-home.png"];
            if(indexPath.row == ROW_SECOND_HOME)
            {
                [self disableCell:cell];
                cell.imageView.image = [UIImage imageNamed:@"menu-add-home-gray.png"];
                cell.textLabel.text = [NSString stringWithFormat:@"Add Second Home"];
            }
            else if(indexPath.row == ROW_FIRST_HOME)
            {
                [self enableCell:cell];
                cell.textLabel.text = [NSString stringWithFormat:@"Add First Home"];
            }
            break;
        }
            
        case ProfileStatusUser1HomeInfoEntered:
        case ProfileStatusUser1HomeAndLoanInfoEntered:
        {
            if(indexPath.row == ROW_FIRST_HOME)
            {
                [self enableCell:cell];

                if(type == homeTypeCondominium)
                    cell.imageView.image = [UIImage imageNamed:@"menu-home-condo.png"];
                else if(type == homeTypeSingleFamily)
                    cell.imageView.image = [UIImage imageNamed:@"menu-home-sfh.png"];
                
                if(home && home.mIdentifiyingHomeFeature)
                {
                    cell.textLabel.text = home.mIdentifiyingHomeFeature;
                }
            }

            else if(indexPath.row == ROW_SECOND_HOME)
            {
                cell.imageView.image = [UIImage imageNamed:@"menu-add-home.png"];
                cell.textLabel.text = [NSString stringWithFormat:@"Add Second Home"];
                [self enableCell:cell];
                
                if([kunanceUser getInstance].mUserProfileStatus ==
                   ProfileStatusUser1HomeInfoEntered)
                {
                    cell.imageView.image = [UIImage imageNamed:@"menu-add-home-gray.png"];
                    [self disableCell:cell];
                }
            }
            
            break;
        }

        case ProfileStatusUserTwoHomesAndLoanInfoEntered:
        {
            [self enableCell:cell];
            if(type == homeTypeCondominium)
                cell.imageView.image = [UIImage imageNamed:@"menu-home-condo.png"];
            else if(type == homeTypeSingleFamily)
                cell.imageView.image = [UIImage imageNamed:@"menu-home-sfh.png"];
            
            if(home && home.mIdentifiyingHomeFeature)
            {
                cell.textLabel.text = home.mIdentifiyingHomeFeature;
            }
            
            break;
        }
            
        default:
            break;
    }
}

-(void) updateRowForUserProfile:(NSIndexPath*) indexPath andCell:(UITableViewCell*) cell
{
    userProfileInfo* userProfile = [kunanceUser getInstance].mkunanceUserProfileInfo;
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
    
    bool userProfileEntered = NO;
    if(status == ProfileStatusUndefined || !userProfile)
        userProfileEntered = NO;
    else
        userProfileEntered = YES;
    
    if(indexPath.row == ROW_CURRENT_LIFESTYLE)
    {
        cell.textLabel.text = @"Current Cash Flow";
        
        if(!userProfileEntered || status == ProfileStatusUndefined ||
           status == ProfileStatusUserPersonalFinanceInfoEntered)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-current-lifestyle-gray.png"];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled = NO;
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-current-lifestyle.png"];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled = YES;
        }
    }
    else if(indexPath.row == ROW_YOUR_PROFILE)
    {
        if(!userProfileEntered)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-create-profile.png"];
            cell.textLabel.text = @"Enter Profile to Start";
        }
        else if([userProfile getMaritalStatus] == StatusSingle)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-profile-single.png"];
            cell.textLabel.text = @"Profile & Income";
        }
        else if ([userProfile getMaritalStatus] == StatusMarried)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-profile-couple.png"];
            cell.textLabel.text = @"Profile & Income";
        }
    }
    else if(indexPath.row == ROW_FIXED_COSTS)
    {
        
        if(!userProfileEntered || status == ProfileStatusUndefined)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-fixedcosts-gray.png"];
            cell.textLabel.text = @"Monthly Fixed Costs";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled = NO;
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-fixedcosts.png"];
            cell.textLabel.text = @"Monthly Fixed Costs";
            cell.textLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled = YES;
        }
    }
}

-(void) updateRowForLoanInfo:(NSIndexPath*) indexPath andCell:(UITableViewCell*) cell
{
    if(indexPath.row == ROW_LOAN_INFO)
    {
        kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
        
        cell.textLabel.text = @"Loan Info";
        if(status == ProfileStatusUndefined || status == ProfileStatusUserPersonalFinanceInfoEntered
           || status == ProfileStatusPersonalFinanceAndFixedCostsInfoEntered)
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-loan-info-gray.png"];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled = NO;
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"menu-loan-info.png"];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled = YES;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    switch (indexPath.section)
    {
        case SECTION_USER_NAME_DASH_REALTOR:
            if(indexPath.row == ROW_DASHBOARD)
            {
                cell.textLabel.text = @"Dashboard";
                cell.imageView.image = [UIImage imageNamed:@"menu-dashboard.png"];
            }
            else if(indexPath.row == ROW_REALTOR && [kunanceUser getInstance].mRealtor.mIsValid)
            {
                cell.textLabel.text = @"Contact Your Realtor";
                cell.imageView.image = [UIImage imageNamed:@"menu-contact-realtor.png"];
            }
            else if(indexPath.row == ROW_REALTOR && ![kunanceUser getInstance].mRealtor.mIsValid)
            {
                cell.textLabel.text = @"Add A Realtor";
                cell.imageView.image = [UIImage imageNamed:@"menu-contact-realtor.png"];
            }
            break;
            
        case SECTION_HOMES:
            [self updateRowForHomes:indexPath andCell:cell];
            break;
            
        case SECTION_LOAN:
            [self updateRowForLoanInfo:indexPath andCell:cell];
            break;
            
        case SECTION_USER_PROFILE:
            [self updateRowForUserProfile:indexPath andCell:cell];
            break;

        case SECTION_INFO:
            /*if(indexPath.row == ROW_HELP_CENTER)
            {
                cell.textLabel.text = @"Help Center";
                cell.imageView.image = [UIImage imageNamed:@"menu-help.png"];
            }
            else*/ if(indexPath.row == ROW_TERMS_AND_POLICIES)
            {
                cell.textLabel.text = @"Terms & Policies";
                cell.imageView.image = [UIImage imageNamed:@"menu-terms-and-policies.png"];
            }
            else if(indexPath.row == ROW_LOGOUT)
            {
                cell.textLabel.text = @"Logout";
                cell.imageView.image = [UIImage imageNamed:@"menu-logout.png"];
            }

            break;
            
        default:
            break;
    }
    
    if(cell.imageView)
    {
        cell.imageView.bounds = CGRectMake(0, 0, 25, 25);
    }
    
    return cell;
}

-(void) cellForUserName:(UITableViewCell*) cell
{
    UILabel* label = [[UILabel alloc] initWithFrame:cell.bounds];
    [cell addSubview:label];
    label.text = [NSString stringWithFormat:@"%@",[[kunanceUser getInstance] getFirstName]];
}
@end
