//
//  Dash1HomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define NUMBER_OF_SERIES 2
#define NUMBER_OF_DATAPOINTS 2

#define RENTAL_SERIES_INDEX 0
#define HOME_SERIES_INDEX 1

#define LIFESTYLE_DATAPOINT_INDEX 0
#define MONTHLY_PAYMENT_DATAPOINT_INDEX 1

#import "OneHomeLifestyleViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface OneHomeLifestyleViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mLifestyleIncomeChart;
@property (nonatomic, strong) SChartNumberAxis* xAxis;
@property (nonatomic) float homeLifeStyleIncome;
@property (nonatomic) float rentLifestyleIncome;
@property (nonatomic) float homeLifeStyleIncomeAnnual;
@property (nonatomic) float rentLifestyleIncomeAnnual;
@property (nonatomic) float cashFlowDifference;
@property (nonatomic) float cashFlowDifferenceAnnual;
@end

@implementation OneHomeLifestyleViewController
{
    NSDictionary* mLifestyleIncomeData[2];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomeLifestyleViewDelegate setNavTitle:@"Cash Flow"];
}

-(void) setupChart
{
    if (IS_WIDESCREEN)
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 180, 190, 160)];
    }
    else
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 210, 190, 160)];
    }
    
    self.mLifestyleIncomeChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mLifestyleIncomeChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init]; //allocating y-Axis
    yAxis.style.interSeriesPadding = @0;
    self.mLifestyleIncomeChart.yAxis = yAxis;
    self.mLifestyleIncomeChart.backgroundColor = [UIColor clearColor];
    self.xAxis = [[SChartNumberAxis alloc] init]; //allocation x-Axis
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    yAxis.title = @"Cash Flow ($)";
    self.mLifestyleIncomeChart.xAxis = self.xAxis;
    self.mLifestyleIncomeChart.legend.hidden = YES;
    self.mLifestyleIncomeChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mLifestyleIncomeChart.gesturePanType = SChartGesturePanTypeNone;
    
    self.xAxis.style.majorTickStyle.showTicks = YES; //setting tick properties
    self.xAxis.style.minorTickStyle.showTicks = NO;
    self.xAxis.style.majorTickStyle.lineColor = [UIColor grayColor];
    self.xAxis.style.majorTickStyle.lineWidth = @0.5;
    self.xAxis.style.lineWidth = @1; //setting axis width
    yAxis.style.lineWidth = @1;
    
    self.mLifestyleIncomeChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mLifestyleIncomeChart];
    
    self.mLifestyleIncomeChart.datasource = self;
    self.mLifestyleIncomeChart.delegate = self;
    // show the legend
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
   
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 1 home lifestyle %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorRent = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                             andHome:nil];
        
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                             andHome:homeAndLoan];
        
        self.homeLifeStyleIncome = rintf([calculatorHome getMonthlyLifeStyleIncome]);
        self.rentLifestyleIncome = rintf([calculatorRent getMonthlyLifeStyleIncome]);
        self.cashFlowDifference = fabsf(self.rentLifestyleIncome - self.homeLifeStyleIncome);
        
        self.homeLifeStyleIncomeAnnual = rintf([calculatorHome getMonthlyLifeStyleIncome] * NUMBER_OF_MONTHS_IN_YEAR);
        self.rentLifestyleIncomeAnnual = rintf([calculatorRent getMonthlyLifeStyleIncome] * NUMBER_OF_MONTHS_IN_YEAR);
        self.cashFlowDifferenceAnnual = fabsf(self.rentLifestyleIncomeAnnual - self.homeLifeStyleIncomeAnnual);

        self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.homeLifeStyleIncome]];
        self.mRentalCashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentLifestyleIncome]];
        self.mCashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.cashFlowDifference]];
        
        mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithFloat:self.rentLifestyleIncome]};
        self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                            [NSNumber numberWithLong:self.rentLifestyleIncome]];
        
        mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.homeLifeStyleIncome]};
        self.mHomeLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                          [NSNumber numberWithLong:self.homeLifeStyleIncome]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        self.mHomeNickName2.text = aHome.mIdentifiyingHomeFeature;
            
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mCompareView.frame = CGRectMake(0, 310, self.mCompareView.frame.size.width, self.mCompareView.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 175, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyCashFlowButton.selected = true;
    self.mChartTitle.text = @"Monthly Cash Flow";
    self.mDifferenceTitle.text = @"Monthly Difference";
    
    [self setupChart];
}

#pragma mark actions, gesture etc
-(void) addAHome
{
}
#pragma end

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartBarSeries *lineSeries = [[SChartBarSeries alloc] init];
    lineSeries.style.lineColor = [UIColor clearColor];
    lineSeries.style.showArea = YES;
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.animationEnabled = YES;

    SChartAnimation *animation = [SChartAnimation growHorizontalAnimation];
    animation.duration = @1;
    animation.xScaleCurve = [[SChartLinearAnimationCurve alloc] init];
    lineSeries.entryAnimation = [animation copy];
    
    if(index == 0) {
     //   lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.8];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.9];
    }
    else if(index == 1) {
     //   lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
    }

    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mLifestyleIncomeData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = mLifestyleIncomeData[seriesIndex][key];
    datapoint.yValue = key;
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyCashFlowButton.selected = true;
    self.mAnnualCashFlowButton.selected = false;
    
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    
    self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.homeLifeStyleIncome]];
    self.mRentalCashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentLifestyleIncome]];
    self.mCashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.cashFlowDifference]];
    
    mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithFloat:self.rentLifestyleIncome]};
    self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                        [NSNumber numberWithLong:self.rentLifestyleIncome]];
    
    mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.homeLifeStyleIncome]};
    self.mHomeLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                      [NSNumber numberWithLong:self.homeLifeStyleIncome]];
    
    self.mDifferenceTitle.text = @"Monthly Difference";
    
    [self.mLifestyleIncomeChart reloadData];
    [self.mLifestyleIncomeChart redrawChartIncludePlotArea:(YES)];
}

- (IBAction)annualButtonTapped:(id)sender
{
    self.mMonthlyCashFlowButton.selected = false;
    self.mAnnualCashFlowButton.selected = true;
    
    self.xAxis.rangePaddingHigh = @5000.0;
    self.xAxis.majorTickFrequency = @10000;
    
    self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.homeLifeStyleIncomeAnnual]];
    self.mRentalCashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentLifestyleIncomeAnnual]];
    self.mCashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.cashFlowDifferenceAnnual]];
    
    mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithFloat:self.rentLifestyleIncomeAnnual]};
    self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                        [NSNumber numberWithLong:self.rentLifestyleIncomeAnnual]];
    
    mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.homeLifeStyleIncomeAnnual]};
    self.mHomeLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                      [NSNumber numberWithLong:self.homeLifeStyleIncomeAnnual]];

    self.mDifferenceTitle.text = @"Annual Difference";
    
    [self.mLifestyleIncomeChart reloadData];
    [self.mLifestyleIncomeChart redrawChartIncludePlotArea:(YES)];
}

@end
