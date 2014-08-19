//
//  Dash2HomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomePaymentViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"


@interface TwoHomePaymentViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mMontlyPaymentChart;
@property (nonatomic, strong) SChartNumberAxis* xAxis;
@property (nonatomic) float home1Payment;
@property (nonatomic) float home1AnnualPayment;
@property (nonatomic) float home2Payment;
@property (nonatomic) float home2AnnualPayment;
@property (nonatomic) float rent;
@property (nonatomic) float rentAnnual;
@property (nonatomic) float home1MonthlyPaymentDelta;
@property (nonatomic) float home2MonthlyPaymentDelta;
@property (nonatomic) float home1AnnualPaymentDelta;
@property (nonatomic) float home2AnnualPaymentDelta;
@end

@implementation TwoHomePaymentViewController
{
    NSDictionary* mMonthlyPaymentData[3];
}

-(void) setupChart
{
    if (IS_WIDESCREEN)
    {
        self.mMontlyPaymentChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 240, 190, 160)];
    }
    else
    {
        self.mMontlyPaymentChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 275, 190, 140)];
    }
    
    self.mMontlyPaymentChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mMontlyPaymentChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init]; //allocating y-Axis
    yAxis.style.interSeriesPadding = @0;
    self.mMontlyPaymentChart.yAxis = yAxis;
    yAxis.title = @"Payment ($)";
    self.mMontlyPaymentChart.backgroundColor = [UIColor clearColor];
    self.xAxis = [[SChartNumberAxis alloc] init];
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    self.mMontlyPaymentChart.xAxis = self.xAxis;
    self.mMontlyPaymentChart.legend.hidden = YES;
    self.mMontlyPaymentChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mMontlyPaymentChart.gesturePanType = SChartGesturePanTypeNone;
    
    self.xAxis.style.majorTickStyle.showTicks = YES; //setting tick properties
    self.xAxis.style.minorTickStyle.showTicks = NO;
    self.xAxis.style.majorTickStyle.lineColor = [UIColor grayColor];
    self.xAxis.style.majorTickStyle.lineWidth = @0.5;
    self.xAxis.style.lineWidth = @1; //setting axis width
    yAxis.style.lineWidth = @1;
    
    self.mMontlyPaymentChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mMontlyPaymentChart];
    
    self.mMontlyPaymentChart.datasource = self;
    self.mMontlyPaymentChart.delegate = self;
    // show the legend
    
    self.mMontlyPaymentChart.clipsToBounds = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomePaymentDelegate setNavTitle:@"Total Payment"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    homeInfo* home2 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:SECOND_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    userProfileInfo* userProfile = [kunanceUser getInstance].mkunanceUserProfileInfo;
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 2 home payment %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(home1 && home2 && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan1 = [kunanceUser getCalculatorHomeAndLoanFrom:home1 andLoan:aLoan];
        homeAndLoanInfo* homeAndLoan2 = [kunanceUser getCalculatorHomeAndLoanFrom:home2 andLoan:aLoan];
        
        self.home1Payment = rintf([homeAndLoan1 getTotalMonthlyPayment]);
        self.home2Payment = rintf([homeAndLoan2 getTotalMonthlyPayment]);
        
        self.home1AnnualPayment = self.home1Payment * NUMBER_OF_MONTHS_IN_YEAR;
        self.home2AnnualPayment = self.home2Payment * NUMBER_OF_MONTHS_IN_YEAR;
        
        self.rent = [userProfile getMonthlyRentInfo];
        self.rentAnnual = self.rent * NUMBER_OF_MONTHS_IN_YEAR;
        
        self.home1MonthlyPaymentDelta = fabsf(self.home1Payment - self.rent);
        self.home2MonthlyPaymentDelta = fabsf(self.home2Payment - self.rent);
        self.home1AnnualPaymentDelta = fabsf(self.home1AnnualPayment - self.rentAnnual);
        self.home2AnnualPaymentDelta = fabsf(self.home2AnnualPayment - self.rentAnnual);
        
        mMonthlyPaymentData[0] =  @{@"" :
                                        [NSNumber numberWithInteger:self.rent]};
        mMonthlyPaymentData[1] =  @{@"" :
                                        [NSNumber numberWithFloat:self.home1Payment]};
        mMonthlyPaymentData[2] =  @{@"" :
                                        [NSNumber numberWithFloat:self.home2Payment]};

        self.mRentalPayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rent]];
        self.mHome1Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1Payment]];
        self.mHome2Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2Payment]];
        
        self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1MonthlyPaymentDelta]];
        self.mHome2ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2MonthlyPaymentDelta]];
        
        self.mHome1Nickname.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nickname.text = home2.mIdentifiyingHomeFeature;
        self.mHome1Nicknamex2.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nicknamex2.text = home2.mIdentifiyingHomeFeature;
        
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2ComparePaymentsView.frame = CGRectMake(self.mHome2ComparePaymentsView.frame.origin.x, 330, self.mHome2ComparePaymentsView.frame.size.width, self.mHome2ComparePaymentsView.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 220, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyPaymentButton.selected = true;
    
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
     //   lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.9];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
    }
    if(index == 1) {
        //  lineSeries.title = @"Home 1";
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
    NSString* key = mMonthlyPaymentData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = mMonthlyPaymentData[seriesIndex][key];
    datapoint.yValue = key;
    return datapoint;
}


- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyPaymentButton.selected = true;
    self.mAnnualPaymentButton.selected = false;
    
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    
    mMonthlyPaymentData[0] =  @{@"" :
                                    [NSNumber numberWithInteger:self.rent]};
    mMonthlyPaymentData[1] =  @{@"" :
                                    [NSNumber numberWithFloat:self.home1Payment]};
    mMonthlyPaymentData[2] =  @{@"" :
                                    [NSNumber numberWithFloat:self.home2Payment]};
    
    self.mRentalPayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rent]];
    self.mHome1Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1Payment]];
    self.mHome2Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2Payment]];
    
    self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1MonthlyPaymentDelta]];
    self.mHome2ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2MonthlyPaymentDelta]];
    
    self.mDifferenceTitle.text = @"Monthly Payment Difference";
    
    [self.mMontlyPaymentChart reloadData];
    [self.mMontlyPaymentChart redrawChartIncludePlotArea:(YES)];
}

- (IBAction)annualButtonTapped:(id)sender
{
    self.mMonthlyPaymentButton.selected = false;
    self.mAnnualPaymentButton.selected = true;
    
    self.xAxis.rangePaddingHigh = @5000.0;
    self.xAxis.majorTickFrequency = @10000;
    
    mMonthlyPaymentData[0] =  @{@"" :
                                    [NSNumber numberWithInteger:self.rentAnnual]};
    mMonthlyPaymentData[1] =  @{@"" :
                                    [NSNumber numberWithFloat:self.home1AnnualPayment]};
    mMonthlyPaymentData[2] =  @{@"" :
                                    [NSNumber numberWithFloat:self.home2AnnualPayment]};
    
    self.mRentalPayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentAnnual]];
    self.mHome1Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1AnnualPayment]];
    self.mHome2Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2AnnualPayment]];
    
    self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1AnnualPaymentDelta]];
    self.mHome2ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2AnnualPaymentDelta]];
    
    self.mDifferenceTitle.text = @"Annual Payment Difference";
    
    [self.mMontlyPaymentChart reloadData];
    [self.mMontlyPaymentChart redrawChartIncludePlotArea:(YES)];
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
