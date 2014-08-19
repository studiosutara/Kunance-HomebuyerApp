//
//  OneHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "OneHomeTaxSavingsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface OneHomeTaxSavingsViewController() <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mEstTaxesChart;
@property (nonatomic, strong) SChartAxis* xAxis;
@property (nonatomic) float monthlyTaxSavings;
@property (nonatomic) float annualTaxSavings;
@property (nonatomic) float homeEstTaxesPaid;
@property (nonatomic) float rentEstTaxesPaid;
@property (nonatomic) float homeEstTaxesPaidMonthly;
@property (nonatomic) float rentEstTaxesPaidMonthly;
@end

@implementation OneHomeTaxSavingsViewController
{
    NSDictionary* mTaxesData[2];
    NSDictionary* oldFont;
}

-(void) setupChart
{
    if (IS_WIDESCREEN)
    {
        self.mEstTaxesChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 180, 190, 160)];
    }
    else
    {
        self.mEstTaxesChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 210, 190, 140)];
    }
    
    self.mEstTaxesChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mEstTaxesChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init]; //allocating y-Axis
    yAxis.style.interSeriesPadding = @0;
    self.mEstTaxesChart.yAxis = yAxis;
    self.mEstTaxesChart.backgroundColor = [UIColor clearColor];
    self.xAxis = [[SChartNumberAxis alloc] init]; //allocation x-Axis
    self.xAxis.rangePaddingHigh = @500.0;
    if (self.rentEstTaxesPaidMonthly < 2000) //setting tick frequency based on the highest number
    {
        self.xAxis.majorTickFrequency = @500;
    }
    else
    {
        self.xAxis.majorTickFrequency = @1000;
    }
    yAxis.title = @"Est. Taxes ($)";
    self.mEstTaxesChart.xAxis = self.xAxis;
    self.mEstTaxesChart.legend.hidden = YES;
    self.mEstTaxesChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mEstTaxesChart.gesturePanType = SChartGesturePanTypeNone;
    
    self.xAxis.style.majorTickStyle.showTicks = YES; //setting tick properties
    self.xAxis.style.minorTickStyle.showTicks = NO;
    self.xAxis.style.majorTickStyle.lineColor = [UIColor grayColor];
    self.xAxis.style.majorTickStyle.lineWidth = @0.5;
    self.xAxis.style.lineWidth = @1; //setting axis width
    yAxis.style.lineWidth = @1;
    
    self.mEstTaxesChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mEstTaxesChart];
    
    self.mEstTaxesChart.datasource = self;
    self.mEstTaxesChart.delegate = self;
    // show the legend
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 1 home taxes %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorRent = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:nil];
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:homeAndLoan];
        
        self.homeEstTaxesPaid = rintf([calculatorHome getAnnualFederalTaxesPaid] + [calculatorHome getAnnualStateTaxesPaid]);
        self.homeEstTaxesPaidMonthly = self.homeEstTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
        
        self.rentEstTaxesPaid = rintf([calculatorRent getAnnualFederalTaxesPaid] + [calculatorRent getAnnualStateTaxesPaid]);
        self.rentEstTaxesPaidMonthly = self.rentEstTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
        
        self.annualTaxSavings = fabsf(self.rentEstTaxesPaid - self.homeEstTaxesPaid);
        self.monthlyTaxSavings = fabsf((self.rentEstTaxesPaid - self.homeEstTaxesPaid)/NUMBER_OF_MONTHS_IN_YEAR);
        
        mTaxesData[0] = @{@"" :[NSNumber numberWithFloat:self.rentEstTaxesPaidMonthly]};
        mTaxesData[1] = @{@"" : [NSNumber numberWithFloat:self.homeEstTaxesPaidMonthly]};
        
        self.mEstTaxPaidWithRental.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithLong:self.rentEstTaxesPaidMonthly]];
        self.mEstTaxesPaidWithHome.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithLong:self.homeEstTaxesPaidMonthly]];
               
        self.mEstTaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithLong:self.monthlyTaxSavings]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        self.mHomeNickName2.text = aHome.mIdentifiyingHomeFeature;    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:oldFont];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomeTaxSavingsDelegate setNavTitle:@"Taxes Due"];
    oldFont = self.navigationController.navigationBar.titleTextAttributes;
    
    UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!IS_WIDESCREEN)
    {
        self.mTaxSavingsView.frame = CGRectMake(0, 310, self.mTaxSavingsView.frame.size.width, self.mTaxSavingsView.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 175, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyTaxButton.selected = true;
    self.mDifferenceTitle.text = @"Monthly Tax Savings";
    
    [self setupChart];
}

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
        lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
    }
    else if(index == 1) {
        lineSeries.title = @"Home 1";
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
    NSString* key = mTaxesData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = mTaxesData[seriesIndex][key];
    datapoint.yValue = key;
    return datapoint;
}

- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyTaxButton.selected = true;
    self.mAnnualTaxButton.selected = false;
    
    
    self.xAxis.rangePaddingHigh = @500.0;
    if (self.rentEstTaxesPaidMonthly < 2000)
    {
        self.xAxis.majorTickFrequency = @500;
    }
    else
    {
        self.xAxis.majorTickFrequency = @1000;
    }
    
    mTaxesData[0] = @{@"" :[NSNumber numberWithFloat:self.rentEstTaxesPaidMonthly]};
    mTaxesData[1] = @{@"" : [NSNumber numberWithFloat:self.homeEstTaxesPaidMonthly]};
    
    self.mEstTaxPaidWithRental.text = [Utilities getCurrencyFormattedStringForNumber:
                                       [NSNumber numberWithLong:self.rentEstTaxesPaidMonthly]];
    self.mEstTaxesPaidWithHome.text = [Utilities getCurrencyFormattedStringForNumber:
                                       [NSNumber numberWithLong:self.homeEstTaxesPaidMonthly]];
    
    self.mEstTaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:
                                [NSNumber numberWithLong:self.monthlyTaxSavings]];
    
    self.mDifferenceTitle.text = @"Monthly Tax Savings";
    
    [self.mEstTaxesChart reloadData];
    [self.mEstTaxesChart redrawChartIncludePlotArea:(YES)];
}

- (IBAction)annualButtonTapped:(id)sender
{
    self.mMonthlyTaxButton.selected = false;
    self.mAnnualTaxButton.selected = true;
    
    if (self.rentEstTaxesPaid < 20000)
    {
        self.xAxis.rangePaddingHigh = @2000.0;
        self.xAxis.majorTickFrequency = @5000;
    }
    else
    {
        self.xAxis.rangePaddingHigh = @5000.0;
        self.xAxis.majorTickFrequency = @10000;
    }
    
    mTaxesData[0] = @{@"" :[NSNumber numberWithFloat:self.rentEstTaxesPaid]};
    mTaxesData[1] = @{@"" : [NSNumber numberWithFloat:self.homeEstTaxesPaid]};
    
    self.mEstTaxPaidWithRental.text = [Utilities getCurrencyFormattedStringForNumber:
                                       [NSNumber numberWithLong:self.rentEstTaxesPaid]];
    self.mEstTaxesPaidWithHome.text = [Utilities getCurrencyFormattedStringForNumber:
                                       [NSNumber numberWithLong:self.homeEstTaxesPaid]];
    
    self.mEstTaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:
                                [NSNumber numberWithLong:self.annualTaxSavings]];

    self.mDifferenceTitle.text = @"Annual Tax Savings";
    
    [self.mEstTaxesChart reloadData];
    [self.mEstTaxesChart redrawChartIncludePlotArea:(YES)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
