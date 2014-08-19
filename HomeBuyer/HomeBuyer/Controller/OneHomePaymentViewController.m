//
//  OneHomePaymentViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "OneHomePaymentViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface OneHomePaymentViewController() <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mPaymentsChart;
@property (nonatomic, strong) SChartNumberAxis* xAxis;
@property (nonatomic) float annualPaymentsDifference;
@property (nonatomic) float monthlyPaymentsDifference;
@property (nonatomic) float monthlyMortgagePayment;
@property (nonatomic) float annualMortgagePayment;
@property (nonatomic) float annualRentPayment;
@property (nonatomic) float monthlyRentPayment;
@end

@implementation OneHomePaymentViewController
{
    NSDictionary* mPaymentData[2];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setupChart
{ 
    if (IS_WIDESCREEN)
    {
        self.mPaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 180, 190, 160)];
    }
    else
    {
        self.mPaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 210, 190, 160)];
    }
    
    self.mPaymentsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mPaymentsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init]; //allocating y-Axis
    yAxis.style.interSeriesPadding = @0;
    self.mPaymentsChart.yAxis = yAxis;
    self.mPaymentsChart.backgroundColor = [UIColor clearColor];
    self.xAxis = [[SChartNumberAxis alloc] init]; //allocation x-Axis
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    yAxis.title = @"Payment ($)";
    self.mPaymentsChart.xAxis = self.xAxis;
    self.mPaymentsChart.legend.hidden = YES;
    self.mPaymentsChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mPaymentsChart.gesturePanType = SChartGesturePanTypeNone;
    
    self.xAxis.style.majorTickStyle.showTicks = YES; //setting tick properties
    self.xAxis.style.minorTickStyle.showTicks = NO;
    self.xAxis.style.majorTickStyle.lineColor = [UIColor grayColor];
    self.xAxis.style.majorTickStyle.lineWidth = @0.5;
    self.xAxis.style.lineWidth = @1; //setting axis width
    yAxis.style.lineWidth = @1;
    
    // add to the view
    [self.view addSubview:self.mPaymentsChart];
    
    self.mPaymentsChart.datasource = self;
    self.mPaymentsChart.delegate = self;
    // show the legend
    
    self.mPaymentsChart.clipsToBounds = NO;
    
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 1 home payment %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];

        float homeMortgage = rintf([homeAndLoan getTotalMonthlyPayment]);
        mPaymentData[0] = @{@"" : [NSNumber numberWithFloat:userProfile.mMonthlyRent]};
        mPaymentData[1] = @{@"" : [NSNumber numberWithFloat:homeMortgage]};
        
        self.monthlyMortgagePayment = homeMortgage;
        self.annualMortgagePayment = homeMortgage * NUMBER_OF_MONTHS_IN_YEAR;
        self.annualRentPayment = userProfile.mMonthlyRent * NUMBER_OF_MONTHS_IN_YEAR;
        self.monthlyRentPayment = userProfile.mMonthlyRent;
        self.monthlyPaymentsDifference = fabsf(self.monthlyMortgagePayment - self.monthlyRentPayment);
        self.annualPaymentsDifference = fabsf(self.annualMortgagePayment - self.annualRentPayment);
        
        self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.monthlyMortgagePayment]];
        self.rentComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:
                                        [NSNumber numberWithLong:self.monthlyRentPayment]];
        self.mPaymentsDifference.text = [Utilities getCurrencyFormattedStringForNumber:
                                         [NSNumber numberWithLong:self.monthlyPaymentsDifference]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        self.mHomeNickName2.text = aHome.mIdentifiyingHomeFeature;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomePaymentViewDelegate setNavTitle:@"Total Payment"];
}

-(IBAction)addAHomeTapped:(id)sender
{
    uint currentCount = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    self.mHomeInfoViewController = [[HomeInfoEntryViewController alloc] initAsHomeNumber:currentCount];
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!IS_WIDESCREEN)
    {
        self.mHomePaymentView.frame = CGRectMake(0, 310, self.mHomePaymentView.frame.size.width, self.mHomePaymentView.frame.size.height);
        self.mAddAHomeButton.frame = CGRectMake(self.mAddAHomeButton.frame.origin.x, 400, self.mAddAHomeButton.frame.size.width, self.mAddAHomeButton.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 175, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyPaymentButton.selected = true;

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
    //    lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
    }
    else if(index == 1) {
    //    lineSeries.title = @"Home 1";
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
    NSString* key = mPaymentData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = mPaymentData[seriesIndex][key];
    datapoint.yValue = key;
    return datapoint;
}

- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyPaymentButton.selected = true;
    self.mAnnualPaymentButton.selected = false;
    
    self.xAxis.rangePaddingHigh = @500.0;
    self.xAxis.majorTickFrequency = @1000;
    
    mPaymentData[0] = @{@"" : [NSNumber numberWithFloat:self.monthlyRentPayment]};
    mPaymentData[1] = @{@"" : [NSNumber numberWithFloat:self.monthlyMortgagePayment]};
    
    self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.monthlyMortgagePayment]];
    self.rentComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithLong:self.monthlyRentPayment]];
    self.mPaymentsDifference.text = [Utilities getCurrencyFormattedStringForNumber:
                                     [NSNumber numberWithLong:self.monthlyPaymentsDifference]];
    
    self.mDifferenceTitle.text = @"Monthly Payment Difference";
    
    [self.mPaymentsChart reloadData];
    [self.mPaymentsChart redrawChartIncludePlotArea:(YES)];
}

- (IBAction)annualButtonTapped:(id)sender
{
    self.mMonthlyPaymentButton.selected = false;
    self.mAnnualPaymentButton.selected = true;
    
    self.xAxis.rangePaddingHigh = @5000.0;
    self.xAxis.majorTickFrequency = @10000;
    
    mPaymentData[0] = @{@"" : [NSNumber numberWithFloat:self.annualRentPayment]};
    mPaymentData[1] = @{@"" : [NSNumber numberWithFloat:self.annualMortgagePayment]};
    
    self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.annualMortgagePayment]];
    self.rentComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithLong:self.annualRentPayment]];
    self.mPaymentsDifference.text = [Utilities getCurrencyFormattedStringForNumber:
                                     [NSNumber numberWithLong:self.annualPaymentsDifference]];
    
    self.mDifferenceTitle.text = @"Annual Payment Difference";
    
    [self.mPaymentsChart reloadData];
    [self.mPaymentsChart redrawChartIncludePlotArea:(YES)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
