//
//  TwoHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeTaxSavingsViewController.h"
#import "kCATCalculator.h"


@interface TwoHomeTaxSavingsViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) SChartNumberAxis* xAxis;
@property (nonatomic) float home1Taxes;
@property (nonatomic) float home1AnnualTaxes;
@property (nonatomic) float home2Taxes;
@property (nonatomic) float home2AnnualTaxes;
@property (nonatomic) float rentalTaxes;
@property (nonatomic) float rentalAnnualTaxes;
@property (nonatomic) float home1MonthlyTaxSavings;
@property (nonatomic) float home2MonthlyTaxSavings;
@property (nonatomic) float home1AnnualTaxSavings;
@property (nonatomic) float home2AnnualTaxSavings;
@end

@implementation TwoHomeTaxSavingsViewController
{
    NSDictionary* homeTaxSavings[3];
    NSDictionary* oldFont;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:oldFont];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeTaxSavingsDelegate setNavTitle:@"Taxes Due"];
    oldFont = self.navigationController.navigationBar.titleTextAttributes;
    
    UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

-(void) setupOtherLabels
{
}

-(void) setupChart
{
    // create the data
    
    if (IS_WIDESCREEN)
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 240, 190, 160)];
    }
    else
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 275, 190, 140)];
    }
    
    self.mTaxSavingsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxSavingsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init]; //allocating y-Axis
    yAxis.style.interSeriesPadding = @0;
    self.mTaxSavingsChart.yAxis = yAxis;
    self.mTaxSavingsChart.backgroundColor = [UIColor clearColor];
    self.xAxis = [[SChartNumberAxis alloc] init]; //allocation x-Axis
    self.xAxis.rangePaddingHigh = @500.0;
    if (self.rentalTaxes < 2000) //setting tick frequency based on the highest number
    {
        self.xAxis.majorTickFrequency = @500;
    }
    else
    {
        self.xAxis.majorTickFrequency = @1000;
    }
    self.mTaxSavingsChart.xAxis = self.xAxis;
    self.mTaxSavingsChart.legend.hidden = YES;
    yAxis.title = @"Est. Taxes ($)";
    self.mTaxSavingsChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mTaxSavingsChart.gesturePanType = SChartGesturePanTypeNone;
    
    self.xAxis.style.majorTickStyle.showTicks = YES; //setting tick properties
    self.xAxis.style.minorTickStyle.showTicks = NO;
    self.xAxis.style.majorTickStyle.lineColor = [UIColor grayColor];
    self.xAxis.style.majorTickStyle.lineWidth = @0.5;
    self.xAxis.style.lineWidth = @1; //setting axis width
    yAxis.style.lineWidth = @1;
    
    self.mTaxSavingsChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mTaxSavingsChart];
    
    self.mTaxSavingsChart.datasource = self;
    self.mTaxSavingsChart.delegate = self;
    
    self.mTaxSavingsChart.clipsToBounds = NO;
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
        NSLog(@"Invalid status to be in Dash 2 home taxes %d",
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
        
        self.home1AnnualTaxes = rintf(([home1Calc getAnnualFederalTaxesPaid]+
                            [home1Calc getAnnualStateTaxesPaid]));
        
        self.home2AnnualTaxes = rintf(([home2Calc getAnnualFederalTaxesPaid]+
                            [home2Calc getAnnualStateTaxesPaid]));
        
        self.rentalAnnualTaxes = rintf(([rentalCalc getAnnualFederalTaxesPaid]+
                            [rentalCalc getAnnualStateTaxesPaid]));
        
        self.home1Taxes = self.home1AnnualTaxes / NUMBER_OF_MONTHS_IN_YEAR;
        self.home2Taxes = self.home2AnnualTaxes / NUMBER_OF_MONTHS_IN_YEAR;
        self.rentalTaxes = self.rentalAnnualTaxes / NUMBER_OF_MONTHS_IN_YEAR;
        
        homeTaxSavings[0] = @{@"" : [NSNumber numberWithInteger:self.rentalTaxes]};
        homeTaxSavings[1] = @{@"" : [NSNumber numberWithInteger:self.home1Taxes]};
        homeTaxSavings[2] = @{@"" : [NSNumber numberWithInteger:self.home2Taxes]};
        
        self.home1MonthlyTaxSavings = fabsf(self.rentalTaxes - self.home1Taxes);
        self.home2MonthlyTaxSavings = fabsf(self.rentalTaxes - self.home2Taxes);
        self.home1AnnualTaxSavings = fabsf(self.rentalAnnualTaxes - self.home1AnnualTaxes);
        self.home2AnnualTaxSavings = fabsf(self.rentalAnnualTaxes - self.home2AnnualTaxes);

        self.mEstRentalUnitTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentalTaxes]];
        self.mEstFirstHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1Taxes]];
        self.mEstSecondHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2Taxes]];

        self.mHome1TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1MonthlyTaxSavings]];
        self.mHome2TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2MonthlyTaxSavings]];
        
        self.mHome1Nickname.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nickname.text = home2.mIdentifiyingHomeFeature;
        self.mHome1Nicknamex2.text = home1.mIdentifiyingHomeFeature;
        self.mHome2Nicknamex2.text = home2.mIdentifiyingHomeFeature;
        
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2TaxCompareView.frame = CGRectMake(self.mHome2TaxCompareView.frame.origin.x
                                                     , 330, self.mHome2TaxCompareView.frame.size.width, self.mHome2TaxCompareView.frame.size.height);
        self.mTimeView.frame = CGRectMake(self.mTimeView.frame.origin.x, 220, self.mTimeView.frame.size.width, self.mTimeView.frame.size.height);
    }
    
    self.mMonthlyTaxesDueButton.selected = true;

    [self setupChart];
    [self setupOtherLabels];
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
      //  lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
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
    NSString* key = homeTaxSavings[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = homeTaxSavings[seriesIndex][key];
    datapoint.yValue = key;
    return datapoint;
}

- (IBAction)monthlyButtonTapped:(id)sender
{
    self.mMonthlyTaxesDueButton.selected = true;
    self.mAnnualTaxesDueButton.selected = false;
    
    self.xAxis.rangePaddingHigh = @500.0;
    if (self.rentalTaxes < 2000)
    {
        self.xAxis.majorTickFrequency = @500;
    }
    else
    {
        self.xAxis.majorTickFrequency = @1000;
    }
    
    homeTaxSavings[0] = @{@"" : [NSNumber numberWithInteger:self.rentalTaxes]};
    homeTaxSavings[1] = @{@"" : [NSNumber numberWithInteger:self.home1Taxes]};
    homeTaxSavings[2] = @{@"" : [NSNumber numberWithInteger:self.home2Taxes]};
    
    self.mEstRentalUnitTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentalTaxes]];
    self.mEstFirstHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1Taxes]];
    self.mEstSecondHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2Taxes]];
    
    self.mHome1TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1MonthlyTaxSavings]];
    self.mHome2TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2MonthlyTaxSavings]];
    
    self.mDifferenceTitle.text = @"Monthly Tax Savings";
    
    [self.mTaxSavingsChart reloadData];
    [self.mTaxSavingsChart redrawChartIncludePlotArea:(YES)];
}

- (IBAction)annualButtonTapped:(id)sender
{
    self.mMonthlyTaxesDueButton.selected = false;
    self.mAnnualTaxesDueButton.selected = true;
    
    if (self.rentalAnnualTaxes < 20000)
    {
        self.xAxis.rangePaddingHigh = @2000.0;
        self.xAxis.majorTickFrequency = @5000;
    }
    else
    {
        self.xAxis.rangePaddingHigh = @5000.0;
        self.xAxis.majorTickFrequency = @10000;
    }
    
    homeTaxSavings[0] = @{@"" : [NSNumber numberWithInteger:self.rentalAnnualTaxes]};
    homeTaxSavings[1] = @{@"" : [NSNumber numberWithInteger:self.home1AnnualTaxes]};
    homeTaxSavings[2] = @{@"" : [NSNumber numberWithInteger:self.home2AnnualTaxes]};
    
    self.mEstRentalUnitTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.rentalAnnualTaxes]];
    self.mEstFirstHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1AnnualTaxes]];
    self.mEstSecondHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2AnnualTaxes]];
    
    self.mHome1TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home1AnnualTaxSavings]];
    self.mHome2TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:self.home2AnnualTaxSavings]];
    
    self.mDifferenceTitle.text = @"Annual Tax Savings";
    
    [self.mTaxSavingsChart reloadData];
    [self.mTaxSavingsChart redrawChartIncludePlotArea:(YES)];
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
