//
//  TwoHomeRentVsBuyViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeLifestyleIncomeViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"


@interface TwoHomeLifestyleIncomeViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mLifestyleIncomeChart;
@property (nonatomic, strong) SChartNumberAxis* xAxis;
@property (nonatomic) float mHome1MonthlyCashFlow;
@property (nonatomic) float mHome1AnnualCashFlow;
@property (nonatomic) float mHome2MonthlyCashFlow;
@property (nonatomic) float mHome2AnnualCashFlow;
@property (nonatomic) float mRentalMonthlyCashFlow;
@property (nonatomic) float mRentalAnnualCashFlow;
@property (nonatomic) float mHome1MonthlyCashFlowDifference;
@property (nonatomic) float mHome1AnnualCashFlowDifference;
@property (nonatomic) float mHome2MonthlyCashFlowDifference;
@property (nonatomic) float mHome2AnnualCashFlowDifference;
@end

@implementation TwoHomeLifestyleIncomeViewController
{
    NSDictionary* mLifestyleIncomeData[3];
}

-(void) setupChart
{    
    if (IS_WIDESCREEN)
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 240, 190, 160)];
    }
    else
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 275, 190, 140)];
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
    
    self.mLifestyleIncomeChart.clipsToBounds = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeLifestyleDelegate setNavTitle:@"Cash Flow"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    homeInfo* home2 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:SECOND_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];

    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 2 home lifestyle %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(home1 && home2 && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan1 = [kunanceUser getCalculatorHomeAndLoanFrom:home1 andLoan:aLoan];
        homeAndLoanInfo* homeAndLoan2 = [kunanceUser getCalculatorHomeAndLoanFrom:home2 andLoan:aLoan];

        kCATCalculator* home1Calc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                        andHome:homeAndLoan1];
        
        kCATCalculator* home2Calc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                        andHome:homeAndLoan2];
        
        kCATCalculator* rentalCalc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                         andHome:nil];
        

        self.mRentalMonthlyCashFlow  = rintf([rentalCalc getMonthlyLifeStyleIncome]);
        self.mRentalAnnualCashFlow = self.mRentalMonthlyCashFlow * NUMBER_OF_MONTHS_IN_YEAR;
        
        self.mHome1MonthlyCashFlow = rintf([home1Calc getMonthlyLifeStyleIncome]);
        self.mHome2MonthlyCashFlow = rintf([home2Calc getMonthlyLifeStyleIncome]);
        self.mHome1AnnualCashFlow = self.mHome1MonthlyCashFlow * NUMBER_OF_MONTHS_IN_YEAR;
        self.mHome2AnnualCashFlow = self.mHome2MonthlyCashFlow * NUMBER_OF_MONTHS_IN_YEAR;
        
        self.mHome1MonthlyCashFlowDifference = fabsf(self.mRentalMonthlyCashFlow - self.mHome1MonthlyCashFlow);
        self.mHome1AnnualCashFlowDifference = fabsf(self.mRentalAnnualCashFlow - self.mHome1AnnualCashFlow);
        self.mHome2MonthlyCashFlowDifference = fabsf(self.mRentalMonthlyCashFlow - self.mHome2MonthlyCashFlow);
        self.mHome2AnnualCashFlowDifference = fabsf(self.mRentalAnnualCashFlow - self.mHome2AnnualCashFlow);
        
        mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithInteger:self.mRentalMonthlyCashFlow]};
        mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.mHome1MonthlyCashFlow]};
        mLifestyleIncomeData[2] = @{@"" : [NSNumber numberWithFloat:self.mHome2MonthlyCashFlow]};

        self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1MonthlyCashFlow]];
        self.mHome2CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2MonthlyCashFlow]];
        self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                            [NSNumber numberWithFloat:self.mRentalMonthlyCashFlow]];
        self.mHome1CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1MonthlyCashFlowDifference]];
        self.mHome2CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2MonthlyCashFlowDifference]];
        
        self.mHome1Nickname.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nickname.text = home2.mIdentifiyingHomeFeature;
        self.mHome1Nicknamex2.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nicknamex2.text = home2.mIdentifiyingHomeFeature;
        
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2CashView.frame = CGRectMake(self.mHome2CashView.frame.origin.x, 330, self.mHome2CashView.frame.size.width, self.mHome2CashView.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 220, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyCashFlowButton.selected = true;
    
    [self setupChart];
}

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 3;
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
  //      lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.8];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.9];
    }
    if(index == 1) {
   //     lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:175.0/255.0 green:122.0/255.0 blue:196.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
    }
    if(index == 2) {
     //    lineSeries.title = @"Home 2";
     lineSeries.style.areaColor = [UIColor colorWithRed:163.0/255.0 green:255.0/255.0 blue:249.0/255.0 alpha:0.8];
     lineSeries.style.areaColorGradient = [UIColor colorWithRed:130.0/255.0 green:204.0/255.0 blue:199.0/255.0 alpha:0.9];
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

- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyCashFlowButton.selected = true;
    self.mAnnualCashFlowButton.selected = false;
    
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    
    mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithInteger:self.mRentalMonthlyCashFlow]};
    mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.mHome1MonthlyCashFlow]};
    mLifestyleIncomeData[2] = @{@"" : [NSNumber numberWithFloat:self.mHome2MonthlyCashFlow]};
    
    self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1MonthlyCashFlow]];
    self.mHome2CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2MonthlyCashFlow]];
    self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                        [NSNumber numberWithFloat:self.mRentalMonthlyCashFlow]];
    self.mHome1CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1MonthlyCashFlowDifference]];
    self.mHome2CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2MonthlyCashFlowDifference]];
    
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
    
    mLifestyleIncomeData[0] = @{@"" : [NSNumber numberWithInteger:self.mRentalAnnualCashFlow]};
    mLifestyleIncomeData[1] = @{@"" : [NSNumber numberWithFloat:self.mHome1AnnualCashFlow]};
    mLifestyleIncomeData[2] = @{@"" : [NSNumber numberWithFloat:self.mHome2AnnualCashFlow]};
    
    self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1AnnualCashFlow]];
    self.mHome2CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2AnnualCashFlow]];
    self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                        [NSNumber numberWithFloat:self.mRentalAnnualCashFlow]];
    self.mHome1CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome1AnnualCashFlowDifference]];
    self.mHome2CashFlowDifference.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.mHome2AnnualCashFlowDifference]];
    
    self.mDifferenceTitle.text = @"Annual Difference";
    
    [self.mLifestyleIncomeChart reloadData];
    [self.mLifestyleIncomeChart redrawChartIncludePlotArea:(YES)];
}
/*
- (void)sChartRenderFinished:(ShinobiChart *)chart
{
    
        SChartSeries *myBarSeries = [chart.series objectAtIndex:0];
        
        for (SChartDataPoint *dp in myBarSeries.dataSeries.dataPoints)
        {
            SChartAnnotation *a = [SChartAnnotation annotationWithText:[NSString stringWithFormat:@"%d",[dp.xValue intValue]]
                                                               andFont:nil
                                                             withXAxis:chart.xAxis
                                                              andYAxis:chart.yAxis
                                                           atXPosition:dp.xValue
                                                          andYPosition:dp.yValue
                                                         withTextColor:[UIColor blackColor]
                                                   withBackgroundColor:[UIColor clearColor]];
            
            [chart addAnnotation:a];
            CGRect f = a.label.frame;
            f.origin.x -= f.size.width/2.f;
            a.label.frame = f;
        }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
