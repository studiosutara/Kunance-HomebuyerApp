//
//  OneHomePaymentsViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomePaymentsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"
#import <MBProgressHUD.h>

@interface HomePaymentsViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomePaymentsChart;
@end

@implementation HomePaymentsViewController
{
    NSDictionary* homePayments;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomePaymentsDelegate setNavTitle:@"Monthly Payment"];
}

-(void) setupOtherLabels
{
    homeInfo* home = [[kunanceUser getInstance].mKunanceUserHomes
                      getHomeAtIndex:[self.mHomeNumber intValue]];

    if(home)
    {
        self.mHomeTitle.text = home.mIdentifiyingHomeFeature;
        
        if(home.mHomeType == homeTypeCondominium)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-condo.png"];
        }
        else if(home.mHomeType == homeTypeSingleFamily)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        }
        
        self.mHomeListPrice.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithLong:home.mHomeListPrice]];
    }
}

-(void) setupChart
{
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:[self.mHomeNumber intValue]];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in home dash payment %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }

    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        
        float mortgage = rintf([homeAndLoan getMonthlyLoanPaymentForHome]);
        self.mLoanPayment.text = [Utilities getCurrencyFormattedStringForNumber:
                                  [NSNumber numberWithFloat:mortgage]];
        
        float propertyTaxes = rintf([homeAndLoan getAnnualPropertyTaxes]/NUMBER_OF_MONTHS_IN_YEAR);
        self.mPropertyTax.text = [Utilities getCurrencyFormattedStringForNumber:
                                  [NSNumber numberWithFloat:propertyTaxes]];
        
        float hoa = rintf(homeAndLoan.mHOAFees);
        self.mHOA.text = [Utilities getCurrencyFormattedStringForNumber:
                          [NSNumber numberWithFloat:hoa]];
        
        float insurance = rintf([homeAndLoan getMonthlyHomeOwnersInsuranceForHome]);
        self.mInsurance.text = [Utilities getCurrencyFormattedStringForNumber:
                                [NSNumber numberWithFloat:insurance]];
        
        float PMI = rintf([homeAndLoan getAnnualPMIForHome]) / NUMBER_OF_MONTHS_IN_YEAR;
        self.mPMI.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithFloat:PMI]];
        
        float totalPayments = rintf([homeAndLoan getTotalMonthlyPayment]);
        
        self.mTotalMonthlyPayments.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithFloat:totalPayments]];
        // create the data
        homePayments = @{@"Mortgage" : [NSNumber numberWithFloat:mortgage],
                         @"HOA" : [NSNumber numberWithFloat:hoa],
                         @"Property Tax" : [NSNumber numberWithFloat:propertyTaxes],
                         @"Insurance" : [NSNumber numberWithFloat:insurance],
                         @"PMI" : [NSNumber numberWithFloat:PMI]};

        if (IS_WIDESCREEN)
        {
            self.mHomePaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(60, 60, 190, 190)];
        }
        else
        {
            self.mHomePaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(73, 65, 160, 160)];
        }
        
        self.mHomePaymentsChart.autoresizingMask =  ~UIViewAutoresizingNone;
        self.mHomePaymentsChart.licenseKey = SHINOBI_LICENSE_KEY;
        
        // this view controller acts as the datasource
        self.mHomePaymentsChart.datasource = self;
        self.mHomePaymentsChart.delegate = self;
        self.mHomePaymentsChart.legend.hidden = YES;
        self.mHomePaymentsChart.backgroundColor = [UIColor clearColor];
        self.mHomePaymentsChart.plotAreaBackgroundColor = [UIColor clearColor];
        
        [self.view addSubview:self.mHomePaymentsChart];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupChart];
    [self setupOtherLabels];
    
    if (IS_WIDESCREEN)
    {
        self.mPaymentsView.frame = CGRectMake(0, 270, self.mPaymentsView.frame.size.width, self.mPaymentsView.frame.size.height);
        self.mCompareButton.frame = CGRectMake(233, 460, self.mCompareButton.frame.size.width, self.mCompareButton.frame.size.height);
    }
}

-(IBAction)compareButtonTapped:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Calculating";

    [NSTimer scheduledTimerWithTimeInterval: 1.0
                                     target: self
                                   selector: @selector(handleTimer)
                                   userInfo: nil
                                    repeats: NO];
}

-(void) handleTimer
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:Nil];
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart
toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint
      inSeries:(SChartRadialSeries *)series
atPixelCoordinate:(CGPoint)pixelPoint
{
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.style.chartEffect = SChartRadialChartEffectBevelledLight;
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.style.labelFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
    pieSeries.style.labelFontColor = [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:0.9];
    pieSeries.labelFormatString = @"%.0f";
    pieSeries.style.showCrust = NO;
    pieSeries.animationEnabled = YES;
    NSMutableArray* colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:127.0/255.0 green:140.0/255.0 blue:141.0/255.0 alpha:0.8]];
    [colors addObject:[UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.8]];
    [colors addObject:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.8]];
    [colors addObject:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:0.8]];
    [colors addObject:[UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.8]];
    pieSeries.style.flavourColors = colors;
    pieSeries.selectedStyle.flavourColors = colors;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return homePayments.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = homePayments.allKeys[dataIndex];
    datapoint.name = key;
    NSNumber* value =  homePayments[key];
    if([value compare:@0] == NSOrderedAscending)
    {
        datapoint.value = @0;
        return datapoint;
    }
    else
    {
        datapoint.value = homePayments[key];
        return datapoint;
    }
}

-(void)sChart:(ShinobiChart *)chart alterLabel:(UILabel *)label forDatapoint:(SChartRadialDataPoint *)datapoint atSliceIndex:(int)index inRadialSeries:(SChartRadialSeries *)series
{
 //   [label sizeToFit];
 //   NSLog(@"Datapoint value %@", datapoint.value);
    if (datapoint.value.intValue == 0)
    {
        label.hidden = YES;
    }
    else
    {
        label.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
