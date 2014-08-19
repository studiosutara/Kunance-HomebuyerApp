//
//  OneHomeLifeStyleViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeLifeStyleViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface HomeLifeStyleViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomeLifeStyleChart;
@end

@implementation HomeLifeStyleViewController
{
    NSDictionary* homePayments;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomeLifeStyleDelegate setNavTitle:@"Cash Flow"];
}

-(void) setupOtherLabels
{
    homeInfo* home = [[kunanceUser getInstance].mKunanceUserHomes
                      getHomeAtIndex:[self.mHomeNumber intValue]];
    
    if(home)
    {
        if(home.mHomeType == homeTypeCondominium)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-condo.png"];
        }
        else if(home.mHomeType == homeTypeSingleFamily)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        }
        
        self.mCondoSFHLabel.text = home.mIdentifiyingHomeFeature;
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
        NSLog(@"Invalid status to be in home dash lifestyle %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:homeAndLoan];

        float lifestyleIncome = rintf([calculatorHome getMonthlyLifeStyleIncome]);
        
        float homeEstTaxesPaid = [calculatorHome getAnnualFederalTaxesPaid] + [calculatorHome getAnnualStateTaxesPaid];
        homeEstTaxesPaid = rintf(homeEstTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR);
        
        if(lifestyleIncome < 0)
        {
            self.mHomeLifeStyleIncome.textColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:30.0/255.0 alpha:1.0];
        }
        else
        {
            self.mHomeLifeStyleIncome.textColor = [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0];
        }
        
        self.mHomeLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                          [NSNumber numberWithLong:lifestyleIncome]];
        
        float totalFixedCosts = [[kunanceUser getInstance].mkunanceUserProfileInfo getOtherFixedCostsInfo] +
        [[kunanceUser getInstance].mkunanceUserProfileInfo getCarPaymentsInfo] +
        [[kunanceUser getInstance].mkunanceUserProfileInfo getHealthInsuranceInfo];
        
        self.mFixedCosts.text = [Utilities getCurrencyFormattedStringForNumber:
                                 [NSNumber numberWithLong:totalFixedCosts]];
        
        self.mEstIncomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:
                                     [NSNumber numberWithLong:homeEstTaxesPaid]];
        
        self.mTotalPayments.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithFloat:rintf([homeAndLoan getTotalMonthlyPayment])]];
        
        // create the data
        homePayments = @{@"Cash Flow" : [NSNumber numberWithFloat:lifestyleIncome],
                         @"Fixed Costs" : [NSNumber numberWithInt:totalFixedCosts],
                         @"Est. Income Tax" : [NSNumber numberWithFloat:homeEstTaxesPaid],
                         @"Monthly Payment" : [NSNumber numberWithFloat:rintf([homeAndLoan getTotalMonthlyPayment])]};
        
        if (IS_WIDESCREEN)
        {
            self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(60, 100, 190, 190)];
        }
        else
        {
            self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(73, 115, 170, 170)];
        }
        
        self.mHomeLifeStyleChart.autoresizingMask =  ~UIViewAutoresizingNone;
        self.mHomeLifeStyleChart.licenseKey = SHINOBI_LICENSE_KEY;
        
        // this view controller acts as the datasource
        self.mHomeLifeStyleChart.datasource = self;
        self.mHomeLifeStyleChart.delegate = self;
        self.mHomeLifeStyleChart.legend.hidden = YES;
        self.mHomeLifeStyleChart.backgroundColor = [UIColor clearColor];
        self.mHomeLifeStyleChart.plotAreaBackgroundColor = [UIColor clearColor];
        
        [self.view addSubview:self.mHomeLifeStyleChart];
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
        self.mLifestyleView.frame = CGRectMake(self.mLifestyleView.frame.origin.x, 300, self.mLifestyleView.frame.size.width, self.mLifestyleView.frame.size.height);
    }
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
    [colors addObject:[UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.8]];
    [colors addObject:[UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:0.9]];
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
