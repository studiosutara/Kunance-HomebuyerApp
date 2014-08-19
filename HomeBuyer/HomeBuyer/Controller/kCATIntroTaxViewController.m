//
//  kCATIntroTaxViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroTaxViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface kCATIntroTaxViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mTaxSavingsChart;

@end

@implementation kCATIntroTaxViewController
{
    NSDictionary* homeTaxSavings[2];
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
    // create the data
    if (IS_WIDESCREEN)
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(31, 148, 280, 208)];
    }
    else
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(31, 128, 280, 208)];
    }
    
    self.mTaxSavingsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxSavingsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mTaxSavingsChart.xAxis = xAxis;
    self.mTaxSavingsChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @500.0;
    self.mTaxSavingsChart.yAxis = yAxis;
 //   yAxis.title = @"Dollars ($)";
    self.mTaxSavingsChart.legend.hidden = NO;
    self.mTaxSavingsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
 //   self.mTaxSavingsChart.canvasAreaBackgroundColor = [UIColor clearColor];
    self.mTaxSavingsChart.plotAreaBackgroundColor = [UIColor clearColor];
    
    self.mTaxSavingsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mTaxSavingsChart.legend.style.symbolCornerRadius = @0;
    self.mTaxSavingsChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mTaxSavingsChart.legend.style.cornerRadius = @0;
    self.mTaxSavingsChart.legend.position = SChartLegendPositionMiddleRight;
    self.mTaxSavingsChart.gesturePanType = SChartGesturePanTypeNone;
    
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
    self.view.bounds = CGRectMake(0, 0, [Utilities getDeviceWidth], [Utilities getDeviceHeight]);
    UILabel* label= nil;
    UIImage* backImage = nil;
    
    //Renders based on screen size
    if (IS_WIDESCREEN)
    {
        backImage = [UIImage imageNamed:@"home-interior_03.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 65, 280, 40)];
    }
    else
    {
        backImage = [UIImage imageNamed:@"home-interior-iphone4_03.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 280, 40)];
    }

    
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = backImage;
    [self.view addSubview:backImageView];

    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Compare annual income tax savings across homes before you buy.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];
    
    //chart related
    
    homeTaxSavings[0] = @{@"Est. Annual Income Tax ($)" : @6000};
    homeTaxSavings[1] = @{@"Est. Annual Income Tax ($)" : @7800};
    
    [self setupChart];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Income Tax Savings" properties:Nil];
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = homeTaxSavings[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = homeTaxSavings[seriesIndex][key];
    return datapoint;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.style.lineColor = [UIColor darkGrayColor];
    lineSeries.style.showArea = YES;
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.animationEnabled = YES;
    if(index == 0) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
    }
    if(index == 1) {
        lineSeries.title = @"Home 2";
        lineSeries.style.areaColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:0.95];
    }
    return lineSeries;
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
